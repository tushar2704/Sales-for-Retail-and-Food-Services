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


--3)Top-performing industries in terms of sales for a year 2020, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT
        year,
        month,
        industry,
        SUM(sales) AS total_sales
    FROM
        retail_sales
    WHERE
        year = 2020  
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
	
--4)Top-performing industries in terms of sales for a year 2019, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT
        year,
        month,
        industry,
        SUM(sales) AS total_sales
    FROM
        retail_sales
    WHERE
        year = 2019  
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
-----------------------------------------------------------------------------------------
--Business Question 2: Which specific kind of businesses contribute the most to total sales, and how does their performance vary across industries?
SELECT
    kind_of_business,
    industry,
    SUM(sales) AS total_sales
FROM
    retail_sales
GROUP BY
    kind_of_business,
    industry
ORDER BY
    total_sales DESC;
-----------------------------
--Business Question 3: Is there any seasonality in sales for specific industries, and how do they perform month-over-month?
SELECT
    industry,
	year,
    month,
    SUM(sales) AS total_sales
FROM
    retail_sales
GROUP BY
	year,
    industry,
    month
ORDER BY
	year,
    industry,
    month;
------------------
--Business Question 4: How does the sales distribution vary among industries based on their North American Industry Classification System (NAICS) codes?

SELECT
    naics_code,
    industry,
    SUM(sales) AS total_sales
FROM
    retail_sales
GROUP BY
    naics_code,
    industry
ORDER BY
    naics_code,
    total_sales DESC;

---------------
--Business Question 5: Are there any outliers or significant changes in sales for specific industries during particular months or years?
SELECT
    industry,
    year,
    month,
    sales
FROM
    retail_sales
WHERE
    (industry, year, month) IN (
        SELECT
            industry,
            year,
            month
        FROM (
            SELECT
                industry,
                year,
                month,
                sales,
                LAG(sales) OVER (PARTITION BY industry ORDER BY year, month) AS prev_sales,
                LEAD(sales) OVER (PARTITION BY industry ORDER BY year, month) AS next_sales
            FROM
                retail_sales
        ) AS sales_analysis
        WHERE
            sales > 1.5 * COALESCE(prev_sales, 0) OR sales > 1.5 * COALESCE(next_sales, 0)
    )
ORDER BY
    industry,
    year,
    month;
---------------------
--Which businesses all-time average sale was above 10 billion dollars?
SELECT
    kind_of_business,
    AVG(sales) AS average_sale
FROM
    retail_sales
GROUP BY
    kind_of_business
HAVING
    AVG(sales) > 10000;  -- 10 billion dollars in cents (1 dollar = 100 cents)

---------------------------
--Which kind of businesses within the automotive industry had the highest sales revenue for 2022?
SELECT
    kind_of_business,
    SUM(sales) AS total_sales
FROM
    retail_sales
WHERE
    industry = 'Automotive' AND year = 2022
GROUP BY
    kind_of_business
ORDER BY
    total_sales DESC
;
--------------------
--What is the contribution percentage of each business in the automotive industry this year?
WITH automotive_sales AS (
    SELECT
        kind_of_business,
        SUM(sales) AS total_sales
    FROM
        retail_sales
    WHERE
        industry = 'Automotive' AND
        year = 2022  
    GROUP BY
        kind_of_business
),
total_sales_automotive AS (
    SELECT
        SUM(sales) AS total_sales_automotive
    FROM
        retail_sales
    WHERE
        industry = 'Automotive' AND
        year = 2022
)
SELECT
    kind_of_business,
    ROUND((total_sales / total_sales_automotive.total_sales_automotive) * 100, 2) AS contribution_percentage
FROM
    automotive_sales
CROSS JOIN
    total_sales_automotive;

----------------
--























































































































































































































