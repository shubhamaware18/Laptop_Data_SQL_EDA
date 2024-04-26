# Laptop Data Analysis Project

![Laptops Data Analysis(EDA)](https://github.com/shubhamaware18/Laptop_Data_SQL_EDA/blob/main/artifacts/image.jpg)

This project aims to perform data cleaning, feature creation, exploratory data analysis (EDA) using SQL with MySQL, and building a model for price prediction based on laptop data. The dataset includes information about various laptops, such as company, type, screen size, CPU, RAM, memory, GPU, operating system, weight, and price.

## Project Structure

The project is divided into two main modules:

1. **Data Cleaning + Feature Creation**:
    - In this module (`01_Data_Cleaning`), data cleaning and feature creation are performed using SQL queries with MySQL.
    - The dataset is cleaned to remove any inconsistencies, missing values, or outliers.
    - Features are created or engineered to enhance the predictive power of the model.
    - Cleaning and feature creation techniques may include:
        - Handling missing values.
        - Removing duplicates.
        - Standardizing column names.
        - Extracting relevant information from columns (e.g., screen resolution, CPU details).
        - Scaling numerical features.
        - Encoding categorical variables.
        - Creating new features based on domain knowledge (e.g., converting weight from kg to pounds).

2. **EDA with SQL for Model Building for Price Prediction**:
    - In this module (`02_EDA`), exploratory data analysis (EDA) is performed using SQL queries with MySQL to gain insights into the dataset.
    - Various SQL queries are used to explore relationships between different features and the target variable (price).
    - Visualizations may be generated to present key findings and patterns discovered during EDA.
    - Statistical analysis may be conducted to understand the distribution of prices and identify influential factors.
    - Feature selection techniques may be employed to determine the most relevant features for predicting laptop prices.
    - A machine learning model is built using the insights gained from EDA to predict laptop prices.
    - The model's performance metrics are evaluated to assess its accuracy and effectiveness in predicting prices.

## How to Use

1. **Data Cleaning + Feature Creation**:
    - Set up a MySQL database and import the dataset.
    - Run the SQL script (`01_Data_Cleaning.sql`) to perform data cleaning and feature creation.
    - Ensure that the output of the script is saved in a new table or in the same table with updated columns.

2. **EDA with SQL for Model Building for Price Prediction**:
    - Use MySQL Workbench or any preferred MySQL client to connect to the database.
    - Run the SQL script (`02_EDA.sql`) to conduct exploratory data analysis.
    - Utilize the insights gained from EDA to build a machine learning model for price prediction.

## Dependencies

- MySQL (for SQL-based analysis)
- MySQL Workbench or any preferred MySQL client

## Dataset

The dataset used in this project contains the following columns:
- `Company`: The manufacturer of the laptop.
- `TypeName`: The type or category of the laptop.
- `Inches`: The screen size of the laptop in inches.
- `ScreenResolution`: The resolution of the laptop screen.
- `CPU`: The central processing unit of the laptop.
- `RAM`: The amount of random-access memory (RAM) in the laptop.
- `Memory`: The storage capacity of the laptop.
- `GPU`: The graphics processing unit of the laptop.
- `OpSys`: The operating system installed on the laptop.
- `Weight`: The weight of the laptop.
- `Price`: The price of the laptop.

## Contributors

- [Shubham Aware] ([Your GitHub Profile](https://github.com/awareshubham18))

Feel free to contribute to this project by submitting pull requests or opening issues for improvements or bug fixes.