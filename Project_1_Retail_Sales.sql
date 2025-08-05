-- Sql Retal Sales Analysis - P1
Create Database sql_project_P1;
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
total_sales float);
Desc retail_sales;
Select * from retail_sales
limit 10;

Select Count(*) from retail_sales;

-- Data cleaning: Finding null values in table for all the columns
Select * from retail_sales
where transaction_id is null;
Select * from retail_sales
where sale_date is null;
Select * from retail_sales
where sale_time is null;
Select * from retail_sales
where customer_id is null;
Select * from retail_sales
where gender is null;
Select * from retail_sales
where age is null;
Select * from retail_sales
where category is null;
Select * from retail_sales
where quantity is null;
Select * from retail_sales
where price_per_units is null;
Select * from retail_sales
where cogs is null;
Select * from retail_sales
where total_sales is null;

-- Finding null values in all columns in one go
Select * from retail_sales
Where
    transaction_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    quantity is null
    or
    price_per_units is null
    or
    cogs is null
    or
    total_sales is null;

-- Data Exploration
-- How many sales we have (1987)
Select count(*) as total_sale from retail_sales;

-- How many unique customers we have (155)
Select count(Distinct customer_id) as total_sale from retail_sales;

-- How many unique categories we have (3)
Select count(Distinct category) as total_sale from retail_sales;

-- Name of unique categories we have (Beauty, Clothing, Electronics)
Select Distinct category from retail_sales;

-- Data Analysis & business key problems and answers

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
Select * from retail_sales 
Where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT *
FROM retail_sales
WHERE category = 'clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'  -- Use DATE_FORMAT for MySQL
  AND Quantity >= 4
LIMIT 0, 1000;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
Select 
category,
sum(total_sales) as net_sales,
count(*) as total_orders
from retail_sales
group by 1;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select
Round (Avg(Age),2) as avg_age
from retail_sales
where category = 'beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
Select * from retail_sales
Where total_sales > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
Select 
category,
gender,
count(transaction_id) as total_transactions
from retail_sales
group by
category,
gender
order by 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
Select Year, Month
Avg_sale from(
SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sales) AS Avg_sale,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sales) DESC) as ranking
FROM
    retail_sales
GROUP BY
    1, 2
ORDER BY
    1, 3 Desc) as T1
    Where ranking = 1;
-- Order by 1,3 Desc

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
    customer_id,
    SUM(total_sales) AS net_sales,
    RANK() OVER (ORDER BY SUM(total_sales) DESC) AS customer_rank
FROM
    retail_sales
GROUP BY
    customer_id
ORDER BY
    net_sales DESC
LIMIT 0, 1000;

-- Or we can use following code
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

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
Select 
Category,
count(Distinct customer_id) as Unique_Customer from retail_sales
GROUP BY 1;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
With hourly_sale
As (
SELECT
    *,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shifts
FROM
    retail_sales)
Select
shifts,
Count(*) as total_orders
 from hourly_sale
 Group by Shifts;