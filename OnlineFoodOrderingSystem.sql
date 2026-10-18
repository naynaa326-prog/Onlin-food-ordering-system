CREATE DATABASE IF NOT EXISTS food_ordering_system;
USE food_ordering_system;

-- 1. CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200) NOT NULL
);

-- 2. RESTAURANTS TABLE
CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(15)
);

-- 3. CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- 4. MENU ITEMS TABLE
CREATE TABLE IF NOT EXISTS menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    availability ENUM('Available', 'Unavailable')
        NOT NULL DEFAULT 'Available',

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

-- 5. ORDERS TABLE
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status ENUM(
        'Placed', 'Preparing', 'Out for Delivery',
        'Delivered', 'Cancelled'
    ) NOT NULL DEFAULT 'Placed',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);

-- 6. ORDER ITEMS TABLE
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id),

    UNIQUE (order_id, item_id)
);

-- 7. PAYMENTS TABLE
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_method ENUM('UPI', 'Card', 'Cash', 'Net Banking')
        NOT NULL,
    payment_status ENUM('Pending', 'Paid', 'Failed')
        NOT NULL DEFAULT 'Pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 8. DELIVERIES TABLE
CREATE TABLE IF NOT EXISTS deliveries (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    delivery_person VARCHAR(100),
    delivery_phone VARCHAR(15),
    delivery_status ENUM(
        'Assigned', 'Picked Up', 'Delivered'
    ) NOT NULL DEFAULT 'Assigned',
    delivered_at DATETIME NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ==================================================
-- SAMPLE DATA
-- Explicit IDs make the relationships easy to test.
-- INSERT IGNORE helps avoid duplicate primary keys
-- when this sample-data section is run again.
-- ==================================================

-- Customers
INSERT IGNORE INTO customers
(customer_id, customer_name, phone, email, address)
VALUES
(1, 'Aarav Sharma', '9876500001', 'aarav@mail.com', 'Pune'),
(2, 'Neha Patil', '9876500002', 'neha@mail.com', 'Pimpri'),
(3, 'Rohan Desai', '9876500003', 'rohan@mail.com', 'Chinchwad'),
(4, 'Sneha Joshi', '9876500004', 'sneha@mail.com', 'Wakad'),
(5, 'Amit Kulkarni', '9876500005', 'amit@mail.com', 'Akurdi');

-- Restaurants
INSERT IGNORE INTO restaurants
(restaurant_id, restaurant_name, city, phone)
VALUES
(1, 'Spice Garden', 'Pune', '0205550101'),
(2, 'Pizza Point', 'Pune', '0205550102'),
(3, 'Biryani House', 'Pune', '0205550103');

-- Categories
INSERT IGNORE INTO categories
(category_id, category_name)
VALUES
(1, 'Veg'),
(2, 'Non-Veg'),
(3, 'Dessert'),
(4, 'Drinks'),
(5, 'Snacks');

-- Menu Items
INSERT IGNORE INTO menu_items
(item_id, restaurant_id, category_id, item_name, price, availability)
VALUES
(1, 1, 1, 'Paneer Butter Masala', 220.00, 'Available'),
(2, 1, 1, 'Butter Naan', 40.00, 'Available'),
(3, 1, 3, 'Gulab Jamun', 60.00, 'Available'),
(4, 1, 4, 'Mango Lassi', 80.00, 'Available'),
(5, 2, 1, 'Margherita Pizza', 250.00, 'Available'),
(6, 2, 2, 'Chicken Pizza', 350.00, 'Available'),
(7, 2, 4, 'Cold Coffee', 90.00, 'Available'),
(8, 3, 2, 'Chicken Biryani', 280.00, 'Available'),
(9, 3, 1, 'Veg Biryani', 200.00, 'Available'),
(10, 3, 5, 'Samosa', 25.00, 'Unavailable');

-- Orders
INSERT IGNORE INTO orders
(order_id, customer_id, restaurant_id, order_date, order_status)
VALUES
(101, 1, 1, '2026-10-01 12:00:00', 'Delivered'),
(102, 2, 2, '2026-10-02 13:00:00', 'Delivered'),
(103, 1, 3, '2026-10-05 19:00:00', 'Delivered'),
(104, 3, 3, '2026-10-10 14:00:00', 'Preparing'),
(105, 4, 1, '2026-10-12 20:00:00', 'Cancelled'),
(106, 5, 2, '2026-10-15 18:30:00', 'Placed');

-- Order Items
INSERT IGNORE INTO order_items
(order_item_id, order_id, item_id, quantity, unit_price)
VALUES
(1, 101, 1, 1, 220.00),
(2, 101, 2, 4, 40.00),
(3, 101, 3, 2, 60.00),
(4, 102, 5, 1, 250.00),
(5, 102, 7, 2, 90.00),
(6, 103, 8, 2, 280.00),
(7, 103, 9, 2, 200.00),
(8, 104, 9, 1, 200.00),
(9, 104, 3, 1, 60.00),
(10, 105, 1, 1, 220.00),
(11, 106, 6, 1, 350.00),
(12, 106, 7, 1, 90.00);

-- Payments
INSERT IGNORE INTO payments
(payment_id, order_id, amount, payment_method, payment_status)
VALUES
(1, 101, 500.00, 'UPI', 'Paid'),
(2, 102, 430.00, 'Card', 'Paid'),
(3, 103, 960.00, 'UPI', 'Paid'),
(4, 104, 260.00, 'Cash', 'Pending'),
(5, 106, 440.00, 'Card', 'Pending');

-- Deliveries
INSERT IGNORE INTO deliveries
(delivery_id, order_id, delivery_person, delivery_phone,
 delivery_status, delivered_at)
VALUES
(1, 101, 'Raj Kumar', '9000000001', 'Delivered',
 '2026-10-01 13:00:00'),
(2, 102, 'Vijay Patil', '9000000002', 'Delivered',
 '2026-10-02 14:00:00'),
(3, 103, 'Aman Shaikh', '9000000003', 'Delivered',
 '2026-10-05 20:00:00'),
(4, 104, 'Ravi More', '9000000004', 'Assigned', NULL);

COMMIT;

-- Verify that all 8 tables were created
SHOW TABLES;
