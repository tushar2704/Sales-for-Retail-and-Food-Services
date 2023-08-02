-- Active: 1689029778133@@127.0.0.1@5432@retail_sales@retail_sales
/* 
© 2023 Tushar Aggarwal. All rights reserved. github.com/tushar2704
*/


CREATE DATABASE retail_sales;



CREATE TABLE retail_sales (
    id SERIAL PRIMARY KEY,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    naics_code TEXT,
    kind_of_business TEXT NOT NULL,
    industry TEXT NOT NULL,
    sales INTEGER DEFAULT NULL
);

COPY retail_sales 
FROM 'D:\Sales-for-Retail-and-Food-Services\src\data\us_monthly_retail_sales_wrangled.csv'
WITH (FORMAT CSV, HEADER);

UPDATE retail_sales SET sales = NULL WHERE sales = 0;
--Checking for Table
SELECT * FROM retail_sales LIMIT 50;
/* 
© 2023 Tushar Aggarwal. All rights reserved. github.com/tushar2704
-----------------------------------Loading CSV Completed-------------------------------------------
*/