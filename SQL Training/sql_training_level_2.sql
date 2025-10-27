-- ===========================================================
-- 🧠 LEVEL 3 SQL PRACTICE — WINDOW FUNCTIONS & SUBQUERIES
-- ===========================================================
-- Tables:
--   practice.bookings (with potential duplicates due to ingestion)
--   practice.bookings_dedup
--   practice.customers
-- ===========================================================


-- Make sure to select the 'practice@sandbox_db' schema in the dropdown menu at the top of DBeaver's IDE


-- 🧩 Exercise 1:
-- Business question: "How does each individual booking compare to that customer’s total spending?"
-- For each booking, show:
--   booking_id, customer_id, booking_date, amount,
--   and total revenue per customer (using a window function).
--
-- Goal:
--   Understand each booking in the context of the customer's total value.
--   This allows analysts to identify high-value customers or outlier bookings.


-- 🧩 Exercise 2:
-- Business question: "How does each booking compare to that customer’s usual spending behavior?"
-- For each booking, show:
--   booking_id, customer_id, amount,
--   and the average booking amount for that customer.
--
-- Goal:
--   Evaluate whether a booking is above or below a customer’s average.
--   Useful for detecting high-ticket purchases or behavioral changes.


-- 🧩 Exercise 3:
-- Business question: "How is our confirmed revenue growing as new bookings come in?"
-- Add a running total of confirmed revenue ordered by booking_date.
--
-- Goal:
--   Track cumulative revenue over time to monitor growth trends.
--   Useful for dashboards showing revenue progression month-to-date or year-to-date.


-- 🧩 Exercise 4:
-- Business question: "Who are our top customers by total confirmed revenue?"
-- Rank all customers by total confirmed revenue (1 = highest).
-- (use ROW_NUMBER or RANK)
--
-- Goal:
--   Identify the most valuable customers overall.
--   Ranking helps target retention or upsell campaigns.


-- 🧩 Exercise 5:
-- Business question: "Who are our top customers by revenue in each country?"
-- Within each country, rank customers by total confirmed revenue.
--
-- Goal:
--   Identify top customers by country.
--   This helps local marketing teams focus on high-value clients in their region.


-- 🧩 Exercise 6:
-- Business question: "How frequently do customers book?"
-- For each booking, show its previous and next booking_date (by customer_id).
-- (use LAG and LEAD by customer_id).
--
-- Goal:
--   Calculate booking frequency or inactivity periods between bookings.


-- 🧩 Exercise 7:
-- Business question: "How do we ensure we only keep the latest version of each booking?"
-- Deduplicate bookings, keeping only the most recent record per booking_id.
-- (use ROW_NUMBER)
--
-- Goal:
--   Clean historical data where the same booking_id may appear multiple times due to ETL reloads.


-- 🧩 Exercise 8:
-- Business question: "Which customers are high-value (total confirmed revenue > 400 EUR)?"
-- Build a subquery that finds each customer's total confirmed revenue,
-- then filter to only those above 400 EUR.
--
-- Goal:
--   Identify VIP customers for potential loyalty or retention programs.


-- 🧩 Exercise 9:
-- Business question: "Is each month performing above or below our average revenue?"
-- Compute average monthly revenue and compare each month's revenue to the overall average using window functions.
--
-- Goal:
--   Detect underperforming months for performance reviews or seasonality analysis.


-- 🧩 Exercise 10:
-- Business question: "Who are our top customers globally?"
-- Create a customer leaderboard with:
--   customer_id, country, total_bookings, total_revenue, revenue_rank (across all customers)
--
-- Goal:
--   Produce a ranked leaderboard of all customers by revenue, to feed dashboards or CRM enrichment.


-- 🧩 Exercise 11:
-- Business question: "Who are our top customers within each country?"
-- What do you need to add to the exercise 10 to reach the answer?
--
-- Goal:
--   Rank customers by revenue within their respective countries.
