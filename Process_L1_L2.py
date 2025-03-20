import pandas as pd  # For handling structured data (DataFrame operations)
import re            # For using regular expressions to extract numerical values
 
# file paths
input_path = r"C:/Users/ARAHMAN2/OneDrive - Department for Education/Documents/Data Science L6-NUL/Bootcamp/Data Extraction/ethnologue_data.csv"
output_path = r"C:/Users/ARAHMAN2/OneDrive - Department for Education/Documents/Data Science L6-NUL/Bootcamp/Data Extraction/processed_ethnologue_data.csv"
 
# Load CSV
df = pd.read_csv(input_path)
 
def extract_l1_l2(user_population):
    """
    A pure functions which extracts L1 (first-language) and L2 (second-language) user counts from the "User Population" column

    It looks for the below patterns
    - "L1 users: <number>" for first-language speakers.
    - "L2 users: <number>" for second-language speakers
    - If only a single number is found before "in", it assumes it's an L2 population

    Args:
        user_population (str): A text description of the user population containing L1/L2 user counts

    Returns:
        pd.Series: A pandas Series containing two extracted values - L1 Users and L2 Users
    """
    l1_match = re.search(r"L1 users:\s*([\d,]+)", str(user_population))  
    l2_match = re.search(r"L2 users:\s*([\d,]+)", str(user_population))  

    # Scenario 2: Only "L2 users" is mentioned, extract number before "in"
    if not l1_match and not l2_match:
        l2_match = re.search(r"^([\d,]+)\s+in", str(user_population))  # Look for number before "in"
        
    # Convert extracted numbers to integers (remove commas)
    l1_users = int(l1_match.group(1).replace(",", "")) if l1_match else None
    l2_users = int(l2_match.group(1).replace(",", "")) if l2_match else None
    return pd.Series([l1_users, l2_users])
 
# Apply function to extract L1 and L2 users
df[["L1 Users", "L2 Users"]] = df["User Population"].apply(extract_l1_l2)
 
# Save updated CSV
df.to_csv(output_path, index=False)
 
print("✅ Process completed. Data saved to:", output_path)