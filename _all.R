## ----setup, message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(glmnet)     # LASSO variable selection
  library(sandwich)   # cluster-robust covariance
  library(lmtest)     # coeftest() with a supplied vcov
  library(broom)
})

set.seed(123)
options(scipen = 999, digits = 4)


## ----load-data, message=FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------------
raw <- read_csv("data/metro_acs_model_ready_2010_2023.csv", show_col_types = FALSE) %>%
  mutate(across(c(year, GEOID), as.integer)) %>%
  # The panel is supposed to be one row per (GEOID, year), but 24 metro-years
  # arrive twice -- these are metros with two teams in one league (e.g. two
  # college-football programs), each row carrying that league's own numbers.
  # Collapse them to a single metro-year (mean of the numeric columns) so every
  # downstream step -- the log(), the NBA join, and especially the league
  # pivot_wider in the encode-win chunk -- gets the unique key it assumes.
  group_by(GEOID, year) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE)),
            across(!where(is.numeric), first), .groups = "drop")

# --- NBA as a full league ---------------------------------------------------
# The model-ready panel shipped only a `has_NBA` flag, not NBA performance, so
# NBA is built here from its raw files and joined in as nfl/mlb/nhl/cfb already
# are: one nba_win_pct / nba_make_playoffs / nba_make_playoffs_prev /
# nba_murder_rate per (GEOID, year). Teams are crosswalked to metros via the
# CBSA principal-city name, restricted to the metros already in the panel.
nba_cols <- local({
  cb  <- read_csv("data/metro_acs_2022_cbsa.csv", show_col_types = FALSE) %>%
    dplyr::select(GEOID, NAME) %>% mutate(GEOID = as.integer(GEOID))
  stats <- read_csv("data/NBA/nba_team_stats_2003_2023.csv", show_col_types = FALSE)
  mur   <- read_csv("data/NBA/nba_cities_murder_rates_2003_2026.csv", show_col_types = FALSE)
  apps  <- read_csv("data/NBA/nba_playoff_appearances_since_2003.csv", show_col_types = FALSE)

  # principal city of each panel metro (e.g. "Atlanta-Sandy Springs..." -> "Atlanta")
  panel <- raw %>% distinct(GEOID) %>% left_join(cb, by = "GEOID") %>%
    mutate(city = NAME %>% str_remove(",.*$") %>% str_remove("-.*$"))
  norm  <- function(x) x %>% str_replace("New York City", "New York") %>%
    str_replace("Washington D.C.", "Washington")
  xwalk <- mur %>% distinct(City) %>% mutate(city = norm(City)) %>%
    inner_join(panel, by = "city") %>% dplyr::select(City, city, GEOID)

  # team -> GEOID: current names via the murder file, with a city-name-prefix
  # fallback so relocated/renamed franchises (e.g. Charlotte Bobcats) still map
  team2geo <- mur %>% distinct(`NBA Team`, City) %>% inner_join(xwalk, by = "City") %>%
    dplyr::select(team = `NBA Team`, GEOID)
  city_lut <- xwalk %>% distinct(city, GEOID)
  resolve  <- function(teams) {
    g <- team2geo$GEOID[match(teams, team2geo$team)]
    fb <- map_int(teams, function(t) {
      hit <- str_starts(t, fixed(city_lut$city))
      if (any(hit)) city_lut$GEOID[hit][which.max(nchar(city_lut$city[hit]))] else NA_integer_
    })
    ifelse(is.na(g), fb, g)
  }

  # metro-year aggregates (multiple teams in a metro are averaged; playoffs = any)
  win <- stats %>% mutate(GEOID = resolve(team)) %>% filter(!is.na(GEOID)) %>%
    group_by(GEOID, year) %>% summarise(nba_win_pct = mean(win_loss_perc), .groups = "drop")
  po  <- apps %>% separate_rows(Years, sep = "; ") %>%
    mutate(year = as.integer(Years), GEOID = resolve(Team)) %>% filter(!is.na(GEOID)) %>%
    distinct(GEOID, year) %>% mutate(nba_make_playoffs = 1L)
  mrd <- mur %>% inner_join(xwalk, by = "City") %>% group_by(GEOID, Year) %>%
    summarise(nba_murder_rate = mean(`Murder Rate (per 100k)`), .groups = "drop") %>%
    rename(year = Year)

  win %>%
    full_join(po,  by = c("GEOID", "year")) %>%
    full_join(mrd, by = c("GEOID", "year")) %>%
    mutate(nba_make_playoffs = replace_na(nba_make_playoffs, 0L)) %>%
    arrange(GEOID, year) %>% group_by(GEOID) %>%
    mutate(nba_make_playoffs_prev = lag(nba_make_playoffs)) %>% ungroup()
})

raw <- raw %>% left_join(nba_cols, by = c("GEOID", "year"))
# ---------------------------------------------------------------------------

# Time-varying census controls (metro-level). Fixed effects absorb everything
# time-invariant, and each concept appears once (rates, not the raw counts they
# are built from) to avoid the rank-deficiency the earlier all-columns model hit.
controls <- c("log_income", "unemployment_rate", "poverty_rate",
              "log_home_value", "log_pop",
              "race_black_nonhispanic_rate", "hispanic_or_latino_rate",
              "bachelors_plus_rate", "pop_18_to_64_rate")

base <- raw %>%
  mutate(
    log_income     = log(median_household_income),
    log_home_value = log(median_home_value),
    log_pop        = log(total_population),
    # log the murder rate once here at the top -- every per-sport rate has no
    # zeros (min 0.28), so plain log() is safe. All downstream outcomes
    # (murder_rate in `long`/`enc`, city_murder_rate in `wide`) are therefore
    # already on the log scale and the model formulas need no log() themselves.
    across(ends_with("_murder_rate"), log)
  )


## --------------------------------------------------------------------------------------------------------------------------------------------------------------

raw
unique(colnames(raw))


## ----stack-panel, message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------------------------
leagues <- c("nfl", "mlb", "nhl", "cfb", "nba")

# Stack every league into one long panel: one row per (metro, year, team) that
# actually exists. Each league contributes its own murder rate + performance.
# This is the intermediate, team-level table -- it is then collapsed below.
team_long <- map_dfr(leagues, function(lg) {
  base %>%
    transmute(
      GEOID, year, league = toupper(lg),
      murder_rate        = .data[[paste0(lg, "_murder_rate")]],
      win_pct            = .data[[paste0(lg, "_win_pct")]],
      make_playoffs      = .data[[paste0(lg, "_make_playoffs")]],
      make_playoffs_prev = .data[[paste0(lg, "_make_playoffs_prev")]],
      across(all_of(controls))
    ) %>%
    filter(!is.na(murder_rate), !is.na(win_pct))
}) %>%
  # standardize win % WITHIN league so a pooled coefficient = effect of a
  # 1-SD-better season, comparable across sports
  group_by(league) %>%
  mutate(win_pct_z = as.numeric(scale(win_pct))) %>%
  ungroup() %>%
  # lagged (previous-season) standardized win %, within each team
  mutate(team_id = paste(GEOID, league, sep = "_")) %>%
  group_by(team_id) %>%
  arrange(year, .by_group = TRUE) %>%
  mutate(win_pct_prev_z = lag(win_pct_z)) %>%
  ungroup() %>%
  # drop NA on every model variable so the fitted rows match the cluster vector
  drop_na(all_of(c("win_pct_z", "win_pct_prev_z", "make_playoffs",
                   "make_playoffs_prev", "murder_rate", controls)))

# Collapse to ONE observation per (metro, year): the 2015 Knicks and 2015 Giants
# stop being two separate rows and become a single 2015 row for their metro.
# Each team's within-league-standardized performance is AVERAGED across the
# metro's teams; the playoff flags become the SHARE of the metro's teams that
# made the playoffs; the murder rate is the mean of the present teams' city
# rates. Census controls are metro-level, so they are identical across a metro's
# teams -- first() just carries one copy through.
long <- team_long %>%
  group_by(GEOID, year) %>%
  summarise(
    n_teams            = n(),
    # murder_rate is already logged (base logs every *_murder_rate once, up top),
    # so averaging the present teams' logged city rates keeps the metro-year
    # outcome on the log scale -- same construction as wide's city_murder_rate.
    murder_rate        = mean(murder_rate),
    win_pct_z          = mean(win_pct_z),
    win_pct_prev_z     = mean(win_pct_prev_z),
    make_playoffs      = mean(make_playoffs),       # share of teams making playoffs
    make_playoffs_prev = mean(make_playoffs_prev),
    across(all_of(controls), first),
    .groups = "drop"
  )

tibble(
  observations = nrow(long),
  metros = n_distinct(long$GEOID),
  years = n_distinct(long$year),
  avg_teams_per_obs = round(mean(long$n_teams), 2)
)
count(long, n_teams)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
long


## ----fit, message=FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------------------
sports_terms <- c("win_pct_z", "win_pct_prev_z", "make_playoffs", "make_playoffs_prev")

rhs <- paste(c("win_pct_z", "win_pct_prev_z", "make_playoffs",
               "make_playoffs_prev", controls, "factor(year)"),
             collapse = " + ")

# pooled, no metro fixed effects (the "before" baseline). There is no single
# league per row any more (a metro-year mixes its leagues), so the old league
# intercepts are gone -- naive is now just the pooled cross-section.
fit_naive <- lm(as.formula(paste("murder_rate ~", rhs)), data = long)
# the same model WITH one fixed effect per metro (was per team; a metro-year is
# now one row, so the team FE collapses to a metro FE)
fit_fe    <- lm(as.formula(paste("murder_rate ~", rhs, "+ factor(GEOID)")), data = long)

# metro-clustered coefficients for the sports terms
clustered <- function(fit) {
  V <- sandwich::vcovCL(fit, cluster = long$GEOID, type = "HC1")
  broom::tidy(lmtest::coeftest(fit, vcov. = V)) %>%
    filter(term %in% sports_terms)
}


## ----lasso, message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------------------------------
lasso_form <- as.formula(
  paste("~", paste(c(sports_terms, controls, "factor(year)", "factor(GEOID)"),
                   collapse = " + ")))
X <- model.matrix(lasso_form, data = long)[, -1]
y <- long$murder_rate

# 0 = forced in (the fixed-effect dummies), 1 = penalized/selectable (everything else)
is_fe <- grepl("^factor\\(year\\)|^factor\\(GEOID\\)", colnames(X))
penalty <- ifelse(is_fe, 0, 1)
cat(ncol(X), "columns |", sum(is_fe), "fixed-effect dummies forced in |",
    sum(!is_fe), "penalized (sports + census)\n")

set.seed(123)
cv_lasso <- cv.glmnet(X, y, alpha = 1, penalty.factor = penalty, nfolds = 10)
plot(cv_lasso)

# substantive (non-fixed-effect) variables LASSO keeps at each lambda
kept <- function(s) {
  co <- coef(cv_lasso, s = s)[, 1]
  co <- co[co != 0 & !grepl("^factor\\(|Intercept", names(co))]
  tibble(variable = names(co), coefficient = round(co, 4))
}


## ----lasso-selected, message=FALSE, warning=FALSE--------------------------------------------------------------------------------------------------------------
cat("--- kept at lambda.min (looser) ---\n"); print(kept("lambda.min"))
cat("\n--- kept at lambda.1se (parsimonious) ---\n")
k1 <- kept("lambda.1se")
if (nrow(k1) == 0) cat("(none -- only the fixed effects survive)\n") else print(k1)


## ----post-lasso, message=FALSE, warning=FALSE------------------------------------------------------------------------------------------------------------------
selected <- kept("lambda.min")$variable
selected_sports <- intersect(selected, sports_terms)
selected_ctrls  <- intersect(selected, controls)

post_rhs <- paste(c(selected_sports, selected_ctrls,
                    "factor(year)", "factor(GEOID)"), collapse = " + ")
post_fit <- lm(as.formula(paste("murder_rate ~", post_rhs)), data = long)

V <- sandwich::vcovCL(post_fit, cluster = long$GEOID, type = "HC1")
broom::tidy(lmtest::coeftest(post_fit, vcov. = V)) %>%
  filter(term %in% sports_terms) %>%
  mutate(across(where(is.numeric), ~round(.x, 4)))


## ----results-table, message=FALSE, warning=FALSE---------------------------------------------------------------------------------------------------------------
nv <- clustered(fit_naive) %>% dplyr::select(term, naive_coef = estimate, naive_p = p.value)
fe <- clustered(fit_fe) %>%
  dplyr::select(term, fe_coef = estimate, fe_cluster_se = std.error, fe_p = p.value)

left_join(nv, fe, by = "term") %>%
  mutate(term = factor(term, levels = sports_terms)) %>%
  arrange(term) %>%
  mutate(across(where(is.numeric), ~round(.x, 4)))


## ----fit-stats, message=FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------------
tibble(
  model = c("naive (no metro FE)", "metro fixed effects"),
  n = nrow(long),
  # R^2 is dominated by the metro dummies in the FE model (each metro has its own
  # intercept), so a high value mostly reflects that murder rates differ across
  # cities, not covariate predictive power.
  r_squared = c(summary(fit_naive)$r.squared, summary(fit_fe)$r.squared),
  adj_r_squared = c(summary(fit_naive)$adj.r.squared, summary(fit_fe)$adj.r.squared)
)


## ----no-sports, message=FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------------
no_sports_rhs   <- paste(c(controls, "factor(year)", "factor(GEOID)"), collapse = " + ")
sports_only_rhs <- paste(sports_terms, collapse = " + ")

fit_no_sports   <- lm(as.formula(paste("murder_rate ~", no_sports_rhs)),   data = long)
fit_sports_only <- lm(as.formula(paste("murder_rate ~", sports_only_rhs)), data = long)

mse <- function(fit) mean(residuals(fit)^2)

tibble(
  model = c("sports factors only (no controls, no FE)",
            "no sports factors (controls + FE only)",
            "full model (sports + controls + FE)"),
  mse   = c(mse(fit_sports_only), mse(fit_no_sports), mse(fit_fe))
) %>%
  mutate(mse = round(mse, 4))


## ----wide-panel, message=FALSE, warning=FALSE------------------------------------------------------------------------------------------------------------------
leagues <- c("nfl", "mlb", "nhl", "cfb", "nba")
wps <- paste0(leagues, "_wp_s")             # within-sport scaled win_pct
mr  <- paste0(leagues, "_murder_rate")

wide <- base
# min-max scale each sport's win_pct within sport, onto a common [0, 1]
for (lg in leagues) {
  v <- wide[[paste0(lg, "_win_pct")]]
  wide[[paste0(lg, "_wp_s")]] <- (v - min(v, na.rm = TRUE)) /
                                 (max(v, na.rm = TRUE) - min(v, na.rm = TRUE))
}

wide <- wide %>%
  rowwise() %>%
  mutate(
    n_sports         = sum(!is.na(c_across(all_of(wps)))),
    city_murder_rate = mean(c_across(all_of(mr)), na.rm = TRUE),
    win_amean        = mean(c_across(all_of(wps)), na.rm = TRUE),
    win_hmean        = { x <- c_across(all_of(wps)); x <- x[!is.na(x)]
                         x <- pmax(x, 0.001); length(x) / sum(1 / x) },
    # fraction of the metro's present teams that made the playoffs (aggregated
    # to match the aggregated win_pct: a present team with no playoff row -> 0)
    playoff_share    = { present <- !is.na(c_across(all_of(wps)))
                         po <- c_across(all_of(paste0(leagues, "_make_playoffs")))
                         po <- ifelse(is.na(po), 0, po)
                         sum(po[present]) / sum(present) }
  ) %>%
  ungroup() %>%
  filter(n_sports >= 1, !is.na(city_murder_rate)) %>%   # metro-years with >=1 team
  drop_na(all_of(controls))

# for the "separate" model: presence flag per sport, and absent win_pct / playoff -> 0
# (the flag absorbs the level so the win_pct slope is identified only among teams that exist)
for (lg in leagues) {
  wide[[paste0("has_", lg)]] <- as.integer(!is.na(wide[[paste0(lg, "_wp_s")]]))
  wide[[paste0(lg, "_wp_s")]][is.na(wide[[paste0(lg, "_wp_s")]])] <- 0
  po <- wide[[paste0(lg, "_make_playoffs")]]; po[is.na(po)] <- 0
  wide[[paste0(lg, "_po")]] <- po
}

tibble(observations = nrow(wide),
       metros = n_distinct(wide$GEOID),
       years  = n_distinct(wide$year))


## ----three-models, message=FALSE, warning=FALSE----------------------------------------------------------------------------------------------------------------
base_rhs <- paste(c(controls, "factor(year)"), collapse = " + ")   # year categorical

# 1) separate: each sport's scaled win_pct + playoff (+ presence flag)
sep_terms <- as.vector(rbind(paste0("has_", leagues), wps, paste0(leagues, "_po")))
fit_separate <- lm(as.formula(paste("city_murder_rate ~",
                     paste(sep_terms, collapse = " + "), "+", base_rhs)), data = wide)

# 2) harmonic mean of win_pct + aggregated playoff appearances
fit_harmonic <- lm(as.formula(paste("city_murder_rate ~ n_sports + win_hmean + playoff_share +",
                     base_rhs)), data = wide)

# 3) arithmetic mean of win_pct + aggregated playoff appearances
fit_average  <- lm(as.formula(paste("city_murder_rate ~ n_sports + win_amean + playoff_share +",
                     base_rhs)), data = wide)


## ----fit average coeffecients----------------------------------------------------------------------------------------------------------------------------------
summary(fit_average)


## ----three-models-mse, message=FALSE, warning=FALSE------------------------------------------------------------------------------------------------------------
mse <- function(fit) mean(residuals(fit)^2)

tibble(
  model = c("1. separate win_pct + playoffs per sport",
            "2. harmonic mean of win_pct + playoff share",
            "3. arithmetic mean of win_pct + playoff share"),
  n            = nrow(wide),
  n_predictors = c(length(coef(fit_separate)),
                   length(coef(fit_harmonic)),
                   length(coef(fit_average))),
  MSE          = round(c(mse(fit_separate), mse(fit_harmonic), mse(fit_average)), 4)
)


## ----summary-helper, message=FALSE, warning=FALSE--------------------------------------------------------------------------------------------------------------
# Every model here IS a fixed-effects model (metro + year FE are always in the
# formula). This does not change the model -- it only hides the ~80
# factor(GEOID)/factor(year) dummy rows from the printed summary so the win,
# playoff, and census coefficients are readable.
summary_hide_fe <- function(fit) {
  s <- summary(fit)
  s$coefficients <- s$coefficients[!grepl("^factor\\(", rownames(s$coefficients)), ,
                                   drop = FALSE]
  # also drop the FE names from $aliased so print.summary.lm stays consistent
  # when the model has singular (dropped) fixed-effect dummies -- e.g. fit_sep
  if (!is.null(s$aliased)) s$aliased <- s$aliased[!grepl("^factor\\(", names(s$aliased))]
  s
}


## ----encode-win, message=FALSE, warning=FALSE------------------------------------------------------------------------------------------------------------------
leagues <- c("nfl", "mlb", "nhl", "cfb", "nba")

# strictly-positive within-sport scaled win_pct, for the harmonic mean only
team_enc <- team_long %>%
  group_by(league) %>%
  mutate(wp_pos = pmax((win_pct - min(win_pct)) / (max(win_pct) - min(win_pct)), 0.001)) %>%
  ungroup()

# metro-year aggregates: arithmetic mean of z, and harmonic mean of the scaled win_pct
agg <- team_enc %>%
  group_by(GEOID, year) %>%
  summarise(win_amean_z = mean(win_pct_z),
            win_hmean   = n() / sum(1 / wp_pos), .groups = "drop")

# each sport's win_pct_z spread to its own column; absent sport -> 0, + presence flag
# (dplyr:: qualified so a masked select() from another loaded package can't break it)
sep <- team_enc %>%
  dplyr::select(GEOID, year, league, win_pct_z) %>%
  pivot_wider(names_from = league, values_from = win_pct_z,
              names_glue = "wpz_{tolower(league)}")
for (lg in leagues) {
  z <- paste0("wpz_", lg)
  if (!z %in% names(sep)) sep[[z]] <- NA_real_
  sep[[paste0("has_", lg)]] <- as.integer(!is.na(sep[[z]]))
  sep[[z]][is.na(sep[[z]])] <- 0
}

# one modeling frame carrying all three encodings on the identical metro-year rows
enc <- long %>%
  dplyr::select(GEOID, year, murder_rate, win_pct_prev_z, make_playoffs,
                make_playoffs_prev, all_of(controls)) %>%
  left_join(agg, by = c("GEOID", "year")) %>%
  left_join(sep, by = c("GEOID", "year"))


## ----encode-fit, message=FALSE, warning=FALSE------------------------------------------------------------------------------------------------------------------
# everything except the contemporaneous win encoding is held identical
fe_rhs <- paste(c("win_pct_prev_z", "make_playoffs", "make_playoffs_prev",
                  controls, "factor(year)", "factor(GEOID)"), collapse = " + ")

fit_amean <- lm(as.formula(paste("murder_rate ~ win_amean_z +", fe_rhs)), data = enc)
fit_hmean <- lm(as.formula(paste("murder_rate ~ win_hmean +",   fe_rhs)), data = enc)
sep_terms <- c(paste0("wpz_", leagues), paste0("has_", leagues))
fit_sep   <- lm(as.formula(paste("murder_rate ~", paste(sep_terms, collapse = " + "),
                                 "+", fe_rhs)), data = enc)

# baseline: NONE of the sports variables (drop the win encodings, the lagged win,
# and the playoff shares) -- just census controls + metro FE + year FE
none_rhs  <- paste(c(controls, "factor(year)", "factor(GEOID)"), collapse = " + ")
fit_none  <- lm(as.formula(paste("murder_rate ~", none_rhs)), data = enc)

mse <- function(f) mean(residuals(f)^2)
tibble(
  model = c("0. no sports variables (controls + FE only)",
            "1. arithmetic mean of win_pct_z",
            "2. harmonic mean of win_pct",
            "3. separate win_pct_z per sport"),
  n            = nrow(enc),
  n_predictors = c(sum(!is.na(coef(fit_none))),
                   sum(!is.na(coef(fit_amean))),
                   sum(!is.na(coef(fit_hmean))),
                   sum(!is.na(coef(fit_sep)))),
  MSE          = round(c(mse(fit_none), mse(fit_amean),
                         mse(fit_hmean), mse(fit_sep)), 4)
)


## ----encode-coefs, message=FALSE, warning=FALSE----------------------------------------------------------------------------------------------------------------
# the win coefficients from each encoding (fixed effects suppressed)
summary_hide_fe(fit_amean)$coefficients[c("win_amean_z"), , drop = FALSE]
summary_hide_fe(fit_hmean)$coefficients[c("win_hmean"),   , drop = FALSE]
summary_hide_fe(fit_sep)$coefficients[sep_terms[sep_terms %in%
                        rownames(summary(fit_sep)$coefficients)], , drop = FALSE]


## ----summary-none----------------------------------------------------------------------------------------------------------------------------------------------
# 0. no sports variables (controls + metro FE + year FE)
summary_hide_fe(fit_none)


## ----summary-amean---------------------------------------------------------------------------------------------------------------------------------------------
# 1. arithmetic mean of win_pct_z
summary_hide_fe(fit_amean)


## ----summary-hmean---------------------------------------------------------------------------------------------------------------------------------------------
# 2. harmonic mean of win_pct
summary_hide_fe(fit_hmean)


## ----summary-sep-----------------------------------------------------------------------------------------------------------------------------------------------
# 3. separate win_pct_z per sport (+ presence flags)
summary_hide_fe(fit_sep)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
fit.test <- lm(city_murder_rate ~ has_MLB + has_NBA + has_NFL + has_power4_school + has_NHL, data = wide)

summary(fit.test)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
unique(colnames(wide))
hist(wide$city_murder_rate)

