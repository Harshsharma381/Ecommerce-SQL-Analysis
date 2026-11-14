-- 1. Order Status Analysis
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 2. Total Revenue
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;


-- 3. Total Unique Customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;


-- 4. Total Orders
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- 5. Delivery Rate
SELECT
    COUNT(*) FILTER (WHERE order_status = 'delivered') AS delivered_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_status = 'delivered') / COUNT(*),
        2
    ) AS delivery_rate_pct
FROM orders;


-- 6. Monthly Revenue Analysis
SELECT
    TO_CHAR(DATE_TRUNC('month', o.order_purchase_timestamp), 'YYYY-MM') AS sales_month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp);


-- 7. Top 10 Product Categories
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'unknown'
    ) AS category,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- 8. Payment Methods Analysis
SELECT
    payment_type,
    COUNT(*) AS total_payments,
    ROUND(SUM(payment_value), 2) AS total_amount
FROM payments
GROUP BY payment_type
ORDER BY total_amount DESC;



