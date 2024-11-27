-- Создаю таблицу с категориями товаров.
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Создаю таблицу с продуктами.
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

-- Создаю таблицу с покупателями.
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Создаю таблицу с заказами.
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10, 2) CHECK (total_amount >= 0)
);

-- Создаю таблицу связывающую продукты с заказом.
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_price NUMERIC(10, 2) NOT NULL
);

--Вставка начальных данных
--Категории
INSERT INTO categories (category_name) VALUES
('Men Clothing'),
('Women Clothing'),
('Accessories'),
('Shoes');

-- Продукты
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('T-shirt', 1, 15.99, 100),
('Jeans', 1, 49.99, 50),
('Dress', 2, 89.99, 30),
('Handbag', 3, 120.50, 20),
('Sneakers', 4, 75.00, 40);

-- Клиенты
INSERT INTO customers (first_name, last_name, email) VALUES
('Alice', 'Smith', 'alice.smith@example.com'),
('Bob', 'Johnson', 'bob.johnson@example.com'),
('Charlie', 'Brown', 'charlie.brown@example.com');

-- Заказы
INSERT INTO orders (customer_id, total_amount) VALUES
(1, 165.98);

-- Ещё раз заполняю таблицу с заказами, чтобы было другое время заказа.
INSERT INTO orders (customer_id, total_amount) VALUES
(2, 75.00);

--Заполняю продукты в заказах
INSERT INTO order_items (order_id, product_id, quantity, total_price) VALUES
(1, 1, 2, 31.98),
(1, 2, 1, 49.99),
(1, 3, 1, 89.99),
(2, 5, 1, 75.00);

--Вывести все товары с их категориями и количеством на складе
SELECT
    p.product_name,
    c.category_name,
    p.stock_quantity
FROM
    products p
JOIN
    categories c ON p.category_id = c.category_id
ORDER BY
    c.category_name, p.product_name
LIMIT 20;

--Общая выручка по каждому продукту
SELECT
    p.product_name,
    SUM(oi.total_price) AS total_revenue
FROM
    products p
JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY
    p.product_name
ORDER BY
    total_revenue DESC
LIMIT 20;

--Сколько заказов сделал каждый клиент
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    order_count DESC
LIMIT 20;

--Вывести категории с количеством товаров в каждой
SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM
    categories c
LEFT JOIN
    products p ON c.category_id = p.category_id
GROUP BY
    c.category_id
ORDER BY
    product_count DESC
LIMIT 20;

--Общая выручка по всем заказам
SELECT
    SUM(total_amount) AS total_revenue
FROM
    orders;