-- ===========================================================
-- 🧠 LEVEL 3 SQL PRACTICE — WINDOW FUNCTIONS & SUBQUERIES
-- ===========================================================
-- Tables:
--   practice.bookings_dedup
--   practice.customers
-- ===========================================================


-- 🧩 Exercise 1:
-- For each booking, show:
--   booking_id, customer_id, booking_date, amount,
--   and total revenue per customer (use a window function).

-- 🧩 Exercise 2:
-- For each booking, show:
--   booking_id, customer_id, amount,
--   and the average booking amount for that customer.

-- 🧩 Exercise 3:
-- Add a running total of confirmed revenue ordered by booking_date.

-- 🧩 Exercise 4:
-- Rank all customers by total confirmed revenue (1 = highest).

-- 🧩 Exercise 5:
-- Within each country, rank customers by total confirmed revenue.

-- 🧩 Exercise 6:
-- For each booking, show its previous and next booking_date
-- (use LAG and LEAD by customer_id).

-- 🧩 Exercise 7:
-- Deduplicate bookings keeping only the latest record per booking_id
-- (use ROW_NUMBER).

-- 🧩 Exercise 8:
-- Build a subquery that finds each customer's total confirmed revenue,
-- then select only those above 400 EUR.

-- 🧩 Exercise 9:
-- Compute average monthly revenue and compare each month's revenue
-- to the overall average (above or below average?).

-- 🧩 Exercise 10:
-- Create a final customer leaderboard:
--   customer_id, country, total_bookings, total_revenue,
--   revenue_rank (across all customers).


-- ===========================================================
-- ✅ LEVEL 3 SQL SOLUTIONS
-- ===========================================================

-- ✅ Solution 1
SELECT
    booking_id,
    customer_id,
    booking_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id) AS total_revenue_per_customer
FROM practice.bookings
ORDER BY customer_id, booking_id;

-- ✅ Solution 2
SELECT
    booking_id,
    customer_id,
    amount,
    ROUND(AVG(amount) OVER (PARTITION BY customer_id), 2) AS avg_amount_per_customer
FROM practice.bookings
ORDER BY customer_id, booking_id;

-- ✅ Solution 3
SELECT
    booking_id,
    booking_date,
    SUM(amount) OVER (ORDER BY booking_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        AS running_confirmed_revenue
FROM practice.bookings
WHERE status = 'confirmed'
ORDER BY booking_date;

-- ✅ Solution 4
SELECT
    customer_id,
    SUM(amount) AS total_confirmed_revenue,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
FROM practice.bookings
WHERE status = 'confirmed'
GROUP BY customer_id
ORDER BY revenue_rank;

-- ✅ Solution 5
SELECT
    c.country,
    b.customer_id,
    SUM(b.amount) AS total_confirmed_revenue,
    RANK() OVER (
        PARTITION BY c.country
        ORDER BY SUM(b.amount) DESC
    ) AS country_rank
FROM practice.bookings b
JOIN practice.customers c
  ON b.customer_id = c.customer_id
WHERE b.status = 'confirmed'
GROUP BY c.country, b.customer_id
ORDER BY c.country, country_rank;

-- ✅ Solution 6
SELECT
    customer_id,
    booking_id,
    booking_date,
    LAG(booking_date) OVER (PARTITION BY customer_id ORDER BY booking_date)  AS prev_booking_date,
    LEAD(booking_date) OVER (PARTITION BY customer_id ORDER BY booking_date) AS next_booking_date
FROM practice.bookings
ORDER BY customer_id, booking_date;

-- ✅ Solution 7
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY booking_id ORDER BY booking_date DESC) AS rn
    FROM practice.bookings
) t
WHERE rn = 1;

-- ✅ Solution 8
SELECT *
FROM (
    SELECT
        customer_id,
        SUM(amount) AS total_confirmed_revenue
    FROM practice.bookings
    WHERE status = 'confirmed'
    GROUP BY customer_id
) sub
WHERE total_confirmed_revenue > 400
ORDER BY total_confirmed_revenue DESC;

-- ✅ Solution 9
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', booking_date) AS month_start,
        SUM(amount) AS revenue
    FROM practice.bookings
    WHERE status = 'confirmed'
    GROUP BY 1
)
SELECT
    month_start,
    revenue,
    ROUND(AVG(revenue) OVER (), 2) AS avg_monthly_revenue,
    CASE
        WHEN revenue > AVG(revenue) OVER () THEN 'Above average'
        ELSE 'Below average'
    END AS comparison
FROM monthly
ORDER BY month_start;

-- ✅ Solution 10
SELECT
    b.customer_id,
    c.country,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    SUM(b.amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(b.amount) DESC) AS revenue_rank
FROM practice.bookings b
JOIN practice.customers c
  ON b.customer_id = c.customer_id
WHERE b.status = 'confirmed'
GROUP BY b.customer_id, c.country
ORDER BY revenue_rank;

-- ===========================================================
-- END OF LEVEL 3 SQL PRACTICE
-- ===========================================================
