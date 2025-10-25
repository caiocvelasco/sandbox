-- 🧩 Exercise 1:
-- For each booking, show:
--   booking_id, customer_id, booking_date, amount,
--   and total revenue per customer (use a window function).
select * from bookings_dedup;

select
	booking_id,
	customer_id,
	booking_date,
	amount,
	SUM(amount) over (partition by customer_id) as total_revenue_per_customer
from bookings_dedup;

-- 🧩 Exercise 2:
-- For each booking, show:
--   booking_id, customer_id, amount,
--   and the average booking amount for that customer.

select
	booking_id,
	customer_id,
	amount,
	AVG(amount) over (partition by customer_id) avg_amount_per_customer
from bookings_dedup;

-- 🧩 Exercise 3:
-- Add a running total of confirmed revenue ordered by booking_date.

-- SQL goes row by row, following the order of booking_date.
-- For each row, it redefines the window frame size:
----starts in Row 1 → sum only the amount itself
----go to Row 2 → sum itself + all before it in this new window frame with 2 rows
----go to Row 3 → itself + all before it, and so on

select
	booking_id,
	booking_date,
	amount,	
	sum(amount) over (										-- window function begins and go row by row redefining the size of the window where the aggregated function is applied
		order by booking_date								-- it orders the rows within the window frame
		rows between 										-- defines the window frame: which rows are included for each calculation (in each row, there will be a new window frame)
		unbounded preceding 								-- frame starts from the very first row in this ordered set
		and current row										-- frame ends at the current row (inclusive)
	) as running_total
from bookings_dedup
where status = 'confirmed'
order by booking_date ASC;

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