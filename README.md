# Sports Team Performance & City Murder Rates

A panel-data study asking one question:

> **Does a sports team performing better move its city's murder rate?**

The project builds a stacked panel of U.S. metros across five leagues — **NFL, MLB,
NBA, NHL, and Power-4 college football (CFB)** — pairs each team's season with its
own city's crime, economic, and demographic data, and estimates the within-team,
year-over-year effect of winning on murder rates.

---

## Research design

The core identification strategy (see [modeling.rmd](modeling.rmd)) is deliberately
conservative:

- **One pooled model on a stacked panel** — one row per *(city, year, team)*, every
  league stacked together, rather than four separate league models or one imputed
  metro-year row.
- **Outcome:** each team's *own* city murder rate, paired with its *own* performance —
  never averaged across leagues, never median-imputed.
- **`win_pct` standardized within league** (z-score), so a single pooled coefficient
  means "effect of a 1-SD-better season" and is comparable across sports with very
  different win-percentage spreads (an NFL season swings far more than a 162-game MLB
  season).
- **Team fixed effects** (`factor(team_id)`) — the win-% effect is identified purely
  from a team's year-to-year swings, so stable city/team differences (big cities have
  teams *and* more crime) cannot drive it.
- **Year fixed effects** for nationwide crime trends.
- **Standard errors clustered by metro**, since a metro's rows (across years and
  leagues) are correlated.

Time-varying census controls include log income, unemployment, poverty, log home
value, log population, race/ethnicity rates, education, and working-age share.

---

## Repository layout

### Analysis notebooks / documents

| File | Purpose |
|------|---------|
| [Data_agg.rmd](Data_agg.rmd) | Pulls the ACS census panel (2010–2023) via **tidycensus** and builds the metro-level demographic/economic panel. |
| [EDA.ipynb](EDA.ipynb) | Exploratory data analysis (Python) — merges BEA GDP files and explores the raw data. |
| [modeling.rmd](modeling.rmd) | **Primary model.** Pooled stacked panel with team + year fixed effects and clustered SEs. |
| [modeling_baseline.rmd](modeling_baseline.rmd) | Baseline specification for comparison. |
| [modeling_original.rmd](modeling_original.rmd) | Earlier/original modeling approach (one metro-year row per league, with imputation). |
| [newmodel.rmd](newmodel.rmd) | Year-to-year murder rate vs. team performance using within-city z-scores. |
| [RFmodeling.rmd](RFmodeling.rmd) | Machine-learning variants: **Random Forest & XGBoost**. |
| [_all.R](_all.R) | Consolidated R script combining the modeling steps (adds NBA as a full league, etc.). |

Rendered outputs (`.html`) and generated plots (`figure/`, `Rplots.pdf`,
`modeling_original_files/`) accompany the source documents.

### Scripts

| File | Purpose |
|------|---------|
| [scripts/add_sports_features.R](scripts/add_sports_features.R) | Crosswalks team-level sports stats to metro (CBSA) areas and attaches win %, playoff appearances, and murder rates as model-ready features. |

### Data (`data/`)

| Path | Contents |
|------|----------|
| `data/NFL/` `data/MLB/` `data/NBA/` `data/NHL/` `data/CFB/` | Per-league raw inputs: team stats / win %, playoff appearances, city murder rates (2003–2026), and average temperatures. |
| `data/GDPData/` | BEA county/metro GDP files (2003–2025, in 5-ish-year slices). |
| `data/metro_acs_model_ready_2010_2023.csv` | **Main model input** — the assembled metro-year panel with sports features, crime, and ACS controls. |
| `data/metro_acs_panel_2010_2023.csv`, `metro_acs_2022_cbsa.csv`, `metro_lookup_2010_2023.csv` | Intermediate ACS panels and metro (CBSA) lookups. |
| `data/sports_teams_lookup.csv` | Team → metro crosswalk. |
| `data/sports_metro_crime_2015_2024_metro_agg.csv` | Metro-aggregated crime series. |
| `data/2025_ASR1MON_NATIONAL_MASTER_FILE.txt` | FBI UCR/ASR national crime master file (large raw source). |

Top-level `NFL_Cities_GDP_Master_2003_2025.csv` and `final_model_data.csv` are
assembled master tables produced along the way.

---

## Getting started

### Requirements

**R** (for the `.rmd` / `.R` analysis):

```r
install.packages(c(
  "tidyverse", "glmnet", "sandwich", "lmtest", "broom",
  "tidycensus", "randomForest", "xgboost"
))
```

**Python** (for `EDA.ipynb`): a Jupyter environment with `pandas` / `numpy`
(this repo was authored in Positron).

### Running the analysis

1. **Rebuild the census panel** (optional — a pre-built panel is already in `data/`):
   knit [Data_agg.rmd](Data_agg.rmd). This requires a
   [U.S. Census API key](https://api.census.gov/data/key_signup.html).
2. **Attach sports features:** run [scripts/add_sports_features.R](scripts/add_sports_features.R).
3. **Fit the main model:** knit [modeling.rmd](modeling.rmd) (or run [_all.R](_all.R)).
   Compare against `modeling_baseline.rmd`, `newmodel.rmd`, and `RFmodeling.rmd`.

Most documents read directly from `data/metro_acs_model_ready_2010_2023.csv`, so you
can jump straight to step 3 with the shipped data.

---

## ⚠️ Note on the Census API key

[Data_agg.rmd](Data_agg.rmd) currently contains a **hard-coded Census API key**. Before
sharing or version-controlling this project, replace it with your own key sourced from
an environment variable (e.g. `Sys.getenv("CENSUS_API_KEY")`) and treat the existing
key as compromised — anyone with the file can use it. Census API keys are free to
regenerate.

---

## Data sources

- **U.S. Census Bureau — American Community Survey (ACS)** 5-year estimates (via `tidycensus`)
- **Bureau of Economic Analysis (BEA)** — metro/county GDP
- **FBI Uniform Crime Reporting (UCR/ASR)** — murder / crime rates
- League team performance, playoff appearances, and city weather compiled per sport
