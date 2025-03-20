library(shiny)
library(DT)
library(ggplot2)
library(dplyr)
library(plotly)
library(markdown)

# Load data
url <- "https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/market_score.csv"
data <- read.csv(url, stringsAsFactors = FALSE)

data <- data %>%
  select(-supported_language_flag.x, -supported_language_flag.y)

supported_languages <- read.csv("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/refs/heads/main/supported_languages.csv")

data <- data %>%
  filter(!(primary_language %in% supported_languages$supported_languages))

data$target_population <- ((data$population - data$english_speakers_total) * data$primary_language_speakers)

# Rename columns
colnames(data) <- c("Country", "Population (millions)", "Native English Speakers (millions)", 
                    "Second Language English Speakers (millions)", "Median Income ($)", 
                    "5 Year Average GDP Change %", "Most Commonly Spoken Language", 
                    "Ratio of Speakers of Most Common Language", "English Speakers Total (millions)", 
                    "Median Income Score", "Average GDP Change Score", "Target Population Score", "Market Score",
                    "Target Population (millions)")

# Convert Population to millions and rename column
data <- data %>%
  mutate(`Population (millions)` = round(`Population (millions)` / 1e6, 1),
         `Native English Speakers (millions)` = round(`Native English Speakers (millions)` / 1e6,1),
         `Second Language English Speakers (millions)` = round(`Second Language English Speakers (millions)` / 1e6,1),
         `English Speakers Total (millions)` = round(`English Speakers Total (millions)` / 1e6,1),
         `Target Population (millions)` = round(`Target Population (millions)` / 1e6,1),
         `Median Income Score` = round(`Median Income Score`, 1),
         `Average GDP Change Score` = round(`Average GDP Change Score`, 1),
         `Target Population Score` = round(`Target Population Score`, 1),
         `Market Score` = round(`Market Score`, 1),
         `Median Income ($)` = round(`Median Income ($)`, 0),
         `5 Year Average GDP Change %` = round(`5 Year Average GDP Change %`, 2),
         `Target Population (millions)` = round(`Target Population (millions)`, 1))