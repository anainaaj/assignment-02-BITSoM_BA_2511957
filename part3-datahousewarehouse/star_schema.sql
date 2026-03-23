--  STAR SCHEMA — Retail Data Warehouse
--  File: part3-datawarehouse/star_schema.sql
-- Q3.1

-- DIMENSION 1 — dim_date
CREATE TABLE IF NOT EXISTS dim_date (
    date_key    INTEGER PRIMARY KEY,  
    full_date   DATE        NOT NULL,  
    day         INTEGER     NOT NULL, 
    month       INTEGER     NOT NULL,  
    month_name  TEXT        NOT NULL, 
    quarter     INTEGER     NOT NULL, 
    year        INTEGER     NOT NULL
);

-- DIMENSION 2 — dim_store
CREATE TABLE IF NOT EXISTS dim_store (
    store_key   INTEGER PRIMARY KEY AUTOINCREMENT,
    store_name  TEXT    NOT NULL,  
    city        TEXT    NOT NULL   
);

-- DIMENSION 3 — dim_product
CREATE TABLE IF NOT EXISTS dim_product (
    product_key  INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT    NOT NULL,  -- e.g. 'Laptop'
    category     TEXT    NOT NULL,  -- cleaned & standardised (see ETL notes)
    unit_price   REAL    NOT NULL   -- price per unit in INR
);

-- FACT TABLE — fact_sales
CREATE TABLE IF NOT EXISTS fact_sales (
    sales_id        INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Foreign keys 
    date_key        INTEGER NOT NULL REFERENCES dim_date(date_key),
    store_key       INTEGER NOT NULL REFERENCES dim_store(store_key),
    product_key     INTEGER NOT NULL REFERENCES dim_product(product_key),

    -- Raw transaction reference
    transaction_id  TEXT    NOT NULL,
    customer_id     TEXT,

    -- Measures 
    units_sold      INTEGER NOT NULL,
    unit_price      REAL    NOT NULL,
    total_revenue   REAL    NOT NULL   
    );
    
    --  LOAD DIMENSION DATA
    -- dim_date 
    INSERT INTO dim_date (date_key, full_date, day, month, month_name, quarter, year) VALUES
(20230115, '2023-01-15', 15, 1,  'January',  1, 2023),
(20230205, '2023-02-05', 5,  2,  'February', 1, 2023),
(20230331, '2023-03-31', 31, 3,  'March',    1, 2023),
(20230604, '2023-06-04', 4,  6,  'June',     2, 2023),
(20230809, '2023-08-09', 9,  8,  'August',   3, 2023),
(20231026, '2023-10-26', 26, 10, 'October',  4, 2023),
(20231208, '2023-12-08', 8,  12, 'December', 4, 2023),
(20230815, '2023-08-15', 15, 8,  'August',   3, 2023),
(20231212, '2023-12-12', 12, 12, 'December', 4, 2023),
(20230220, '2023-02-20', 20, 2,  'February', 1, 2023);

-- dim_store
INSERT INTO dim_store (store_key, store_name, city) VALUES
(1, 'Chennai Anna',    'Chennai'),
(2, 'Delhi South',     'Delhi'),
(3, 'Bangalore MG',    'Bangalore'),
(4, 'Pune FC Road',    'Pune'),
(5, 'Mumbai Central',  'Mumbai');

-- dim_product 
INSERT INTO dim_product (product_key, product_name, category, unit_price) VALUES
(1,  'Smartwatch',  'Electronics', 58851.01),
(2,  'Tablet',      'Electronics', 23226.12),
(3,  'Phone',       'Electronics', 48703.39),
(4,  'Speaker',     'Electronics', 49262.78),
(5,  'Headphones',  'Electronics', 39854.96),
(6,  'Laptop',      'Electronics', 42343.15),
(7,  'Atta 10kg',   'Grocery',     52464.00),
(8,  'Jeans',       'Clothing',    2317.47),
(9,  'Biscuits',    'Grocery',     27469.99),
(10, 'Jacket',      'Clothing',    30187.24);

 -- LOAD FACT DATA  (10 cleaned rows)
 --  Cleaning applied:
--    • Dates normalised to YYYY-MM-DD → mapped to date_key
--    • category casing standardised
--    • NULL cities resolved via store name lookup
--    • total_revenue = units_sold * unit_price (computed)
INSERT INTO fact_sales
    (date_key, store_key, product_key, transaction_id, customer_id,
     units_sold, unit_price, total_revenue)
VALUES
-- TXN5004 | 2023-01-15 | Chennai Anna | Smartwatch | 10 units
(20230115, 1, 1, 'TXN5004', 'CUST004', 10, 58851.01,  588510.10),

-- TXN5002 | 2023-02-05 | Chennai Anna | Phone | 20 units
(20230205, 1, 3, 'TXN5002', 'CUST019', 20, 48703.39,  974067.80),

-- TXN5006 | 2023-03-31 | Pune FC Road | Smartwatch | 6 units
(20230331, 4, 1, 'TXN5006', 'CUST025',  6, 58851.01,  353106.06),

-- TXN5010 | 2023-06-04 | Chennai Anna | Jacket | 15 units
(20230604, 1, 10,'TXN5010', 'CUST031', 15, 30187.24,  452808.60),

-- TXN5005 | 2023-08-09 | Bangalore MG | Atta 10kg | 12 units
(20230809, 3, 7, 'TXN5005', 'CUST027', 12, 52464.00,  629568.00),

-- TXN5007 | 2023-10-26 | Pune FC Road | Jeans | 16 units
(20231026, 4, 8, 'TXN5007', 'CUST041', 16,  2317.47,   37079.52),

-- TXN5008 | 2023-12-08 | Bangalore MG | Biscuits | 9 units
(20231208, 3, 9, 'TXN5008', 'CUST030',  9, 27469.99,  247229.91),

-- TXN5009 | 2023-08-15 | Bangalore MG | Smartwatch | 3 units
-- (raw date was "15/08/2023" — normalised to 2023-08-15)
(20230815, 3, 1, 'TXN5009', 'CUST020',  3, 58851.01,  176553.03),

-- TXN5001 | 2023-12-12 | Chennai Anna | Tablet | 11 units
-- (raw date was "12-12-2023" — normalised to 2023-12-12)
(20231212, 1, 2, 'TXN5001', 'CUST021', 11, 23226.12,  255487.32),

-- TXN5003 | 2023-02-20 | Delhi South | Tablet | 14 units
-- (raw date was "20-02-2023" — normalised to 2023-02-20)
(20230220, 2, 2, 'TXN5003', 'CUST007', 14, 23226.12,  325165.68);

 


