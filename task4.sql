-- Create and use the database
CREATE DATABASE IF NOT EXISTS internship_db;
USE internship_db;

-- Drop tables if they already exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create order_items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert data into customers
INSERT INTO customers VALUES
(1, 'Sachin', 'sachin@mail.com', 'India'),
(2, 'Amit', 'amit@mail.com', 'USA'),
(3, 'Priya', 'priya@mail.com', 'UK'),
(4, 'Ravi', 'ravi@mail.com', 'Canada');

-- Insert data into products
INSERT INTO products VALUES
(101, 'Laptop', 60000.00),
(102, 'Smartphone', 30000.00),
(103, 'Headphones', 2000.00),
(104, 'Tablet', 25000.00);

-- Insert data into orders
INSERT INTO orders VALUES
(1001, 1, '2024-01-10'),
(1002, 2, '2024-01-15'),
(1003, 1, '2024-02-01'),
(1004, 3, '2024-02-10');

-- Insert data into order_items
INSERT INTO order_items VALUES
(1, 1001, 101, 1),
(2, 1001, 103, 2),
(3, 1002, 102, 1),
(4, 1003, 104, 1),
(5, 1004, 103, 3);

-- Select queries
SELECT * FROM customers WHERE country = 'India';
SELECT * FROM products ORDER BY price DESC;
SELECT country, COUNT(*) AS total_customers FROM customers GROUP BY country;

-- Inner Join
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity, p.price,
       (oi.quantity * p.price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Left Join
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Aggregate functions
SELECT p.product_name, SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

SELECT c.customer_name, AVG(oi.quantity * p.price) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name;

-- Subquery
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);

-- Create View
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- View usage
SELECT * FROM customer_order_summary;

-- Index creation
CREATE INDEX idx_customer ON orders(customer_id);
CREATE INDEX idx_product ON order_items(product_id);
-- Additional Indexes for Optimization

-- Index to speed up JOIN and WHERE on customer_id
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Index to speed up JOIN on product_id
CREATE INDEX idx_orderitems_product_id ON order_items(product_id);

-- Index to optimize WHERE clause on country
CREATE INDEX idx_customers_country ON customers(country);

-- Index to optimize WHERE or ORDER BY on order_date
CREATE INDEX idx_orders_date ON orders(order_date);