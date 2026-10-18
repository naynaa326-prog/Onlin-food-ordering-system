
USE food_ordering_system;

SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM categories;
SELECT * FROM menu_items;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;
SELECT * FROM deliveries;

SELECT * FROM customers WHERE address = 'Pune';
SELECT * FROM menu_items WHERE price < 100;
SELECT * FROM menu_items WHERE price BETWEEN 100 AND 300;
SELECT * FROM menu_items WHERE item_name LIKE '%Pizza%';
SELECT * FROM menu_items WHERE availability = 'Available';
SELECT * FROM menu_items WHERE availability = 'Unavailable';
SELECT * FROM orders WHERE order_status = 'Delivered';
SELECT * FROM orders WHERE order_status = 'Cancelled';
SELECT * FROM orders ORDER BY order_date DESC;
SELECT * FROM menu_items ORDER BY price DESC LIMIT 5;
SELECT * FROM customers ORDER BY customer_name ASC;

SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_restaurants FROM restaurants;
SELECT COUNT(*) AS total_menu_items FROM menu_items;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_payments FROM payments;
SELECT COUNT(*) AS total_deliveries FROM deliveries;

SELECT order_status, COUNT(*) AS total
FROM orders GROUP BY order_status;

SELECT payment_method, COUNT(*) AS total
FROM payments GROUP BY payment_method;

SELECT payment_status, COUNT(*) AS total
FROM payments GROUP BY payment_status;

SELECT category_id, COUNT(*) AS total_items
FROM menu_items GROUP BY category_id;

SELECT category_id, AVG(price) AS average_price
FROM menu_items GROUP BY category_id;

SELECT restaurant_id, MAX(price) AS highest_price
FROM menu_items GROUP BY restaurant_id;

SELECT restaurant_id, MIN(price) AS lowest_price
FROM menu_items GROUP BY restaurant_id;

SELECT restaurant_id, COUNT(*) AS item_count
FROM menu_items
GROUP BY restaurant_id
HAVING COUNT(*) >= 3;

SELECT m.item_name, m.price, r.restaurant_name
FROM menu_items m
JOIN restaurants r ON m.restaurant_id = r.restaurant_id;

SELECT m.item_name, c.category_name
FROM menu_items m
JOIN categories c ON m.category_id = c.category_id;

SELECT o.order_id, c.customer_name, o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT o.order_id, c.customer_name, r.restaurant_name,
       o.order_date, o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id;

SELECT oi.order_id, m.item_name, oi.quantity,
       oi.unit_price, oi.quantity * oi.unit_price AS line_total
FROM order_items oi
JOIN menu_items m ON oi.item_id = m.item_id;

SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

SELECT c.customer_name, COUNT(o.order_id) AS orders_placed
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT c.customer_name, o.order_id, p.amount,
       p.payment_method, p.payment_status
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id;

SELECT o.order_id, d.delivery_person, d.delivery_status
FROM orders o
LEFT JOIN deliveries d ON o.order_id = d.order_id;

SELECT r.restaurant_name,
       SUM(oi.quantity * oi.unit_price) AS delivered_sales
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name;

SELECT m.item_name, SUM(oi.quantity) AS total_sold
FROM menu_items m
JOIN order_items oi ON m.item_id = oi.item_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY m.item_id, m.item_name
ORDER BY total_sold DESC;

SELECT customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
);

SELECT item_name
FROM menu_items
WHERE price > (
    SELECT AVG(price) FROM menu_items
);

SELECT restaurant_name
FROM restaurants
WHERE restaurant_id IN (
    SELECT restaurant_id
    FROM menu_items
    GROUP BY restaurant_id
    HAVING AVG(price) > 150
);

SELECT order_id, amount
FROM payments
WHERE amount > (SELECT AVG(amount) FROM payments);

SELECT o.order_id, o.order_status
FROM orders o
WHERE NOT EXISTS (
    SELECT 1 FROM payments p
    WHERE p.order_id = o.order_id
);

SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;

SELECT order_id, amount,
       CASE
           WHEN payment_status = 'Paid' THEN 'Completed'
           WHEN payment_status = 'Pending' THEN 'Awaiting Payment'
           ELSE 'Payment Failed'
       END AS payment_description
FROM payments;

SELECT item_name, price,
       CASE
           WHEN price < 100 THEN 'Low Price'
           WHEN price <= 250 THEN 'Medium Price'
           ELSE 'High Price'
       END AS price_category
FROM menu_items;

SELECT COUNT(*) AS delivered_orders
FROM orders WHERE order_status = 'Delivered';

SELECT SUM(amount) AS total_paid
FROM payments WHERE payment_status = 'Paid';

SELECT SUM(amount) AS total_pending
FROM payments WHERE payment_status = 'Pending';

SELECT AVG(price) AS average_menu_price
FROM menu_items;

SELECT COUNT(*) AS orders_today
FROM orders
WHERE DATE(order_date) = CURDATE();

SELECT * FROM orders
WHERE order_date >= '2026-10-01'
  AND order_date < '2026-11-01';

SELECT * FROM deliveries
WHERE delivery_status <> 'Delivered';

SELECT r.restaurant_name, COUNT(o.order_id) AS order_count
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY order_count DESC;

SELECT * FROM menu_items
WHERE item_id NOT IN (
    SELECT item_id FROM order_items
);

SELECT c.category_name, MAX(m.price) AS maximum_price
FROM categories c
JOIN menu_items m ON c.category_id = m.category_id
GROUP BY c.category_id, c.category_name;

SELECT o.order_id, p.amount,
       SUM(oi.quantity * oi.unit_price) AS item_total
FROM orders o
JOIN payments p ON o.order_id = p.order_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, p.amount;

SELECT * FROM customers WHERE phone LIKE '98765000%';

SELECT restaurant_name FROM restaurants
WHERE city = 'Pune';

SHOW TABLES;

DESCRIBE customers;
DESCRIBE restaurants;
DESCRIBE categories;
DESCRIBE menu_items;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE payments;
DESCRIBE deliveries;

SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM restaurants) AS restaurants,
    (SELECT COUNT(*) FROM menu_items) AS menu_items,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM payments) AS payments,
    (SELECT COUNT(*) FROM deliveries) AS deliveries;
