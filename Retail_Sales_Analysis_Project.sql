--SQL Retail Sales Analysis
-- CREATE DATABASE 
CREATE DATABASE RETAIL_SALES_ANALYSIS

-- USE THE DATA BASE RETAIL_SALES_ANALYSIS
USE RETAIL_SALES_ANALYSIS

-- CREATE TABLE 
CREATE TABLE Retail_Sales
			 (
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(10),
				age	INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			 )

BULK INSERT Retail_Sales
FROM 'C:\Users\Lokesh K U\Downloads\retail_sales.csv'
WITH (
    FIELDTERMINATOR = ',', -- For CSV files
    ROWTERMINATOR = '\n',  -- For Windows line breaks
    FIRSTROW = 2           -- Skip header row
);

--Select all colunmns from the table
SELECT * FROM Retail_Sales

-- Detailed information about a table
sp_help Retail_Sales

SELECT TOP 10 *
FROM Retail_Sales

-- Total number of rows i the tables
SELECT COUNT (*)
FROM Retail_Sales;

-- Data Cleaning.

SELECT * FROM Retail_Sales 
WHERE 
	transactions_id IS NULL
	OR
	sale_time IS NULL
	OR 
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	customer_id IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

DELETE FROM Retail_Sales
WHERE 
    transactions_id IS NULL
	OR
	sale_time IS NULL
	OR 
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	customer_id IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
--Data Exploration

-- How many sales we have?

SELECT COUNT (*) AS Total_Sales FROM Retail_Sales

--How many uniuque customers we have ?

SELECT COUNT (DISTINCT customer_id) AS uniuque_customers FROM Retail_Sales

--How many uniuque category we have ?

SELECT COUNT (DISTINCT category) AS uniuque_category FROM Retail_Sales

SELECT DISTINCT(category) FROM Retail_Sales

-- Data Analysis & Business Key Problems,Answers.
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05'

/*Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than or equal to 4 in the month of Nov-2022*/

SELECT * FROM Retail_Sales 
WHERE
	category = 'Clothing' 
	AND
	FORMAT(sale_date, 'yyyy-MM') = '2022-11'
	AND 
	(quantiy >= 4)

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category, 
	SUM(total_sale) AS Net_Sales,
	COUNT(*) AS Total_Orders
	FROM Retail_Sales GROUP BY category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT AVG(AGE) AS Avg_Age FROM Retail_Sales WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM Retail_Sales WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category as Category,
	gender AS Gender,
	COUNT(transactions_id) AS total_number_of_transactions
	 FROM Retail_Sales GROUP BY category,gender
	 ORDER BY category

/* Q.7 Write a SQL query to calculate the average sale for each month.
Find out best selling month in each year*/

SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP  5
	customer_id,
	SUM(total_sale) AS Total_Sales 
FROM Retail_Sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC

/* Q.9 Write a SQL query to find the number of 
unique customers who purchased items from each category.*/

SELECT 
	COUNT(DISTINCT(customer_id)) AS Unique_Customes,
	category 
FROM Retail_Sales
GROUP BY category

/* Q.10 Write a SQL query to create each shift and number of orders 
(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)*/

WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;


