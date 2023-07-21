/* 
© 2023 Tushar Aggarwal. All rights reserved. github.com/tushar2704
*/

--Business Question:

--1)Top-performing industries in terms of sales for a year 2021, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT
        year,
        month,
        industry,
        SUM(sales) AS total_sales
    FROM
        retail_sales
    WHERE
        year = 2021  
    GROUP BY
        year,
        month,
        industry
),
top_industries AS (
    SELECT
        year,
        month,
        industry,
        total_sales,
        RANK() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS industry_rank
    FROM
        monthly_sales
)
SELECT
    year,
    month,
    industry,
    total_sales
FROM
    top_industries
WHERE
    industry_rank = 1
ORDER BY
    year,
    month;


--2)Top-performing industries in terms of sales for a year 2022, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT
        year,
        month,
        industry,
        SUM(sales) AS total_sales
    FROM
        retail_sales
    WHERE
        year = 2022  
    GROUP BY
        year,
        month,
        industry
),
top_industries AS (
    SELECT
        year,
        month,
        industry,
        total_sales,
        RANK() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS industry_rank
    FROM
        monthly_sales
)
SELECT
    year,
    month,
    industry,
    total_sales
FROM
    top_industries
WHERE
    industry_rank = 1
ORDER BY
    year,
    month;



































































































































































































































