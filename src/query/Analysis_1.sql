-- Active: 1689029778133@@127.0.0.1@5432@retail_sales@retail_sales
/* 
© 2023 Tushar Aggarwal. All rights reserved. github.com/tushar2704
*/
--\c retail_sales;

/*============================== Checking Sales for Reatil & Food Services====================*/
SELECT 
    *
FROM 
    retail_sales;

/*==============================How many types of Businesses are there?===============*/
SELECT
    DISTINCT (kind_of_business)
FROM
    retail_sales;

/*==============================How many types Industtries are there?===============*/
SELECT
    DISTINCT(industry)
FROM
    retail_sales;

/*==============================For year 2022===============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE year = 2022;

/*==============================Sales for industrie other than general merchandise===============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE industry != 'General Merchandise';

/*==============================Sales more than $100 Billion ==============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE sales >100000;
/*==============================Sales more than $100 Billion in 2022 ==============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE sales >100000 AND year =2022;

/*==============================Sales for January 2022 ==============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE month =1 AND year =2022;

/*==============================Sales for January 2022, 2021, 2020, 2019 ==============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE month =1 AND year IN (2022, 2021, 2020, 2019);

/*============================== Businesses start with A ==============*/
SELECT
    DISTINCT(kind_of_Business)
FROM 
    retail_sales
WHERE 
    kind_of_business LIKE 'A%';

/*==============================Businesses in Home industry ==============*/
SELECT
    DISTINCT industry
FROM 
    retail_sales
WHERE industry LIKE '%Home%';

/*==============================Sales is Null ==============*/
SELECT
    year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE sales IS NULL;

/*==============================Top Sales in Industry ==============*/
SELECT
    *
FROM
    retail_sales
WHERE sales IS NOT NULL
ORDER BY sales DESC;

/*==============================Which business kind had highest sales in Jan 2022==============*/
SELECT
    month, year, kind_of_business, industry, sales
FROM retail_sales
WHERE year=2022 AND month =1 AND sales is NOT NULL
ORDER BY sales DESC;

/*==============================Which business kind had lowest sales for all years==============*/
SELECT *
FROM
    retail_sales
WHERE sales IS NOT NULL
ORDER BY sales;

/*==============================What were the total sales, in dollars, of used car dealers in January 2022?
==============*/
SELECT 
    SUM(sales)
FROM
    retail_sales
WHERE
    month = 1 AND year = 2022
        AND kind_of_business LIKE 'used car%';

--What was the average sale in January 2022 of all data?
SELECT AVG(sales) AS AVG_Sales

FROM retail_sales
WHERE month=1 AND year=2022;

--What is the minimum sale amount in the Automotive industry in March 2020?
SELECT *

FROM
    retail_sales
WHERE month =3 AND year =2020 AND industry LIKE 'Automotive%'
ORDER BY sales;

--What is the maximum sale amount in the automotive industry in March 2020?
SELECT MAX(sales) AS MAX_Sales

FROM retail_sales
WHERE month=3 AND YEAR=2020 AND industry LIKE 'Automotive%';

--What was the max sale by industry in march 2020?
SELECT industry, MAX(sales) as Max_Sales
from retail_sales
WHERE month=3 AND year=2020
GROUP BY industry
ORDER BY Max_Sales DESC ;

--average sale by industry for march 2020:
SELECT industry, AVG(sales)::numeric(10,2) AS avg_sales

FROM retail_sales
WHERE month=3 AND year=2020
GROUP BY industry

ORDER BY AVG_Sales DESC;

--What is the all-time average sale by businesses?

SELECT kind_of_business, AVG(sales)::numeric(10,2) AS avg_sales

FROM retail_sales
GROUP BY kind_of_business
ORDER BY AVG_Sales DESC;

--Which businessesâ€™ all-time average sale was above 10 billion dollars?
SELECT kind_of_business, AVG(sales)
FROM retail_sales
GROUP BY kind_of_business
HAVING AVG(sales) > 10000
ORDER BY AVG(sales) DESC;

---- PART 3: SQL ANALYSIS:
-- 1) Which industry had the highest sales revenue for 2022?
--To answer this question, 
-- 1) we need to find the total sales grouped by industry. 
-- 2) We also need to filter year to 2022 since the question is asking about 2022 only. 
-- 3) We need to order by the sum of sales in descending order to easily see the highest sales on top:

SELECT industry, SUM(sales) as revenue

FROM
    retail_sales
WHERE year=2022
GROUP BY industry
ORDER BY revenue DESC;

---- auto industry consists of 5 businesses
SELECT DISTINCT(kind_of_business), Sum(sales)
FROM retail_sales
WHERE industry = 'Automotive'
GROUP BY kind_of_business
ORDER BY Sum(sales);

--office supplies and gifts industry consists of 
SELECT DISTINCT(kind_of_business), SUM(SALES)
FROM retail_sales
Where industry LIKE 'Office Supplies & Gifts'
GROUP BY kind_of_business
ORDER BY SUM(SALES) DESC;

--Which kind of businesses within the automotive industry had the highest sales revenue for 2022?
-- kob in automotive, highest sales revenue in 2022

SELECT DISTINCT(kind_of_business), SUM(sales) Revenue
FROM
    retail_sales
WHERE year=2022 AND sales IS NOT NULL AND industry LIKE 'Automotive%'
GROUP BY kind_of_business
ORDER BY Revenue DESC;


--What is the contribution percentage of each business in the automotive industry this year?
--total % of contribution of kob in automotive business in 2022

--1 total sale by industry
SELECT SUM(sales) total_revenue

FROM retail_sales
WHERE year=2022 AND industry like 'Automotive%'
GROUP BY industry
ORDER BY total_revenue;

--2 % contribution manually
SELECT kind_of_business, sum(sales)/5624235*100 percent

FROM retail_sales
WHERE year=2022 AND industry like 'automotive%'
GROUP BY kind_of_business
ORDER BY percent;

--subquery way
SELECT
    kind_of_business, SUM(Sales)/(SELECT SUM(sales) total_revenue
                                    FROM retail_sales
                                    WHERE year=2022 AND industry like 'Automotive%' and sales is not null
                                    GROUP BY industry
                                    ORDER BY total_revenue) *100 as percent

FROM retail_sales
WHERE year=2022 AND industry ='Automotive' AND sales is not null
GROUP BY kind_of_business
ORDER BY percent;

-- How has the sales revenue changed over time for the Motor vehicle and parts dealers?

-- To answer this question:
-- First, we need the total sales grouped by year
-- Second, we need to filter data so that the kind of business equals motor vehicle and parts dealers:

-- total sales grouped by YEAR
SELECT year,SUM(sales) as total_sales
FROM retail_sales
WHERE kind_of_business LIKE 'Motor vehicle and parts dealers%'
GROUP BY year
ORDER BY total_sales DESC;

-- 5) How much did Motor Vehicles and Parts Dealers experience a month-over-month growth rate in 2020?
-- To answer this question:
-- Select the previous month and current month by using self-join. 
-- We need to filter this table to the year 2022 and the kind of business to motor vehicle and parts dealers
-- Calculate the growth rate using the formula (current - previous)/previous *100:

--Selecting previous and current month usine self JOIN

SELECT curr.month,prev.month

FROM retail_sales curr
JOIN retail_sales prev on curr.month=prev.month+1 
    AND curr.year=prev.year AND curr.kind_of_business=prev.kind_of_business
where curr.year=2020 AND curr.kind_of_business='Motor vehicle and parts dealers';

--growth rate  (prev-curr)*prev*100
SELECT curr.month as currrent_month,prev.month as previous_month,
        (curr.sales-prev.sales) / prev.sales * 100 as growth_rate

FROM retail_sales curr
JOIN retail_sales prev on curr.month=prev.month+1 
    AND curr.year=prev.year AND curr.kind_of_business=prev.kind_of_business
where curr.year=2020 AND curr.kind_of_business='Motor vehicle and parts dealers'
ORDER BY growth_rate DESC;

--Which businesses have the highest total sales revenue for the Food & Beverage industry for each year?

-- To answer this question,
-- we first need to find the yearly total sales of each business in the Food & Beverage industry. 
	-- Total sales grouped by kind_of_business and year
	-- Filter data so that industry = â€˜Food & Beverageâ€™

-- Next, we need to get the maximum total sale for each year for each business within the Food and beverage industry
	-- Maximum of total sales grouped by year
	-- And kind_of_business that this maximum of total sales belongs to.

--yearly total sales for Food & Beverage

SELECT kind_of_business,year, SUM(sales) as total_sales

from retail_sales
Where industry like 'Food & Beverage%'
GROUP BY 1,2
;

--cte
with total_sales as(
    SELECT kind_of_business, year, SUM(sales) sum_sales
    from retail_sales
    Where industry='Food & Beverage'
    GROUP BY 1,2);

-- this is where we select the maximum sales
select year, MAX(sales)
from retail_sales
GROUP BY 1;

--
with total_sales as(
    SELECT 
        kind_of_business, year, SUM(sales) sum_sales
    from retail_sales
    Where industry='Food & Beverage'
    GROUP BY 1,2),

    top_sales as(
        SELECT 
            year, MAX(sum_sales) as max_sales
        from total_sales
        GROUP BY 1)

SELECT 
    cte1.year, cte1.kind_of_business, max_sales
FROM top_sales as cte2
Join total_sales as cte1 
    on cte1.sum_sales=cte2.max_sales and cte1.year=cte2.year;

--





























































































































































































































