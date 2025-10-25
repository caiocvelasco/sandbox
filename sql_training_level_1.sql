-- ===========================================================
-- 🧠 LEVEL 1 SQL PRACTICE — EXERCISES
-- ===========================================================
-- Database: sandbox_db
-- Schema:   practice
-- Tables:   practice.bookings , practice.customers
-- ===========================================================

-- ===========================================================
-- 🧠 LEVEL 1 SQL SUMMARY — MAIN POINTS
-- ===========================================================

-- CORE
-- SELECT, WHERE, ORDER BY, AS

-- AGGREGATION
-- SUM(), COUNT(), AVG(), MIN(), MAX()
-- GROUP BY, HAVING

-- DISTINCT / DUPLICATES
-- DISTINCT, COUNT(DISTINCT col)
-- GROUP BY ... HAVING COUNT(*) > 1
-- SELECT DISTINCT ... FROM table

-- CONDITIONALS
-- CASE WHEN ... THEN ... ELSE ... END

-- DATES
-- DATE_TRUNC('month', date)
-- TO_CHAR(date, 'YYYY-MM')
-- EXTRACT(MONTH FROM date)

-- JOINS
-- INNER JOIN ... ON key
-- JOIN multiple tables for enrichment

-- REPORT PATTERNS
-- Group by month
-- COUNT(DISTINCT ...)
-- Conditional SUMs
-- ROUND(AVG(...),2)
-- ORDER BY timeline
-- ===========================================================

-- 🧩 Exercise 1:
-- Select all confirmed bookings ordered by date (columns: booking_id, customer_id, booking_date, amount, status)

-- 🧩 Exercise 2:
-- Find the total revenue from confirmed bookings (one number)

-- 🧩 Exercise 3:
-- Show total booking amount grouped by status
-- Now, do the same, but show in two different columns, one for each status.

-- 🧩 Exercise 4:
-- Show monthly revenue for confirmed bookings
-- Hint: group by month (use DATE_TRUNC or TO_CHAR)

-- 🧩 Exercise 5:
-- Count how many distinct customers made bookings

-- 🧩 Exercise 6:
-- Find duplicated booking_id values
-- Show booking_id and how many times it appears

-- 🧩 Exercise 7:
-- For each month, show two columns:
--   - confirmed_revenue
--   - cancelled_amount
-- Use CASE WHEN to build these two columns

-- 🧩 Exercise 8:
-- Join bookings with customers to show revenue per country
-- Only include confirmed bookings
-- Columns: country, total_bookings, total_revenue

-- 🧩 Exercise 9:
-- Filter the previous result to keep only countries
-- where total confirmed revenue > 400

-- 🧩 Exercise 10:
-- Build a small monthly performance report showing:
--   - year_month
--   - total_bookings
--   - unique_customers
--   - confirmed_revenue
--   - cancelled_revenue
--   - avg_amount (rounded to 2 decimals)
-- Order by month ascending