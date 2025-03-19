# This script takes avg_gdp_change_5_years.csv held in repo and joins it to the 
# ethnologue_data.csv which we have agreed has the standard naming convention 
# for the primary key country field that all other files will conform to. 

library(tidyverse)

gdp_df <- read_csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/avg_gdp_change_5_years.csv")

eth_df <- read_csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/Ethnologue_english_language_Data.csv")

# Examine the outputs to ensure they are as expected 
summary(gdp_df)
summary(eth_df)

# See what countries will be lost by a direct join: 
left_join(gdp_df,eth_df,c("country" = "Country Name")) %>%
  rename(english_speakers_l1 = `L1 Users`,
         english_speakers_l2 = `L2 Users`,
         language_status = `Language Status`) %>%
  filter(is.na(language_status)) %>%
  select(country,
         avg_gdp_change_5_years)


# Make adjustments so gdp_df file so that important countries aren't missed when
# matching to the ethnologue country naming standard

gdp_df <- gdp_df %>%
  mutate(country = str_replace_all(country, c("Egypt, Arab Rep." = "Egypt", 
                                              "Russian Federation" = "Russia",
                                              "Slovak Republic" = "Slovakia",
                                              "Turkiye" = "Turkey")))


# complete the join and select only necessary columns ready to write .csv ready
# for commit to github
gdp_df <- left_join(gdp_df,eth_df,c("country" = "Country Name")) %>%
  rename(english_speakers_l1 = `L1 Users`,
         english_speakers_l2 = `L2 Users`,
         language_status = `Language Status`) %>%
  filter(!is.na(language_status)) %>%
  select(country,
         avg_gdp_change_5_years)



summary(gdp_df)


write.csv(gdp_df, "C:/Users/lordryan/Documents/GitHub/windmill_mov_subtitles/avg_gdp_change_5_years.csv", row.names = FALSE)

