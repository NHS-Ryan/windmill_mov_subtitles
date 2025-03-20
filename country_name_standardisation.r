# This script takes the various .csv files we have crated and standardises the 
# country name value so that data can be joined. 
# In addition it does a final join to country_information to create the final 
# file

library(tidyverse)

# Import files for standardisation
# Ethnologue database is the chosen standard for country names  
# country_information.csv is the final target dataset. 
eth_df <- read_csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/Ethnologue_english_language_Data.csv")
gdp_df <- read_csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/avg_gdp_change_5_years.csv")
pri_df <- read_csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/primary_language.csv")
cou_df <- read_csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/country_information.csv")

# Rename columns in country_information dataset to correct format
cou_df <- cou_df %>% rename(country = Country,
                            population = Population,
                            english_speakers_l1 = `English_Speakers_L1`,
                            english_speakers_l2 = `English_Speakers_L2`)


# Rename columns in Ethnologue dataset to correct format
eth_df <- eth_df %>% rename(country = `Country Name`,
                            english_speakers_l1 = `L1 Users`,
                            english_speakers_l2 = `L2 Users`,
                            language_status = `Language Status`)

# Examine the outputs to ensure they are as expected 
summary(gdp_df)
summary(pri_df)
summary(eth_df)

###################
#GDP_DF PROCESSING#
###################

# For gdp_df see what countries will be lost by a direct join: 
left_join(gdp_df,eth_df,c("country" = "country")) %>%
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
gdp_df <- left_join(gdp_df,eth_df,c("country" = "country")) %>%
  rename(english_speakers_l1 = `L1 Users`,
         english_speakers_l2 = `L2 Users`,
         language_status = `Language Status`) %>%
  filter(!is.na(language_status)) %>%
  select(country,
         avg_gdp_change_5_years)


write.csv(gdp_df, "C:/Users/lordryan/Documents/GitHub/windmill_mov_subtitles/avg_gdp_change_5_years.csv", row.names = FALSE)


###################
#PRI_DF PROCESSING#
###################

# For pri_df see what countries will be lost by a direct join: 
temp_df <- left_join(pri_df,eth_df,c("country" = "country")) %>%
  filter(is.na(language_status)) %>%
  select(country,
         primary_language)

# Make adjustments so pri_df file so that important countries aren't missed when
# matching to the ethnologue country naming standard
pri_df <- pri_df %>%
  mutate(country = str_replace_all(country, c("Egypt, Arab Rep." = "Egypt", 
                                              "Russian Federation" = "Russia",
                                              "Slovak Republic" = "Slovakia",
                                              "Turkiye" = "Turkey",
                                              "Czech Republic" = "Czech Republic (Czechia)",
                                              "Korea, South" = "South Korea")))

# complete the join and select only necessary columns ready to write .csv ready
# for commit to github
pri_df <- left_join(pri_df,eth_df,c("country" = "country")) %>%
  select(country,
         primary_language,
         primary_language_speakers)

summary(pri_df)

write.csv(pri_df, "C:/Users/lordryan/Documents/GitHub/windmill_mov_subtitles/primary_language.csv", row.names = FALSE)


#######################################
#FINAL JOIN TO COUNTRY_INFORMATION.CSV#
#######################################

# Note that other joins were performed by Ash, this one was left to me. 

cou_df <- left_join(cou_df,pri_df,c("country" = "country")) %>%
  na.omit()

cou_df <- cou_df %>% mutate(primary_language = str_to_title(primary_language))

head(cou_df)

write.csv(cou_df, "C:/Users/lordryan/Documents/GitHub/windmill_mov_subtitles/country_information.csv", row.names = FALSE)

