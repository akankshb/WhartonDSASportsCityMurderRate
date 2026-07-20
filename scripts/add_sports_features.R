feature_years <- 2010:2023

mlb_city_map <- c(
  "Minneapolis, MN" = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  "Milwaukee, WI" = "Milwaukee, WI Metro Area",
  "Boston, MA" = "Boston-Cambridge-Newton, MA-NH Metro Area",
  "Chicago, IL" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Detroit, MI" = "Detroit-Warren-Dearborn, MI Metro Area",
  "Denver, CO" = "Denver-Aurora-Centennial, CO Metro Area",
  "Cleveland, OH" = "Cleveland, OH Metro Area",
  "Pittsburgh, PA" = "Pittsburgh, PA Metro Area",
  "Seattle, WA" = "Seattle-Tacoma-Bellevue, WA Metro Area",
  "Kansas City, MO" = "Kansas City, MO-KS Metro Area",
  "Philadelphia, PA" = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  "New York, NY" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "Cincinnati, OH" = "Cincinnati, OH-KY-IN Metro Area",
  "Baltimore, MD" = "Baltimore-Columbia-Towson, MD Metro Area",
  "St. Louis, MO" = "St. Louis, MO-IL Metro Area",
  "Washington, D.C." = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area",
  "San Francisco, CA" = "San Francisco-Oakland-Fremont, CA Metro Area",
  "San Diego, CA" = "San Diego-Chula Vista-Carlsbad, CA Metro Area",
  "Anaheim / Los Angeles, CA" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Arlington / Dallas, TX" = "Dallas-Fort Worth-Arlington, TX Metro Area",
  "Atlanta, GA" = "Atlanta-Sandy Springs-Roswell, GA Metro Area",
  "Houston, TX" = "Houston-Pasadena-The Woodlands, TX Metro Area",
  "St. Petersburg / Tampa, FL" = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  "Phoenix, AZ" = "Phoenix-Mesa-Chandler, AZ Metro Area",
  "Miami, FL" = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area"
)

mlb_code_map <- c(
  ARI = "Phoenix-Mesa-Chandler, AZ Metro Area",
  ATL = "Atlanta-Sandy Springs-Roswell, GA Metro Area",
  BAL = "Baltimore-Columbia-Towson, MD Metro Area",
  BOS = "Boston-Cambridge-Newton, MA-NH Metro Area",
  CHC = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  CHW = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  CIN = "Cincinnati, OH-KY-IN Metro Area",
  CLE = "Cleveland, OH Metro Area",
  COL = "Denver-Aurora-Centennial, CO Metro Area",
  DET = "Detroit-Warren-Dearborn, MI Metro Area",
  HOU = "Houston-Pasadena-The Woodlands, TX Metro Area",
  KCR = "Kansas City, MO-KS Metro Area",
  LAA = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  LAD = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  MIA = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area",
  MIL = "Milwaukee, WI Metro Area",
  MIN = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  NYM = "New York-Newark-Jersey City, NY-NJ Metro Area",
  NYY = "New York-Newark-Jersey City, NY-NJ Metro Area",
  PHI = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  PIT = "Pittsburgh, PA Metro Area",
  SDP = "San Diego-Chula Vista-Carlsbad, CA Metro Area",
  SFG = "San Francisco-Oakland-Fremont, CA Metro Area",
  SEA = "Seattle-Tacoma-Bellevue, WA Metro Area",
  STL = "St. Louis, MO-IL Metro Area",
  TBR = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  TEX = "Dallas-Fort Worth-Arlington, TX Metro Area",
  TOR = "Toronto, ON Metro Area",
  WSN = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area",
  ATH = "San Francisco-Oakland-Fremont, CA Metro Area"
)

mlb_team_map <- c(
  "Arizona Diamondbacks" = "Phoenix-Mesa-Chandler, AZ Metro Area",
  "Atlanta Braves" = "Atlanta-Sandy Springs-Roswell, GA Metro Area",
  "Baltimore Orioles" = "Baltimore-Columbia-Towson, MD Metro Area",
  "Boston Red Sox" = "Boston-Cambridge-Newton, MA-NH Metro Area",
  "Chicago Cubs" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Chicago White Sox" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Cincinnati Reds" = "Cincinnati, OH-KY-IN Metro Area",
  "Cleveland Guardians" = "Cleveland, OH Metro Area",
  "Cleveland Indians" = "Cleveland, OH Metro Area",
  "Colorado Rockies" = "Denver-Aurora-Centennial, CO Metro Area",
  "Detroit Tigers" = "Detroit-Warren-Dearborn, MI Metro Area",
  "Houston Astros" = "Houston-Pasadena-The Woodlands, TX Metro Area",
  "Kansas City Royals" = "Kansas City, MO-KS Metro Area",
  "Los Angeles Angels" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Los Angeles Dodgers" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Miami Marlins" = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area",
  "Milwaukee Brewers" = "Milwaukee, WI Metro Area",
  "Minnesota Twins" = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  "New York Mets" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "New York Yankees" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "Oakland Athletics" = "San Francisco-Oakland-Fremont, CA Metro Area",
  "Philadelphia Phillies" = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  "Pittsburgh Pirates" = "Pittsburgh, PA Metro Area",
  "San Diego Padres" = "San Diego-Chula Vista-Carlsbad, CA Metro Area",
  "San Francisco Giants" = "San Francisco-Oakland-Fremont, CA Metro Area",
  "Seattle Mariners" = "Seattle-Tacoma-Bellevue, WA Metro Area",
  "St. Louis Cardinals" = "St. Louis, MO-IL Metro Area",
  "Tampa Bay Rays" = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  "Texas Rangers" = "Dallas-Fort Worth-Arlington, TX Metro Area",
  "Toronto Blue Jays" = "Toronto, ON Metro Area",
  "Washington Nationals" = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area"
)

nfl_city_map <- c(
  "Minneapolis-St. Paul, MN" = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  "Green Bay, WI" = "Green Bay, WI Metro Area",
  "Buffalo, NY" = "Buffalo-Cheektowaga, NY Metro Area",
  "Foxborough/Boston, MA" = "Boston-Cambridge-Newton, MA-NH Metro Area",
  "Chicago, IL" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Detroit, MI" = "Detroit-Warren-Dearborn, MI Metro Area",
  "Denver, CO" = "Denver-Aurora-Centennial, CO Metro Area",
  "Cleveland, OH" = "Cleveland, OH Metro Area",
  "Pittsburgh, PA" = "Pittsburgh, PA Metro Area",
  "Seattle, WA" = "Seattle-Tacoma-Bellevue, WA Metro Area",
  "Indianapolis, IN" = "Indianapolis-Carmel-Greenwood, IN Metro Area",
  "Kansas City, MO" = "Kansas City, MO-KS Metro Area",
  "Philadelphia, PA" = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  "New York, NY / East Rutherford, NJ" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "Cincinnati, OH" = "Cincinnati, OH-KY-IN Metro Area",
  "Baltimore, MD" = "Baltimore-Columbia-Towson, MD Metro Area",
  "Washington, D.C. / Landover, MD" = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area",
  "San Francisco / Santa Clara, CA" = "San Francisco-Oakland-Fremont, CA Metro Area",
  "Nashville, TN" = "Nashville-Davidson--Murfreesboro--Franklin, TN Metro Area",
  "Charlotte, NC" = "Charlotte-Concord-Gastonia, NC-SC Metro Area",
  "Atlanta, GA" = "Atlanta-Sandy Springs-Roswell, GA Metro Area",
  "Los Angeles, CA" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Dallas / Arlington, TX" = "Dallas-Fort Worth-Arlington, TX Metro Area",
  "Las Vegas / Paradise, NV" = "Las Vegas-Henderson-North Las Vegas, NV Metro Area",
  "Houston, TX" = "Houston-Pasadena-The Woodlands, TX Metro Area",
  "New Orleans, LA" = "New Orleans-Metairie, LA Metro Area",
  "Jacksonville, FL" = "Jacksonville, FL Metro Area",
  "Tampa, FL" = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  "Phoenix / Glendale, AZ" = "Phoenix-Mesa-Chandler, AZ Metro Area",
  "Miami / Miami Gardens, FL" = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area"
)

nfl_team_map <- c(
  "Arizona Cardinals" = "Phoenix-Mesa-Chandler, AZ Metro Area",
  "Atlanta Falcons" = "Atlanta-Sandy Springs-Roswell, GA Metro Area",
  "Baltimore Ravens" = "Baltimore-Columbia-Towson, MD Metro Area",
  "Buffalo Bills" = "Buffalo-Cheektowaga, NY Metro Area",
  "Carolina Panthers" = "Charlotte-Concord-Gastonia, NC-SC Metro Area",
  "Chicago Bears" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Cincinnati Bengals" = "Cincinnati, OH-KY-IN Metro Area",
  "Cleveland Browns" = "Cleveland, OH Metro Area",
  "Dallas Cowboys" = "Dallas-Fort Worth-Arlington, TX Metro Area",
  "Denver Broncos" = "Denver-Aurora-Centennial, CO Metro Area",
  "Detroit Lions" = "Detroit-Warren-Dearborn, MI Metro Area",
  "Green Bay Packers" = "Green Bay, WI Metro Area",
  "Houston Texans" = "Houston-Pasadena-The Woodlands, TX Metro Area",
  "Indianapolis Colts" = "Indianapolis-Carmel-Greenwood, IN Metro Area",
  "Jacksonville Jaguars" = "Jacksonville, FL Metro Area",
  "Kansas City Chiefs" = "Kansas City, MO-KS Metro Area",
  "Las Vegas Raiders" = "Las Vegas-Henderson-North Las Vegas, NV Metro Area",
  "Los Angeles Chargers" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Los Angeles Rams" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Miami Dolphins" = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area",
  "Minnesota Vikings" = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  "New England Patriots" = "Boston-Cambridge-Newton, MA-NH Metro Area",
  "New Orleans Saints" = "New Orleans-Metairie, LA Metro Area",
  "New York Giants" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "New York Jets" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "Oakland Raiders" = "San Francisco-Oakland-Fremont, CA Metro Area",
  "Philadelphia Eagles" = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  "Pittsburgh Steelers" = "Pittsburgh, PA Metro Area",
  "San Diego Chargers" = "San Diego-Chula Vista-Carlsbad, CA Metro Area",
  "San Francisco 49ers" = "San Francisco-Oakland-Fremont, CA Metro Area",
  "Seattle Seahawks" = "Seattle-Tacoma-Bellevue, WA Metro Area",
  "St. Louis Rams" = "St. Louis, MO-IL Metro Area",
  "Tampa Bay Buccaneers" = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  "Tennessee Titans" = "Nashville-Davidson--Murfreesboro--Franklin, TN Metro Area",
  "Washington Commanders" = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area",
  "Washington Football Team" = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area",
  "Washington Redskins" = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area"
)

nhl_city_map <- c(
  "St. Paul, MN" = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  "Buffalo, NY" = "Buffalo-Cheektowaga, NY Metro Area",
  "Boston, MA" = "Boston-Cambridge-Newton, MA-NH Metro Area",
  "Chicago, IL" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Detroit, MI" = "Detroit-Warren-Dearborn, MI Metro Area",
  "Denver, CO" = "Denver-Aurora-Centennial, CO Metro Area",
  "Columbus, OH" = "Columbus, OH Metro Area",
  "Pittsburgh, PA" = "Pittsburgh, PA Metro Area",
  "Salt Lake City, UT" = "Salt Lake City, UT Metro Area",
  "Seattle, WA" = "Seattle-Tacoma-Bellevue, WA Metro Area",
  "New York, NY / Newark, NJ" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "Philadelphia, PA" = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  "St. Louis, MO" = "St. Louis, MO-IL Metro Area",
  "Washington, D.C." = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area",
  "San Jose, CA" = "San Jose-Sunnyvale-Santa Clara, CA Metro Area",
  "Nashville, TN" = "Nashville-Davidson--Murfreesboro--Franklin, TN Metro Area",
  "Raleigh, NC" = "Raleigh, NC Metro Area",
  "Anaheim / Los Angeles, CA" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Dallas, TX" = "Dallas-Fort Worth-Arlington, TX Metro Area",
  "Las Vegas, NV" = "Las Vegas-Henderson-North Las Vegas, NV Metro Area",
  "Tampa, FL" = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  "Sunrise / Miami, FL" = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area"
)

nhl_team_map <- c(
  "Anaheim Ducks" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Arizona Coyotes" = "Phoenix-Mesa-Chandler, AZ Metro Area",
  "Boston Bruins" = "Boston-Cambridge-Newton, MA-NH Metro Area",
  "Buffalo Sabres" = "Buffalo-Cheektowaga, NY Metro Area",
  "Carolina Hurricanes" = "Raleigh, NC Metro Area",
  "Chicago Blackhawks" = "Chicago-Naperville-Elgin, IL-IN Metro Area",
  "Colorado Avalanche" = "Denver-Aurora-Centennial, CO Metro Area",
  "Columbus Blue Jackets" = "Columbus, OH Metro Area",
  "Dallas Stars" = "Dallas-Fort Worth-Arlington, TX Metro Area",
  "Detroit Red Wings" = "Detroit-Warren-Dearborn, MI Metro Area",
  "Florida Panthers" = "Miami-Fort Lauderdale-West Palm Beach, FL Metro Area",
  "Los Angeles Kings" = "Los Angeles-Long Beach-Anaheim, CA Metro Area",
  "Minnesota Wild" = "Minneapolis-St. Paul-Bloomington, MN-WI Metro Area",
  "Nashville Predators" = "Nashville-Davidson--Murfreesboro--Franklin, TN Metro Area",
  "New Jersey Devils" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "New York Islanders" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "New York Rangers" = "New York-Newark-Jersey City, NY-NJ Metro Area",
  "Philadelphia Flyers" = "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area",
  "Pittsburgh Penguins" = "Pittsburgh, PA Metro Area",
  "San Jose Sharks" = "San Jose-Sunnyvale-Santa Clara, CA Metro Area",
  "St. Louis Blues" = "St. Louis, MO-IL Metro Area",
  "Tampa Bay Lightning" = "Tampa-St. Petersburg-Clearwater, FL Metro Area",
  "Vegas Golden Knights" = "Las Vegas-Henderson-North Las Vegas, NV Metro Area",
  "Washington Capitals" = "Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area"
)

power4_school_lookup <- read_csv("data/CFB/cfb_power4_2010_2025_long.csv", show_col_types = FALSE) %>%
  distinct(school, city, state) %>%
  left_join(power4_city_map, by = c("city", "state")) %>%
  filter(!is.na(metro_name))

metro_geoid_lookup <- metro_lookup %>%
  distinct(GEOID, NAME)

mlb_features <- read_csv("data/MLB/mlb_cities_average_temperatures.csv", show_col_types = FALSE) %>%
  mutate(metro_name = unname(mlb_city_map[City])) %>%
  filter(!is.na(metro_name)) %>%
  group_by(metro_name) %>%
  summarise(mlb_avg_temp = mean(as.numeric(`Approx. Annual Average Temp (°F)`), na.rm = TRUE), .groups = "drop") %>%
  tidyr::crossing(year = feature_years) %>%
  full_join(
    read_csv("data/MLB/MLB_win_pct.csv", show_col_types = FALSE) %>%
      pivot_longer(-Year, names_to = "code", values_to = "win_pct") %>%
      filter(Year %in% feature_years, !is.na(win_pct)) %>%
      mutate(metro_name = unname(mlb_code_map[code])) %>%
      filter(!is.na(metro_name)) %>%
      group_by(year = Year, metro_name) %>%
      summarise(mlb_win_pct = mean(as.numeric(win_pct), na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/MLB/mlb_playoff_appearances_since_2003.csv", show_col_types = FALSE) %>%
      separate_rows(Years, sep = ";\\s*") %>%
      mutate(
        year = as.integer(Years),
        made_playoffs = 1L,
        metro_name = unname(mlb_team_map[Team])
      ) %>%
      filter(year %in% feature_years, !is.na(metro_name)) %>%
      arrange(Team, year) %>%
      group_by(Team) %>%
      mutate(made_playoffs_prev = lag(made_playoffs, default = 0L)) %>%
      ungroup() %>%
      group_by(year, metro_name) %>%
      summarise(
        mlb_make_playoffs = as.integer(any(made_playoffs == 1L)),
        mlb_make_playoffs_prev = as.integer(any(made_playoffs_prev == 1L)),
        .groups = "drop"
      ),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/MLB/mlb_cities_murder_rates_2003_2026.csv", show_col_types = FALSE) %>%
      mutate(year = Year, metro_name = unname(mlb_team_map[`MLB Team`])) %>%
      filter(year %in% feature_years, !is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(mlb_murder_rate = mean(`Murder Rate (per 100k)`, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  )

nfl_features <- read_csv("data/NFL/nfl_cities_average_temperatures.csv", show_col_types = FALSE) %>%
  mutate(metro_name = unname(nfl_city_map[City])) %>%
  filter(!is.na(metro_name)) %>%
  group_by(metro_name) %>%
  summarise(nfl_avg_temp = mean(as.numeric(`Approx. Annual Average Temp (°F)`), na.rm = TRUE), .groups = "drop") %>%
  tidyr::crossing(year = feature_years) %>%
  full_join(
    read_csv("data/NFL/NFL_team_stats_2003_2023.csv", show_col_types = FALSE) %>%
      filter(year %in% feature_years) %>%
      mutate(metro_name = unname(nfl_team_map[team])) %>%
      filter(!is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(nfl_win_pct = mean(win_loss_perc, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/NFL/nfl_playoff_appearances_since_2003.csv", show_col_types = FALSE) %>%
      separate_rows(Years, sep = ";\\s*") %>%
      mutate(
        year = as.integer(Years),
        made_playoffs = 1L,
        metro_name = unname(nfl_team_map[Team])
      ) %>%
      filter(year %in% feature_years, !is.na(metro_name)) %>%
      arrange(Team, year) %>%
      group_by(Team) %>%
      mutate(made_playoffs_prev = lag(made_playoffs, default = 0L)) %>%
      ungroup() %>%
      group_by(year, metro_name) %>%
      summarise(
        nfl_make_playoffs = as.integer(any(made_playoffs == 1L)),
        nfl_make_playoffs_prev = as.integer(any(made_playoffs_prev == 1L)),
        .groups = "drop"
      ),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/NFL/nfl_cities_murder_rates_2003_2026.csv", show_col_types = FALSE) %>%
      mutate(year = Year, metro_name = unname(nfl_team_map[`NFL Team`])) %>%
      filter(year %in% feature_years, !is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(nfl_murder_rate = mean(`Murder Rate (per 100k)`, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  )

nhl_features <- read_csv("data/NHL/nhl_cities_average_temperatures.csv", show_col_types = FALSE) %>%
  mutate(metro_name = unname(nhl_city_map[City])) %>%
  filter(!is.na(metro_name)) %>%
  group_by(metro_name) %>%
  summarise(nhl_avg_temp = mean(as.numeric(`Approx. Annual Average Temp (°F)`), na.rm = TRUE), .groups = "drop") %>%
  tidyr::crossing(year = feature_years) %>%
  full_join(
    read_csv("data/NHL/nhl_combined_2010_2023.csv", show_col_types = FALSE) %>%
      filter(year %in% feature_years) %>%
      mutate(metro_name = unname(nhl_team_map[team])) %>%
      filter(!is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(nhl_win_pct = mean(win_loss_perc, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/NHL/nhl_combined_2010_2023.csv", show_col_types = FALSE) %>%
      filter(year %in% feature_years) %>%
      mutate(
        metro_name = unname(nhl_team_map[team]),
        make_playoffs = as.integer(make_playoffs)
      ) %>%
      filter(!is.na(metro_name)) %>%
      arrange(team, year) %>%
      group_by(team) %>%
      mutate(make_playoffs_prev = lag(make_playoffs, default = 0L)) %>%
      ungroup() %>%
      group_by(year, metro_name) %>%
      summarise(
        nhl_make_playoffs = as.integer(any(make_playoffs == 1L)),
        nhl_make_playoffs_prev = as.integer(any(make_playoffs_prev == 1L)),
        .groups = "drop"
      ),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/NHL/nhl_cities_murder_rates_2003_2026.csv", show_col_types = FALSE) %>%
      mutate(year = Year, metro_name = unname(nhl_team_map[`NHL Team`])) %>%
      filter(year %in% feature_years, !is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(nhl_murder_rate = mean(`Murder Rate (per 100k)`, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  )

cfb_features <- power4_school_lookup %>%
  tidyr::crossing(year = feature_years) %>%
  full_join(
    read_csv("data/CFB/cfb_power4_2010_2025_long.csv", show_col_types = FALSE) %>%
      filter(season %in% feature_years) %>%
      mutate(year = season) %>%
      left_join(power4_school_lookup %>% distinct(school, metro_name), by = "school") %>%
      filter(!is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(cfb_win_pct = mean(win_pct, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/CFB/cfb_power4_playoff_appearances.csv", show_col_types = FALSE) %>%
      mutate(
        school = if_else(Team == "Central Florida (UCF)", "UCF", Team),
        year_list = str_split(Seasons, ";\\s*")
      ) %>%
      unnest(year_list) %>%
      mutate(
        year = as.integer(year_list),
        make_playoffs = as.integer(!is.na(year))
      ) %>%
      filter(year %in% feature_years) %>%
      left_join(power4_school_lookup, by = c("school" = "school")) %>%
      filter(!is.na(metro_name)) %>%
      arrange(school, year) %>%
      group_by(school) %>%
      mutate(make_playoffs_prev = lag(make_playoffs, default = 0L)) %>%
      ungroup() %>%
      group_by(year, metro_name) %>%
      summarise(
        cfb_make_playoffs = as.integer(any(make_playoffs == 1L)),
        cfb_make_playoffs_prev = as.integer(any(make_playoffs_prev == 1L)),
        .groups = "drop"
      ),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/CFB/cfb_power4_average_temperatures.csv", show_col_types = FALSE) %>%
      mutate(school = if_else(School == "Central Florida (UCF)", "UCF", School)) %>%
      left_join(power4_school_lookup, by = c("school" = "school", "City" = "city")) %>%
      filter(!is.na(metro_name)) %>%
      group_by(metro_name) %>%
      summarise(cfb_avg_temp = mean(as.numeric(`Approx. Annual Average Temp (°F)`), na.rm = TRUE), .groups = "drop") %>%
      tidyr::crossing(year = feature_years),
    by = c("year", "metro_name")
  ) %>%
  full_join(
    read_csv("data/CFB/cfb_power4_cities_murder_rates_2003_2026.csv", show_col_types = FALSE) %>%
      mutate(year = Year, school = if_else(School == "Central Florida (UCF)", "UCF", School)) %>%
      left_join(power4_school_lookup, by = c("school" = "school", "City" = "city")) %>%
      filter(year %in% feature_years, !is.na(metro_name)) %>%
      group_by(year, metro_name) %>%
      summarise(cfb_murder_rate = mean(`Murder Rate (per 100k)`, na.rm = TRUE), .groups = "drop"),
    by = c("year", "metro_name")
  )

sports_features <- mlb_features %>%
  full_join(nfl_features, by = c("year", "metro_name")) %>%
  full_join(nhl_features, by = c("year", "metro_name")) %>%
  full_join(cfb_features, by = c("year", "metro_name")) %>%
  mutate(
    across(
      ends_with(c("make_playoffs", "make_playoffs_prev")),
      ~ replace_na(as.integer(.x), 0L)
    )
  ) %>%
  left_join(metro_geoid_lookup, by = c("metro_name" = "NAME")) %>%
  filter(!is.na(GEOID)) %>%
  select(
    GEOID,
    year,
    mlb_avg_temp, mlb_win_pct, mlb_make_playoffs, mlb_make_playoffs_prev, mlb_murder_rate,
    nfl_avg_temp, nfl_win_pct, nfl_make_playoffs, nfl_make_playoffs_prev, nfl_murder_rate,
    nhl_avg_temp, nhl_win_pct, nhl_make_playoffs, nhl_make_playoffs_prev, nhl_murder_rate,
    cfb_avg_temp, cfb_win_pct, cfb_make_playoffs, cfb_make_playoffs_prev, cfb_murder_rate
  ) %>%
  distinct()

metro_acs_model_ready <- metro_acs_model_ready %>%
  left_join(sports_features, by = c("year", "GEOID")) %>%
  relocate(
    mlb_avg_temp, mlb_win_pct, mlb_make_playoffs, mlb_make_playoffs_prev, mlb_murder_rate,
    nfl_avg_temp, nfl_win_pct, nfl_make_playoffs, nfl_make_playoffs_prev, nfl_murder_rate,
    nhl_avg_temp, nhl_win_pct, nhl_make_playoffs, nhl_make_playoffs_prev, nhl_murder_rate,
    cfb_avg_temp, cfb_win_pct, cfb_make_playoffs, cfb_make_playoffs_prev, cfb_murder_rate,
    .after = has_power4_school
  ) %>%
  as.data.frame()
