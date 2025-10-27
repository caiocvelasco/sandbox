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
--   - DATE for dates (booking and ingestion dates)
--   - NUMERIC(10,2) for money-like values (two decimals)
--   - TEXT for text fields
-- We intentionally do NOT set primary keys yet (so we can train with duplicates).
CREATE TABLE IF NOT EXISTS practice.bookings (
    booking_id      INT,
    customer_id     INT,
    booking_date    DATE,
    amount          NUMERIC(10,2),
    status          TEXT,
    ingestion_date  DATE                           -- new column: date when the record was ingested into the system
);


-- ========================================
-- INSERT SAMPLE DATA INTO BOOKINGS (with duplicates)
-- ========================================

-- 3️) Insert a few rows across different months, customers, and statuses.
-- Notice that booking_id = 4 is intentionally duplicated.
-- We'll assign adjacent ingestion dates (2024-02-11 and 2024-02-12) to simulate ingestion of the same record twice.
INSERT INTO practice.bookings (booking_id, customer_id, booking_date, amount, status, ingestion_date)
VALUES
    (1, 10, '2024-01-05', 100.00, 'confirmed', '2024-01-06'),
    (2, 11, '2024-01-08', 200.00, 'cancelled', '2024-01-09'),
    (3, 10, '2024-02-01', 150.00, 'confirmed', '2024-02-02'),
    (4, 12, '2024-02-10', 300.00, 'confirmed', '2024-02-11'),
    (4, 12, '2024-02-10', 300.00, 'confirmed', '2024-02-11'),  -- ⚠️ duplicate on purpose, same day
    (5, 13, '2024-02-15', 120.00, 'confirmed', '2024-02-16'),
    (6, 11, '2024-03-03', 180.00, 'confirmed', '2024-03-04'),
    (7, 14, '2024-03-07', 220.00, 'cancelled', '2024-03-08'),
    (8, 10, '2024-03-18', 250.00, 'confirmed', '2024-03-19');

-- Here, don't forget to change the '2025-09-18' for a day in the previous month related to today.
-- In my case, today is 25_10_2025, so I need any date from September.
INSERT INTO practice.bookings (booking_id, customer_id, booking_date, amount, status, ingestion_date)
VALUES
    (9, 15, '2025-09-18', 100.00, 'confirmed', '2025-09-19');


-- ========================================
-- CREATE TABLE: BOOKINGS_DEDUP (no duplicates)
-- ========================================

-- Same structure as 'bookings', but without duplicates.
CREATE TABLE IF NOT EXISTS practice.bookings_dedup (
    booking_id      INT,
    customer_id     INT,
    booking_date    DATE,
    amount          NUMERIC(10,2),
    status          TEXT,
    ingestion_date  DATE                           -- new column for ingestion tracking
);


-- ========================================
-- INSERT SAMPLE DATA INTO BOOKINGS_DEDUP (no duplicates)
-- ========================================

INSERT INTO practice.bookings_dedup (booking_id, customer_id, booking_date, amount, status, ingestion_date)
VALUES
    (1, 10, '2024-01-05', 100.00, 'confirmed', '2024-01-06'),
    (2, 11, '2024-01-08', 200.00, 'cancelled', '2024-01-09'),
    (3, 10, '2024-02-01', 150.00, 'confirmed', '2024-02-02'),
    (4, 12, '2024-02-10', 300.00, 'confirmed', '2024-02-11'),
    (5, 13, '2024-02-15', 120.00, 'confirmed', '2024-02-16'),
    (6, 11, '2024-03-03', 180.00, 'confirmed', '2024-03-04'),
    (7, 14, '2024-03-07', 220.00, 'cancelled', '2024-03-08'),
    (8, 10, '2024-03-18', 250.00, 'confirmed', '2024-03-19');

-- Same logic as above (September booking for “previous month” logic)
INSERT INTO practice.bookings_dedup (booking_id, customer_id, booking_date, amount, status, ingestion_date)
VALUES
    (9, 15, '2025-09-18', 100.00, 'confirmed', '2025-09-19');


-- ========================================
-- CREATE TABLE: CUSTOMERS
-- ========================================

-- Simple table for joining with bookings.
CREATE TABLE IF NOT EXISTS practice.customers (
    customer_id     INT,
    country         TEXT,
    ingestion_date  DATE                               -- new column: when the customer record was ingested
);


-- ========================================
-- INSERT SAMPLE DATA INTO CUSTOMERS
-- ========================================

INSERT INTO practice.customers (customer_id, country, ingestion_date)
VALUES
    (10, 'Spain',   '2024-01-05'),
    (11, 'Brazil',  '2024-01-08'),
    (12, 'Germany', '2024-02-10'),
    (13, 'Spain',   '2024-02-15'),
    (14, 'Italy',   '2024-03-07'),
    (15, 'Italy',   '2025-09-18');


-- ========================================
-- CHECKS: CONFIRM THAT THE DATA WAS INSERTED CORRECTLY
-- ========================================

-- Expect 9 rows (including one duplicate for booking_id = 4 with different ingestion dates)
SELECT * FROM practice.bookings;

-- Confirm unique customers
SELECT DISTINCT customer_id FROM practice.bookings ORDER BY customer_id;

-- Join bookings with customers to validate ingestion and country mappings
SELECT
    b.booking_id,
    b.amount,
    b.status,
    b.booking_date,
    b.ingestion_date,
    c.country,
    c.ingestion_date AS customer_ingestion_date
FROM practice.bookings b
JOIN practice.customers c
  ON b.customer_id = c.customer_id
ORDER BY b.booking_id;
