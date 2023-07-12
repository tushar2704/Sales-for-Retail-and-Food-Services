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

--








