# windmill_mov_subtitles
Home for code and data for Summative 1 &amp; 2 for Data Science Bootcamp


# Sources

**median_income**

Source: World Bank Adjusted net national income per capita (current US$) 2021 values

Link: https://databank.worldbank.org/reports.aspx?source=2&series=NY.ADJ.NNTY.PC.CD&country=#

Additional processing: countries with no data for 2021 removed by Ryan Lord 2025.03.17. 

**avg_gdp_change_5_years**

Source: World Bank GDP growth (annual %) 2019,2020,2021,2022,2023 figures

Link: https://databank.worldbank.org/reports.aspx?source=2&series=NY.GDP.MKTP.KD.ZG&country=)

Additional processing: 2019 to 2023 figures averaged by Ryan Lord 2025.03.17 in Excel. 


**english_speakers.csv**

Source: Ethnologue database

Link: https://www.ethnologue.com/language/eng/

Additional processing: data in Ethnologue data was in a semi-structured format. Data was scraped using Data_Scrapping.py. A RegEx solution was applied to this semi-structured data to extract information into L1 (native speaker) and L2 (second language) speakers. 

**population.csv**

Source: Worldometer

Link: https://www.worldometers.info/world-population/population-by-country/

Additional processing: none
