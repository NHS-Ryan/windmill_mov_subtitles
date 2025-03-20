# Windmill@Home Automated Subtitles Project
This is to support the Windmill@Home automated subtitles project. 
The data explorer located at https://ryan-andstuff.shinyapps.io/country_information_explorer/ allows you to explore the dataset we have assembled for this project. 
Data were assembled and processed by Ryan Lord & Ashikur Rahman. 

# Market Score Index

The Market Score Index is calculated as following: 
Firstly we filter out any countries where the primary language is part of our supported_languages.csv dataset. These languages / countries we already translate to and therefore we do not need to explore them as part of this dataset. 

To calculate the Market Score Index we need 3 parameters: Target Population, Average GDP Change 5 Years & Median Income. 
 
2 of the parameters are already available in our country_information dataframe, but target_population needs to be calculated as follows: 

Median Income & Average GDP Change 5 Years don't need any additional processing other than ranking and normalisation detailed below, but Target Population is calculated as follows: 

Target Population = Population * Most Commonly Spoken Language Ratio - (english_speakers_l1 + english_speakers_l2))

We then take the 3 parameters, rank them from highest to lowest, and normalise the result from 0 to 1. Finally we apply the following weights to give a final score out of 10: 
Average GDP Change 5 Years * 2.5 + 
Median Income * 3.5 + 
Target Popualtion * 4 + 
= Market Score


# Sources

**Median Income Data**

Source: World Bank Adjusted net national income per capita (current US$) 2021 values

Link: https://databank.worldbank.org/reports.aspx?source=2&series=NY.ADJ.NNTY.PC.CD&country=#

Additional processing: countries with no data for 2021 removed by Ryan Lord 2025.03.17. 

**GDP Change Data**

Source: World Bank GDP growth (annual %) 2019,2020,2021,2022,2023 figures

Link: https://databank.worldbank.org/reports.aspx?source=2&series=NY.GDP.MKTP.KD.ZG&country=)

Additional processing: 2019 to 2023 figures averaged by Ryan Lord 2025.03.17 in Excel. 


**Language Data**

Source: Ethnologue database

Link: https://www.ethnologue.com/language/eng/

Additional processing: data in Ethnologue data was in a semi-structured format. Data was scraped using Data_Scrapping.py. A RegEx solution was applied to this semi-structured data to extract information into L1 (native speaker) and L2 (second language) speakers using Process_L1_L2.py. 

**Population Data**

Source: Worldometer

Link: https://www.worldometers.info/world-population/population-by-country/

Additional processing: none
