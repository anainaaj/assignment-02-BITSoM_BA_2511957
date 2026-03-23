-- Q3.2- ANALYTICAL QUERIES — Retail Data Warehouse
--  File: part3-datawarehouse/dw_queries.sql
-- Q1: Total sales revenue by product category for each month
-- -------------------------------------------------------------
SELECT
    d.year                          AS year,
    d.month_name                    AS month,
    p.category                      AS product_category,
    SUM(f.total_revenue)            AS total_revenue,
    SUM(f.units_sold)               AS total_units_sold
FROM
    fact_sales   f
    JOIN dim_date    d ON f.date_key    = d.date_key
    JOIN dim_product p ON f.product_key = p.product_key
GROUP BY
    d.year,
    d.month,
    d.month_name,
    p.category
ORDER BY
    d.year,
    d.month,         
    p.category;
    
    -- Q2: Top 2 performing stores by total revenue
-- -------------------------------------------------------------
SELECT
    s.store_name                    AS store,
    s.city                          AS city,
    SUM(f.total_revenue)            AS total_revenue,
    SUM(f.units_sold)               AS total_units_sold,
    COUNT(f.sales_id)               AS number_of_transactions
FROM
    fact_sales  f
    JOIN dim_store s ON f.store_key = s.store_key
GROUP BY
    s.store_key,
    s.store_name,
    s.city
ORDER BY
    total_revenue DESC
LIMIT 2;

-- Q3: Month-over-month sales trend across all stores
-- -------------------------------------------------------------
SELECT
    d.year                                   AS year,
    d.month                                  AS month_number,
    d.month_name                             AS month,
    SUM(f.total_revenue)                     AS monthly_revenue,

    -- Revenue in the previous month (NULL for the first month)
    LAG(SUM(f.total_revenue))
        OVER (ORDER BY d.year, d.month)      AS prev_month_revenue,

    -- Absolute change vs previous month
    SUM(f.total_revenue)
      - LAG(SUM(f.total_revenue))
            OVER (ORDER BY d.year, d.month)  AS mom_change_inr,

    -- Percentage change vs previous month (rounded to 2 decimal places)
    ROUND(
        ( SUM(f.total_revenue)
          - LAG(SUM(f.total_revenue))
                OVER (ORDER BY d.year, d.month) )
        / LAG(SUM(f.total_revenue))
              OVER (ORDER BY d.year, d.month)
        * 100
    , 2)                                     AS mom_change_pct

FROM
    fact_sales  f
    JOIN dim_date d ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;
