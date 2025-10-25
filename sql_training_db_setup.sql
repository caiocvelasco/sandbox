-- ========================================
-- SETUP: CREATE A PRACTICE SCHEMA AND TABLES
-- ========================================

-- 1️) Create a schema (like a folder/namespace) to keep all our practice tables organized.
-- The IF NOT EXISTS avoids errors if the schema already exists.
CREATE SCHEMA IF NOT EXISTS practice;


-- ========================================
-- CREATE TABLE: BOOKINGS (with duplicates)
-- ========================================

-- 2️) Create a 'bookings' table to store sample reservation data.
-- We'll include a few different data types:
--   - INT for IDs
--   - DATE for dates
--   - NUMERIC(10,2) for money-like values (two decimals)
--   - TEXT for text fields
-- We intentionally do NOT set primary keys yet (so we can train with duplicates).
CREATE TABLE IF NOT EXISTS practice.bookings (
    booking_id      INT,
    customer_id     INT,
    booking_date    DATE,
    amount          NUMERIC(10,2),
    status          TEXT
);


-- ========================================
-- INSERT SAMPLE DATA INTO BOOKINGS (with duplicates)
-- ========================================

-- 3️) Insert a few rows across different months, customers, and statuses.
-- Notice that booking_id = 4 is intentionally duplicated
-- so we can practice deduplication later.
INSERT INTO practice.bookings (booking_id, customer_id, booking_date, amount, status)
VALUES
    (1, 10, '2024-01-05', 100.00, 'confirmed'),
    (2, 11, '2024-01-08', 200.00, 'cancelled'),
    (3, 10, '2024-02-01', 150.00, 'confirmed'),
    (4, 12, '2024-02-10', 300.00, 'confirmed'),
    (4, 12, '2024-02-10', 300.00, 'confirmed'),  -- ⚠️ duplicate on purpose
    (5, 13, '2024-02-15', 120.00, 'confirmed'),
    (6, 11, '2024-03-03', 180.00, 'confirmed'),
    (7, 14, '2024-03-07', 220.00, 'cancelled'),
    (8, 10, '2024-03-18', 250.00, 'confirmed');

-- Here, don't forget to change the '2025-09-18' for a day in the previous month related to today.
-- In my case, today is 25_10_2025, so I need any date from September. This is important for one of the exercises.
INSERT INTO practice.bookings (booking_id, customer_id, booking_date, amount, status)
VALUES
	(9, 15, '2025-09-18', 100.00, 'confirmed');

-- ========================================
-- CREATE TABLE: BOOKINGS_DEDUP (no duplicates)
-- ========================================

-- 2️) Create a 'bookings' table to store sample reservation data.
-- We'll include a few different data types:
--   - INT for IDs
--   - DATE for dates
--   - NUMERIC(10,2) for money-like values (two decimals)
--   - TEXT for text fields
-- We intentionally do NOT set primary keys yet (so we can train with duplicates).
CREATE TABLE IF NOT EXISTS practice.bookings_dedup (
    booking_id      INT,
    customer_id     INT,
    booking_date    DATE,
    amount          NUMERIC(10,2),
    status          TEXT
);


-- ========================================
-- INSERT SAMPLE DATA INTO BOOKINGS_DEDUP (no duplicates)
-- ========================================

-- 3️) Insert a few rows across different months, customers, and statuses.
-- Notice that booking_id = 4 is intentionally duplicated
-- so we can practice deduplication later.
INSERT INTO practice.bookings_dedup (booking_id, customer_id, booking_date, amount, status)
VALUES
    (1, 10, '2024-01-05', 100.00, 'confirmed'),
    (2, 11, '2024-01-08', 200.00, 'cancelled'),
    (3, 10, '2024-02-01', 150.00, 'confirmed'),
    (4, 12, '2024-02-10', 300.00, 'confirmed'),
    (5, 13, '2024-02-15', 120.00, 'confirmed'),
    (6, 11, '2024-03-03', 180.00, 'confirmed'),
    (7, 14, '2024-03-07', 220.00, 'cancelled'),
    (8, 10, '2024-03-18', 250.00, 'confirmed');

-- Here, don't forget to change the '2025-09-18' for a day in the previous month related to today.
-- In my case, today is 25_10_2025, so I need any date from September. This is important for one of the exercises.
INSERT INTO practice.bookings_dedup (booking_id, customer_id, booking_date, amount, status)
VALUES
	(9, 15, '2025-09-18', 100.00, 'confirmed');

-- ========================================
-- CREATE TABLE: CUSTOMERS
-- ========================================

-- 4️) Create a simple 'customers' table to join later.
-- We'll keep only two columns for now.
CREATE TABLE IF NOT EXISTS practice.customers (
    customer_id     INT,
    country         TEXT
);


-- ========================================
-- INSERT SAMPLE DATA INTO CUSTOMERS
-- ========================================

-- 5️) Insert one row per customer, matching the customer_ids in 'bookings'.
INSERT INTO practice.customers (customer_id, country)
VALUES
    (10, 'Spain'),
    (11, 'Brazil'),
    (12, 'Germany'),
    (13, 'Spain'),
    (14, 'Italy')
	(15, 'Italy');

-- ========================================
-- CHECKS: CONFIRM THAT THE DATA WAS INSERTED CORRECTLY
-- ========================================

-- 6️) View all rows in bookings.
-- Expect 9 rows (including one duplicate for booking_id = 4).
SELECT * FROM practice.bookings;

-- 7️) Check all distinct customers who made bookings.
-- Useful to confirm unique customer_ids.
SELECT DISTINCT customer_id
FROM practice.bookings
ORDER BY customer_id;

-- 8️) Join bookings with customers to see combined information.
-- This validates that the join on customer_id works properly.
SELECT
    b.booking_id,
    b.amount,
    b.status,
    b.booking_date,
    c.country
FROM practice.bookings b
JOIN practice.customers c
  ON b.customer_id = c.customer_id
ORDER BY b.booking_id;

-- If you see booking info with matching country, everything is ready for exercises!
