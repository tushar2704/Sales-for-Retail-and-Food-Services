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
--What is the revenue change in percentage for each industry from 2019 to 2020?
-- To answer this question,
-- first, we need the sum of sales for each industry for 2019 as the previous year and 2020 as the current year. 
	-- 	We need sum of sales grouped by industry for the year of 2019. This will be the previous year total sales
	-- We need the sum of sales grouped by industry for the year 2020. This will be the current industry 
-- Second, after having both previous and current year sales, we can calculate the growth rate with (current - previous)/previous multiplied by 100. 
	-- Create a CTE for sales in 2019 and create another CTE for sales in 2020
	-- Join these two CTEs to get the current and previous year sales


--cte1
SELECT industry, sum(sales)
from retail_sales
where year=2019
GROUP BY 1;

--cte2
select industry, sum(sales)
from retail_sales
where year =2020
group by 1;

--revennue CHANGE

WITH revenue_2019 as(SELECT industry, sum(sales) prev_revenue
from retail_sales
where year=2019
GROUP BY 1

),
revenue_2020 as(select industry, sum(sales) current_revenue
from retail_sales
where year =2020
group by 1

)

SELECT curr.industry, (current_revenue-prev_revenue) / (prev_revenue) *100 as growth_rate
from revenue_2019 prev
join revenue_2020 curr on prev.industry=curr.industry
ORDER BY growth_rate;


--
--What are the year-over-year growth rates for each industry per year?
-- To answer this question:
-- First, we need the sum of sales by year and the industry.
-- Second, we can use this above query as a temporary table. 
	-- we can do a self-join, so we can have the current year and the previous year together as we did in question 5.


-- sum of sales by YEAR
select year, industry, sum(sales) as sales_sum
from retail_sales
GROUP BY 1,2;

--

with total_sales as(select year, industry, sum(sales) as sales_sum
from retail_sales
GROUP BY 1,2)

SELECT curr.industry, prev.year as previous_year, curr.year as current_year,
    (curr.sales_sum - prev.sales_sum) / prev.sales_sum * 100 as YoY

from total_sales as curr
join total_sales as prev
   on curr.year=prev.year+1 AND curr.industry=prev.industry
ORDER BY industry, curr.year DESC;


--What are the yearly total sales for womenâ€™s clothing stores and menâ€™s clothing stores?
-- Write a case statement to return both total sales in the same table

SELECT year,
sum(CASE WHEN kind_of_business = "Women's clothing stores" THEN sales ELSE 0 END) as women_sales,
sum(CASE WHEN kind_of_business = "Men's clothing stores" THEN sales ELSE 0 END) as men_sales
FROM retail_sales
GROUP BY 1;

--What is the yearly ratio of total sales for women's clothing stores to total sales for men's clothing stores?

-- To answer this question, 
-- we can use our above query as our table with a subquery, 
-- and from that table, we can select womens_sales divided by mens_sales to find the ratio. 

--subquery
SELECT year,
sum(CASE WHEN kind_of_business = "Women's clothing stores" THEN sales ELSE 0 END) as women_sales,
sum(CASE WHEN kind_of_business = "Men's clothing stores" THEN sales ELSE 0 END) as men_sales
FROM retail_sales
GROUP BY 1;

--main query
SELECT year, women_sales/men_sales as Women_to_Men_rario
from (SELECT year,
sum(CASE WHEN kind_of_business = "Women's clothing stores" THEN sales ELSE 0 END) as women_sales,
sum(CASE WHEN kind_of_business = "Men's clothing stores" THEN sales ELSE 0 END) as men_sales
FROM retail_sales
GROUP BY 1;

) as sales;

--What is the year-to-date total sale of each month for 2019, 2020, 2021, and 2022 for the womenâ€™s clothing stores?
-- to answer this question, we are going to use window functions
SELECT month, year, 
    sum(sales) over (PARTITION BY year ORDER BY month) as ytd_sales
from retail_sales
WHERE retail_sales.kind_of_business="Women's clothing stores" AND year in(2019, 2020, 2021,2022)
ORDER BY year desc , month desc;

--with subquery

select rs.month, rs.year, rs.sales,
((SELECT SUM(sales) 
        FROM retail_sales rs2 
        WHERE rs2.year = rs.year AND rs2.month <= rs.month AND rs2.kind_of_business = 'Women\'s clothing stores') AS ytd_sales
) 
from retail_sales as rs
WHERE rs.kind_of_business = 'Women\'s clothing stores' AND rs.year IN (2019, 2020, 2021, 2022);

--What is the month-over-month growth rate of womenâ€™s clothing businesses in 2022?

-- To answer this question
-- We need the current month sales and previous month sales to calculate mom growth rate.
-- The final table returns the month, current monthly sale, which are already available in the data 
-- and it returns the growth rate, which is current - previous/previous. 
	-- We can calculate the previous month's sales with a window function using the LAG() function instead of SUM(). 
    -- The lag function returns the previous value
select month, sales as current_sales, -- now we want the sales from 1 previous period
lag(sales, 1) over (order by month) as prev_sales
from retail_sales
where kind_of_business ='Women\'s clothing stores' and year =2022;


-- growth rate
select month, sales as current_sales,
lag(sales, 1) over (order by month) as prev_sales,
(sales - lag(sales, 1) over (order by month))/lag(sales, 1) over (order by month) *100 as growth_rate
from retail_sales
where kind_of_business ='Women\'s clothing stores' and year =2022;













































































































































































































