# Sql

1/ What is the difference between INNER JOIN, LEFT JOIN, and RIGHT JOIN?
2/ How do you calculate the median of a numeric column in SQL?
3/ Write a query to find duplicate rows in a dataset.
4/ What is the difference between GROUP BY and ORDER BY?
5/ Explain the purpose of window functions and give an example.
6/ Write a query to calculate the rolling average of sales for the past 7 days.
7/ How would you identify the second highest value in a column?
8/ Explain how HAVING differs from WHERE with examples.
9/ Write a query to extract users who performed at least 5 transactions in a month.
10/ How would you detect anomalies or outliers in a dataset using SQL?
11/ Write a query to pivot a table and convert rows into columns.
12/ How can you rank users based on their total purchase value in descending order?
13/ Write a query to calculate a percentage contribution of each product to the total sales.
14/ Explain the concept of CASE statements with an example.
15/ Write a query to count the number of unique users by day.
16/ How would you calculate a cumulative sum of a column?
17/ Write a query to identify the first and last transaction of each user.
18/ How do you use ROW_NUMBER() to eliminate duplicates from a table?
19/ What are lag and lead functions, and how are they used in SQL?
20/ Write a query to calculate the time difference between consecutive events for each user.
21/ How would you handle missing values in SQL?
22/ Write a query to remove duplicate rows from a dataset.
23/ How can you split a single column into multiple columns in SQL?
24/ Explain how you would clean a dataset with inconsistent formats (e.g., date or string issues).
25/ Write a query to standardize data by scaling numeric columns between 0 and 1


Solution: 
1. Difference between INNER JOIN, LEFT JOIN, and RIGHT JOIN
INNER JOIN: Returns only the rows that have matching values in both tables.

LEFT JOIN (or LEFT OUTER JOIN): Returns all rows from the left table and the matched rows from the right table. If no match is found, NULL values are returned for columns from the right table.

RIGHT JOIN (or RIGHT OUTER JOIN): Returns all rows from the right table and the matched rows from the left table. If no match is found, NULL values are returned for columns from the left table.

2. Calculate the median of a numeric column in SQL
sql
 
WITH OrderedData AS (
    SELECT column_name,
           ROW_NUMBER() OVER (ORDER BY column_name) AS RowAsc,
           ROW_NUMBER() OVER (ORDER BY column_name DESC) AS RowDesc
    FROM table_name
)
SELECT AVG(column_name) AS Median
FROM OrderedData
WHERE RowAsc = RowDesc OR RowAsc + 1 = RowDesc OR RowAsc = RowDesc + 1;


3. Find duplicate rows in a dataset
sql
 
SELECT column1, column2, COUNT(*)
FROM table_name
GROUP BY column1, column2
HAVING COUNT(*) > 1;


4. Difference between GROUP BY and ORDER BY
GROUP BY: Aggregates data into groups based on one or more columns. Used with aggregate functions like COUNT, SUM, AVG, etc.

ORDER BY: Sorts the result set in ascending or descending order based on one or more columns.


 5. Purpose of window functions and example
Purpose: Perform calculations across a set of rows related to the current row without collapsing the result set.

Example: Calculate the running total of sales:

sql
 
SELECT date, sales,
       SUM(sales) OVER (ORDER BY date) AS running_total
FROM sales_table;


6. Calculate the rolling average of sales for the past 7 days
sql
 
SELECT date, sales,
       AVG(sales) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM sales_table;


7. Identify the second highest value in a column
sql
 
SELECT MAX(column_name) AS second_highest
FROM table_name
WHERE column_name < (SELECT MAX(column_name) FROM table_name);


8. Difference between HAVING and WHERE
WHERE: Filters rows before aggregation.

HAVING: Filters groups after aggregation.

Example:

sql
 
-- WHERE
SELECT column_name
FROM table_name
WHERE column_name > 100;

-- HAVING
SELECT column_name, COUNT(*)
FROM table_name
GROUP BY column_name
HAVING COUNT(*) > 5;


9. Extract users with at least 5 transactions in a month
sql
 
SELECT user_id, COUNT(*) AS transaction_count
FROM transactions
WHERE MONTH(transaction_date) = 10 AND YEAR(transaction_date) = 2023
GROUP BY user_id
HAVING COUNT(*) >= 5;


10. Detect anomalies or outliers in a dataset
sql
 
WITH Stats AS (
    SELECT AVG(column_name) AS mean, STDDEV(column_name) AS stddev
    FROM table_name
)
SELECT *
FROM table_name
WHERE column_name > (SELECT mean + 3 * stddev FROM Stats)
   OR column_name < (SELECT mean - 3 * stddev FROM Stats);


11. Pivot a table and convert rows into columns
sql
 
SELECT *
FROM (
    SELECT category, value
    FROM table_name
) AS src
PIVOT (
    SUM(value) FOR category IN ('A', 'B', 'C')
) AS pvt;


12. Rank users based on total purchase value
sql
 
SELECT user_id, SUM(purchase_value) AS total_purchase,
       RANK() OVER (ORDER BY SUM(purchase_value) DESC) AS rank
FROM purchases
GROUP BY user_id;


13. Calculate percentage contribution of each product to total sales
sql
 
SELECT product_id, sales,
       sales / SUM(sales) OVER () * 100 AS percentage_contribution
FROM sales_table;


14. CASE statement example
sql
 
SELECT column_name,
       CASE
           WHEN column_name > 100 THEN 'High'
           WHEN column_name > 50 THEN 'Medium'
           ELSE 'Low'
       END AS category
FROM table_name;


15. Count unique users by day
sql
 
SELECT DATE(login_time) AS day, COUNT(DISTINCT user_id) AS unique_users
FROM logins
GROUP BY DATE(login_time);


16. Calculate cumulative sum of a column
sql
 
SELECT date, sales,
       SUM(sales) OVER (ORDER BY date) AS cumulative_sum
FROM sales_table;


17. Identify first and last transaction of each user
sql
 
SELECT user_id,
       MIN(transaction_date) AS first_transaction,
       MAX(transaction_date) AS last_transaction
FROM transactions
GROUP BY user_id;


18. Use ROW_NUMBER() to eliminate duplicates
sql
 
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY column1, column2 ORDER BY id) AS rn
    FROM table_name
)
DELETE FROM table_name
WHERE id IN (SELECT id FROM CTE WHERE rn > 1);


19. LAG and LEAD functions
LAG: Accesses data from a previous row.

LEAD: Accesses data from a subsequent row.

Example:

sql
 
SELECT date, sales,
       LAG(sales) OVER (ORDER BY date) AS previous_sales,
       LEAD(sales) OVER (ORDER BY date) AS next_sales
FROM sales_table;


20. Calculate time difference between consecutive events
sql
 
SELECT user_id, event_time,
       LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) AS previous_event_time,
       DATEDIFF(SECOND, LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time), event_time) AS time_diff
FROM events;


21. Handle missing values
sql
 
-- Replace NULL with a default value
SELECT COALESCE(column_name, 'default_value') AS column_name
FROM table_name;


22. Remove duplicate rows
sql
 
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY column1, column2 ORDER BY id) AS rn
    FROM table_name
)
DELETE FROM table_name
WHERE id IN (SELECT id FROM CTE WHERE rn > 1);


23. Split a single column into multiple columns
sql
 
SELECT SUBSTRING_INDEX(column_name, ',', 1) AS part1,
       SUBSTRING_INDEX(column_name, ',', -1) AS part2
FROM table_name;


24. Clean inconsistent formats
sql
 
-- Standardize dates
SELECT DATE_FORMAT(STR_TO_DATE(date_column, '%m/%d/%Y'), '%Y-%m-%d') AS standardized_date
FROM table_name;

-- Standardize strings
SELECT TRIM(LOWER(column_name)) AS standardized_string
FROM table_name;


25. Standardize data by scaling numeric columns between 0 and 1
sql
 
WITH MinMax AS (
    SELECT MIN(column_name) AS min_val, MAX(column_name) AS max_val
    FROM table_name
)
SELECT (column_name - min_val) / (max_val - min_val) AS scaled_value
FROM table_name, MinMax;
