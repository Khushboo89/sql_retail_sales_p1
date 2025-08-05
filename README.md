SQL Retail Sales Analysis - Project P1
This repository contains SQL queries for analyzing retail sales data. The queries are designed for MySQL and cover various aspects of data manipulation, cleaning, exploration, and business analysis.

Table of Contents
Project Overview
Features
Database Setup
Data Loading
Analysis Overview
Usage
Key SQL Queries
Contributing

Project Overview
This project focuses on performing a comprehensive analysis of retail sales data using SQL. It demonstrates fundamental SQL concepts, including Data Definition Language (DDL), Data Manipulation Language (DML), Data Query Language (DQL), and the use of advanced features like window functions and CTEs (Common Table Expressions). The goal is to extract meaningful insights from raw sales data to answer key business questions.

Features
Database and Table Creation: Scripts to set up the sql_project_P1 database and the retail_sales table.
Data Cleaning: Queries to identify and check for NULL values across all columns.
Data Exploration: Basic queries to understand the dataset's size, unique customers, and product categories.
Business Analysis: A series of SQL queries designed to answer specific business questions related to sales performance, customer behavior, and operational shifts.
MySQL Specific Syntax: All queries are tailored for MySQL, including date formatting (DATE_FORMAT) and time extraction (HOUR).

Database Setup
To set up the database and table, execute the following DDL statements in your MySQL client (e.g., MySQL Workbench, command-line client):

-- Create Database
Create Database sql_project_P1;

-- Use the created database
Use sql_project_P1;

-- Create Table
Create table retail_sales(
    transaction_id int Primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender Varchar(15),
    age int,
    category Varchar(15),
    quantity int,
    price_per_units Float,
    cogs float,
    total_sales float
);

Data Loading
This repository only provides the SQL queries for analysis. The retail_sales table is initially empty after creation. You will need to load your retail sales data into this table.

Assumptions:
You have a CSV file or another data source containing your retail sales data.
The columns in your data source match the table schema defined above.
Example of how you might load data (using MySQL's LOAD DATA INFILE - adjust path and details as needed):

LOAD DATA INFILE '/path/to/your/retail_sales_data.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV has a header row

Remember to replace /path/to/your/retail_sales_data.csv with the actual path to your data file.

Analysis Overview
The SQL script performs the following types of analysis:
Initial Data Overview: Checks table structure and row count.
Null Value Identification: Ensures data quality by finding missing values.
Summary Statistics: Counts unique customers and categories.
Sales Performance: Analyzes total sales by category, average age of customers in specific categories, and transactions exceeding certain thresholds.
Customer Behavior: Explores sales by gender and category, and identifies top customers by sales.
Time-based Analysis: Calculates average sales per month, identifies best-selling months, and categorizes sales by time shifts (Morning, Afternoon, Evening).

Usage
To use these queries:
Connect to MySQL: Use your preferred MySQL client.
Set up the database and table: Run the CREATE DATABASE and CREATE TABLE statements from the Database Setup section.
Load your data: Import your retail sales data into the retail_sales table.
Execute queries: Copy and paste the desired queries from the retail_sales_analysis.sql file (or directly from the Key SQL Queries section below) into your MySQL client and execute them.

Key SQL Queries
Below are some of the key analytical queries included in the project, along with a brief description of what each query achieves.
Data Overview and Cleaning
Check Table Structure:
Desc retail_sales;

View Sample Data:
Select * from retail_sales limit 10;

Count Total Sales Records:
Select Count(*) as total_sale from retail_sales;

Find Null Values in All Columns:
Select * from retail_sales
Where
    transaction_id is null
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or price_per_units is null
    or cogs is null
    or total_sales is null;

Data Exploration
Count Unique Customers:
Select count(Distinct customer_id) as total_unique_customers from retail_sales;

Count Unique Categories:
Select count(Distinct category) as total_unique_categories from retail_sales;

List Unique Categories:
Select Distinct category from retail_sales;

Data Analysis & Business Questions
1. Retrieve all columns for sales made on '2022-11-05'.

Select * from retail_sales
Where sale_date = '2022-11-05';

2.Retrieve all transactions where the category is 'Clothing' and quantity sold is more than 4 in Nov-2022.
SELECT *
FROM retail_sales
WHERE category = 'clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND Quantity >= 4
LIMIT 0, 1000;

3. Calculate the total sales and total orders for each category.
Select
    category,
    sum(total_sales) as net_sales,
    count(*) as total_orders
from retail_sales
group by category;

4. Find the average age of customers who purchased items from the 'Beauty' category.
Select
    Round (Avg(Age),2) as avg_age
from retail_sales
where category = 'beauty';

5. Find all transactions where the total_sale is greater than 1000.
Select * from retail_sales
Where total_sales > 1000;

6. Find the total number of transactions made by each gender in each category.
Select
    category,
    gender,
    count(transaction_id) as total_transactions
from retail_sales
group by
    category,
    gender
order by category;

7.Calculate the average sale for each month and find the best-selling month in each year.
Select Year, Month, Avg_sale
from (
    SELECT
        YEAR(sale_date) AS Year,
        MONTH(sale_date) AS Month,
        AVG(total_sales) AS Avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sales) DESC) as ranking
    FROM
        retail_sales
    GROUP BY
        YEAR(sale_date), MONTH(sale_date)
) as T1
Where ranking = 1
ORDER BY Year, Avg_sale DESC;

8. Find the top 5 customers based on the highest total sales.
SELECT
    customer_id,
    SUM(total_sales) AS net_sales
FROM
    retail_sales
GROUP BY
    customer_id
ORDER BY
    net_sales DESC
LIMIT 5;

(Alternatively, using a CTE for rank-based selection:)

WITH CustomerSales AS (
    SELECT
        customer_id,
        SUM(total_sales) AS net_sales,
        RANK() OVER (ORDER BY SUM(total_sales) DESC) AS customer_rank
    FROM
        retail_sales
    GROUP BY
        customer_id
)
SELECT
    customer_id,
    net_sales,
    customer_rank
FROM
    CustomerSales
WHERE
    customer_rank <= 5
ORDER BY
    customer_rank;

9. Find the number of unique customers who purchased items from each category.
Select
    Category,
    count(Distinct customer_id) as Unique_Customer
from retail_sales
GROUP BY Category;

10. Categorize sales into shifts (Morning, Afternoon, Evening) and count total orders per shift.
With hourly_sale AS (
    SELECT
        *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shifts
    FROM
        retail_sales
)
Select
    shifts,
    Count(*) as total_orders
from hourly_sale
Group by shifts;

Contributing
Feel free to use this repository, make improvements, and submit pull requests. Any contributions are welcome!