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

/*==============================How many types Industtries are there?===============*/












