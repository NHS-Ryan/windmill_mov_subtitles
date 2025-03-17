from bs4 import BeautifulSoup  # Improting for parsing HTML and extracting data (requires installiing bs4 packages)
import pandas as pd            # For organising extracted data into a structured format (DataFrame)
import os                      # For handling file paths and saving the output CSV in the same directory


def extract_language_data(html_file_path):
    """
    A pure function which extracts language data (Country Name, User Population, Language Status, Other Comments, and Language Development)
    from a given HTML file

    Args:
        html_file_path (str): The path to the saved HTML file.

    Returns:
        pd.DataFrame: A DataFrame containing the extracted language data.
    """
    # Opens and parse the HTML file
    with open(html_file_path, "r", encoding="utf-8") as file:
        soup = BeautifulSoup(file, "html.parser")

    # List to store extracted data
    data = []

    # Finds all country sections
    for country_section in soup.find_all("div", class_="accordion__label"):
        # Extracts country name
        country_name = country_section.find("label").text.strip()

        # Finds the corresponding content section
        content_section = country_section.find_next_sibling("dl", class_="accordion__content")

        # Default values
        user_population = language_status = other_comments = language_development = "N/A"

        if content_section:
            # Extracts all label-content pairs
            labels = content_section.find_all(["div", "dt"], class_="entry__label--alsospoken")
            contents = content_section.find_all(["div", "dd"], class_="entry__content--alsospoken")

            # Create a mapping of labels to their corresponding content
            label_content_map = {label.text.strip(): contents[i].text.strip() for i, label in enumerate(labels) if i < len(contents)}

            # Extracts required fields
            user_population = label_content_map.get("User Population", "N/A")
            language_status = label_content_map.get("Language Status", "N/A")
            other_comments = label_content_map.get("Other Comments", "N/A")
            language_development = label_content_map.get("Language Development", "N/A")

        # Append extracted data as a list
        data.append([country_name, user_population, language_status, other_comments, language_development])

    # Convert to Pandas DataFrame
    df = pd.DataFrame(data, columns=["Country Name", "User Population", "Language Status", "Other Comments", "Language Development"])

    return df  # Returning the DataFrame makes the function testable and reusable

# Using the function for the saved HTML file:
html_path = "C:/Users/ARAHMAN2/OneDrive - Department for Education/Documents/Data Science L6-NUL/Bootcamp/Data Extraction/Ethnologue.html"
df = extract_language_data(html_path)

# Saves the CSV in the same directory as the HTML file
output_path = os.path.join(os.path.dirname(html_path), "ethnologue_data.csv")
df.to_csv(output_path, index=False)

# Displays the first few rows to verify
print(df.head())
