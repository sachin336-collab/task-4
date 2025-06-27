-- Use database (create if not already created)
CREATE DATABASE IF NOT EXISTS internship_db;
USE internship_db;

-- Drop tables if they exist (for re-run safety)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- 1. Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- 2. Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- 3. Create Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 4. Create Order_Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data into customers
INSERT INTO customers VALUES 
(1, 'Sachin', 'sachin@mail.com', 'India'),
(2, 'Amit', 'amit@mail.com', 'USA'),
(3, 'Priya', 'priya@mail.com', 'UK');

-- Insert sample data into products
INSERT INTO products VALUES 
(101, 'Laptop', 60000),
(102, 'Phone', 30000),
(103, 'Tablet', 20000);

-- Insert sample data into orders
INSERT INTO orders VALUES 
(1001, 1, '2024-01-01'),
(1002, 2, '2024-01-02'),
(1003, 1, '2024-01-05');

-- Insert sample data into order_items
INSERT INTO order_items VALUES 
(1, 1001, 101, 1),
(2, 1001, 103, 2),
(3, 1002, 102, 1),
(4, 1003, 101, 1),
(5, 1003, 102, 2);

--  SELECT + WHERE + ORDER BY + GROUP BY
SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;

--  INNER JOIN: Order details with product names
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

--  AGGREGATE: Total revenue per product
SELECT p.product_name, SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

--  SUBQUERY: Customers who placed more than 1 order
SELECT customer_name FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

--  CREATE VIEW: Customer order summary
CREATE OR REPLACE VIEW customer_summary AS
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 👀 View data
SELECT * FROM customer_summary;

-- ⚙️ INDEX for optimization
CREATE INDEX idx_customer_id ON orders(customer_id);
CREATE INDEX idx_product_id ON order_items(product_id);
