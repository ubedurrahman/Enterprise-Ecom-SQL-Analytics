create database consumerelectronics;
use consumerelectronics;
---------------ADDING INDIVIDUAL REQUIRED TABLES-------------------------------
-- 1.Create Marketing Channels Dimension Table (Tracks acquisition sources)
CREATE TABLE marketing_channels
(channel_id INT NOT NULL PRIMARY KEY CLUSTERED,
channel_name VARCHAR(50) NOT NULL,
cost_per_click DECIMAL(10, 2) NOT NULL CHECK (cost_per_click >= 0)
);

-- 2. Create Customers Dimension Table (Tracks demographic user baseline)
CREATE TABLE customers(
customer_id INT NOT NULL PRIMARY KEY CLUSTERED,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
city VARCHAR(50) NOT NULL,
signup_date DATE NOT NULL,
channel_id INT NULL FOREIGN KEY REFERENCES marketing_channels(channel_id)
);

-- 3. Create Products Dimension Table (Tracks specific catalog stock and retail cost logic)
CREATE TABLE products(
product_id INT NOT NULL PRIMARY KEY CLUSTERED,
product_name VARCHAR(100) NOT NULL,
category VARCHAR(50) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
cost_price DECIMAL(10, 2) NOT NULL CHECK (cost_price > 0),
CONSTRAINT [chk_prices] CHECK (unit_price >= cost_price) -- Guardrail: Prevents selling items below production cost
);

-- 4. Create Orders Central Fact Table (The core relational engine tracking physical events)
CREATE TABLE orders(
order_id INT NOT NULL PRIMARY KEY CLUSTERED,
customer_id INT NULL FOREIGN KEY REFERENCES customers(customer_id),
product_id INT NULL FOREIGN KEY REFERENCES products(product_id),
order_date DATE NOT NULL,
quantity INT NOT NULL CHECK (quantity > 0),
total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0)
);

-- 5. Create Transactions Fact Table Extension (Handles financial settlement audits)
CREATE TABLE transactions(
transaction_id INT NOT NULL PRIMARY KEY CLUSTERED,
order_id INT NULL FOREIGN KEY REFERENCES orders(order_id),
payment_method VARCHAR(50) NOT NULL,
payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('Success', 'Failed', 'Refunded'))
);

------------------------INSERTING DATA INTO TABLES-------------------------------------------
-- Marketing Data
INSERT INTO marketing_channels VALUES 
(1, 'Google Ads', 1.25), (2, 'Meta Ads', 0.85), 
(3, 'Email Newsletter', 0.05), (4, 'Organic Search', 0.00), (5, 'YouTube Sponsor', 2.10);

-- Inventory Data
INSERT INTO products VALUES 
(101, 'Pro Wireless Headphones', 'Audio', 149.99, 65.00),
(102, '4K Ultra-Wide Monitor', 'Displays', 399.99, 180.00),
(103, 'Mechanical Gaming Keyboard', 'Peripherals', 89.99, 35.00),
(104, 'Ergonomic Wireless Mouse', 'Peripherals', 49.99, 18.00),
(105, 'Smart Fitness Watch v2', 'Audio', 199.99, 90.00),
(106, 'Noise Cancelling Earbuds', 'Audio', 79.99, 30.00);

-- Customer Data
INSERT INTO customers VALUES 
(1, 'Ubed', 'Ur Rahman', 'ubed.rahman@zoho.com', 'Hyderabad', '2025-01-15', 4),
(2, 'Sarah', 'Jones', 'sarah.j@gmail.com', 'New York', '2025-02-18', 1),
(3, 'Michael', 'Brown', 'mbrown@yahoo.com', 'London', '2025-03-10', 2),
(4, 'Emily', 'Davis', 'emily.d@outlook.com', 'Chicago', '2025-04-05', 3),
(5, 'John', 'Smith', 'jsmith@gmail.com', 'San Francisco', '2025-05-22', 1),
(6, 'David', 'Wilson', 'dwilson@zoho.com', 'Hyderabad', '2025-06-14', 4),
(7, 'Jessica', 'Taylor', 'jess.taylor@gmail.com', 'Austin', '2025-07-19', 2),
(8, 'James', 'Miller', 'jmiller@hotmail.com', 'Seattle', '2025-08-01', 3),
(9, 'Anna', 'Thomas', 'athomas@gmail.com', 'Miami', '2025-09-12', 1),
(10, 'Robert', 'White', 'rwhite@zoho.com', 'Hyderabad', '2025-10-25', 5),
(11, 'Chris', 'Martin', 'cmartin@coldplay.com', 'London', '2025-11-02', 4),
(12, 'Alex', 'Green', 'alex.g@gmail.com', 'Boston', '2025-12-05', 1),
(13, 'Laura', 'Grey', 'laura.g@yahoo.com', 'Denver', '2026-01-20', 2),
(14, 'Kevin', 'Black', 'kblack@outlook.com', 'Dallas', '2026-02-14', 3),
(15, 'Emma', 'Stone', 'estone@gmail.com', 'Los Angeles', '2026-03-01', 5);

-- Core Sales Transactions Data
INSERT INTO orders VALUES 
(5001, 1, 101, '2025-01-20', 1, 149.99),
(5002, 2, 102, '2025-02-25', 1, 399.99),
(5003, 3, 103, '2025-03-15', 2, 179.98),
(5004, 4, 104, '2025-04-10', 1, 49.99),
(5005, 5, 105, '2025-05-30', 1, 199.99),
(5006, 1, 104, '2025-06-20', 1, 49.99),
(5007, 6, 101, '2025-07-02', 1, 149.99),
(5008, 7, 102, '2025-07-22', 1, 399.99),
(5009, 8, 103, '2025-08-15', 1, 89.99),
(5010, 9, 106, '2025-09-20', 3, 239.97),
(5011, 10, 105, '2025-10-30', 1, 199.99),
(5012, 3, 106, '2025-11-15', 1, 79.99),
(5013, 11, 102, '2025-12-01', 1, 399.99),
(5014, 12, 104, '2026-01-05', 2, 99.98),
(5015, 13, 101, '2026-02-10', 1, 149.99),
(5016, 1, 102, '2026-03-15', 1, 399.99),
(5017, 14, 103, '2026-04-22', 1, 89.99),
(5018, 15, 105, '2026-05-18', 1, 199.99),
(5019, 2, 106, '2026-06-01', 1, 79.99),
(5020, 6, 104, '2026-07-14', 1, 49.99);

-- Gateway Audits Data
INSERT INTO transactions VALUES 
(9001, 5001, 'UPI', 'Success'), (9002, 5002, 'Credit Card', 'Success'),
(9003, 5003, 'PayPal', 'Success'), (9004, 5004, 'Credit Card', 'Failed'),
(9005, 5005, 'Apple Pay', 'Success'), (9006, 5006, 'UPI', 'Success'),
(9007, 5007, 'UPI', 'Success'), (9008, 5008, 'Credit Card', 'Success'),
(9009, 5009, 'PayPal', 'Refunded'), (9010, 5010, 'Credit Card', 'Success'),
(9011, 5011, 'UPI', 'Success'), (9012, 5012, 'PayPal', 'Success'),
(9013, 5013, 'Credit Card', 'Success'), (9014, 5014, 'Credit Card', 'Success'),
(9015, 5015, 'Apple Pay', 'Success'), (9016, 5016, 'UPI', 'Success'),
(9017, 5017, 'PayPal', 'Success'), (9018, 5018, 'Apple Pay', 'Success'),
(9019, 5019, 'Credit Card', 'Success'), (9020, 5020, 'UPI', 'Success');

-------------------------FINANCIAL PERFORMANCE & REVENUE------------------------------------------
-- Query 1: Which customers generated the most revenue? (VIP Client Allocation)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    ROUND(SUM(o.total_amount), 2) AS total_revenue_generated,
    COUNT(o.order_id) AS transaction_count
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_revenue_generated DESC;

-- Query 2: Monthly Store Revenue Trends
SELECT 
    FORMAT(o.order_date, 'yyyy-MM') AS sales_month,
    ROUND(SUM(o.total_amount), 2) AS monthly_gross_revenue,
    COUNT(o.order_id) AS volume_of_orders
FROM dbo.orders o
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
ORDER BY sales_month ASC;

-- Query 3: Average Order Value (AOV) Metrics
SELECT 
    ROUND(AVG(total_amount), 2) AS average_order_value,
    AVG(quantity) AS average_items_per_basket,
    SUM(quantity) AS total_units_shipped
FROM dbo.orders;

----------------------------GROWTH MOMENTUM & MARKETING ROI----------------------------------------
-- Query 1: Which product categories are growing fastest Month-over-Month (MoM)?
WITH MonthlyProductRevenue AS (
SELECT
p.category,
FORMAT(o.order_date, 'yyyy-MM') AS sales_month,
SUM(o.total_amount) AS current_month_revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, FORMAT(o.order_date, 'yyyy-MM')
),
GrowthCalculations AS (
SELECT
category,
sales_month,
ROUND(current_month_revenue, 2) AS current_month_revenue,
ROUND(LAG(current_month_revenue, 1) OVER (PARTITION BY category ORDER BY sales_month), 2) AS previous_month_revenue
FROM MonthlyProductRevenue
)
SELECT
category,
sales_month,
current_month_revenue,
ISNULL(previous_month_revenue, 0) AS previous_month_revenue,
CASE
WHEN previous_month_revenue IS NULL THEN '0.00%'
ELSE CAST(ROUND(((current_month_revenue - previous_month_revenue) / previous_month_revenue) * 100, 2) AS VARCHAR(20)) + '%'
END AS mom_growth_rate
FROM GrowthCalculations
ORDER BY category, sales_month;

-- Query 2: Which marketing channel has the highest customer conversion metrics?
WITH TotalChannelCustomers AS (
SELECT
channel_id,
COUNT(customer_id) AS total_acquired_users
FROM customers
GROUP BY channel_id
),
ConvertingChannelCustomers AS (
SELECT
c.channel_id,
COUNT(DISTINCT o.customer_id) AS unique_purchasing_users,
SUM(o.total_amount) AS channel_gross_revenue
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.channel_id
)
SELECT
mc.channel_name,
tcc.total_acquired_users,
ISNULL(ccc.unique_purchasing_users, 0) AS converting_users,
ROUND((CAST(ISNULL(ccc.unique_purchasing_users, 0) AS DECIMAL(10,2)) / tcc.total_acquired_users) * 100, 2) AS conversion_rate_pct,
ROUND(ISNULL(ccc.channel_gross_revenue, 0), 2) AS total_channel_revenue
FROM marketing_channels mc
INNER JOIN TotalChannelCustomers tcc ON mc.channel_id = tcc.channel_id
LEFT JOIN ConvertingChannelCustomers ccc ON mc.channel_id = ccc.channel_id
ORDER BY conversion_rate_pct DESC;

------------------------ RETENTION & VALUE SEGMENTATION-----------------------------------------
-- Query 1: Customer Repeat-Purchase Velocity Rate
WITH OrderFrequencies AS (
SELECT
customer_id,
COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
)
SELECT
COUNT(customer_id) AS total_shoppers,
SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_buyers,
ROUND((CAST(SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / COUNT(customer_id)) * 100, 2) AS repeat_purchase_rate_pct
FROM OrderFrequencies;

-- Query 2: Critical Retention Watch — Who hasn't purchased a gadget in the last 90 days?
SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.email,
MAX(o.order_date) AS last_purchase_date,
DATEDIFF(day, MAX(o.order_date), '2026-11-09') AS days_since_last_order -- Baseline evaluation benchmark date matching 2026 context
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING DATEDIFF(day, MAX(o.order_date), '2026-11-09') > 90
ORDER BY days_since_last_order DESC;

-- Query 3: Audience Portfolio Value Segmentation (High/Medium/Low Lifetime Value tracking)
WITH CustomerLTV AS (
SELECT
customer_id,
SUM(total_amount) AS total_spend
FROM orders
GROUP BY customer_id
)
SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.city,
ROUND(cltv.total_spend, 2) AS lifetime_value,
CASE
WHEN cltv.total_spend >= 400.00 THEN 'Tier 1: High Value (VIP Portfolio)'
WHEN cltv.total_spend BETWEEN 150.00 AND 399.99 THEN 'Tier 2: Mid Value (Growth Track)'
ELSE 'Tier 3: Low Value (Nurture Pool)'
END AS market_segmentation
FROM customers c
INNER JOIN CustomerLTV cltv ON c.customer_id = cltv.customer_id
ORDER BY lifetime_value DESC;