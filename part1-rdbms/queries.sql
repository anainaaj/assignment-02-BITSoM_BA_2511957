-- Q1.2 -- Schema Design
-- Customers
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);

-- Products
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- Sales Representatives
CREATE TABLE sales_reps (
    sales_rep_id VARCHAR(10) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL,
    office_address VARCHAR(200) NOT NULL
);

-- Orders
CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- Order Items
CREATE TABLE order_items (
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Sample Inserts (5 each)

INSERT INTO customers VALUES
('C001','Alice','alice@email.com','Mumbai'),
('C002','Bob','bob@email.com','Delhi'),
('C003','Charlie','charlie@email.com','Mumbai'),
('C004','David','david@email.com','Chennai'),
('C005','Eva','eva@email.com','Mumbai');

INSERT INTO products VALUES
('P001','Laptop','Electronics',50000),
('P002','Phone','Electronics',20000),
('P003','Tablet','Electronics',15000),
('P004','Chair','Furniture',3000),
('P005','Desk','Furniture',7000);

INSERT INTO sales_reps VALUES
('S001','John','john@email.com','Delhi Office'),
('S002','Mary','mary@email.com','Mumbai HQ'),
('S003','Steve','steve@email.com','Bangalore Office'),
('S004','Anna','anna@email.com','Chennai Office'),
('S005','Paul','paul@email.com','Kolkata Office');

INSERT INTO orders VALUES
('O001','C001','S002','2024-01-01'),
('O002','C002','S001','2024-01-02'),
('O003','C003','S002','2024-01-03'),
('O004','C004','S004','2024-01-04'),
('O005','C005','S002','2024-01-05');

INSERT INTO order_items VALUES
('O001','P001',1),
('O001','P002',2),
('O002','P003',1),
('O003','P001',1),
('O004','P004',4);
