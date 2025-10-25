
-- 🧩 Exercise 0:
-- Select the today's date
select current_date;

-- 🧩 Exercise 1:
-- Select all confirmed bookings ordered by date (columns: booking_id, customer_id, booking_date, amount, status)

select booking_id, customer_id, booking_date, amount, status 
from bookings
where status  = 'confirmed'
order by booking_date;

-- 🧩 Exercise 2:
-- Find the total revenue from confirmed bookings (one number)

select
	sum(amount) as total_revenue
from bookings
where status = 'confirmed';

-- 🧩 Exercise 3:
-- Show total booking amount grouped by status (in two different rows)

select
	status,
	sum(amount) as total_revenue
from bookings
group by 1;

-- Now, do the same, but show in two different columns, one for each status.
select
	sum(case when status = 'confirmed' then amount else 0 end) as confirmed_total,
	sum(case when status = 'cancelled' then amount else 0 end) as cancelled_total
from bookings;

-- 🧩 Exercise 4:
-- Show monthly revenue for confirmed bookings
-- Hint: group by month (use EXTRACT and DATE_TRUNC and TO_CHAR)

select
	SUM(amount) as total_revenue,
	EXTRACT(MONTH FROM booking_date) as date_month
from bookings
where status = 'confirmed'
group by date_month;

select
	SUM(amount) as total_revenue,
	DATE_TRUNC('month', booking_date) as date_month
from bookings
where status = 'confirmed'
group by date_month;

select
	SUM(amount) as total_revenue,
	TO_CHAR(booking_date, 'YYYY-MM') as date_month
from bookings
where status = 'confirmed'
group by date_month;

-- Now, show the revenue from last calendar month before today
select
	SUM(amount) as total_revenue,
	EXTRACT(MONTH FROM booking_date) as date_month
from bookings
where status = 'confirmed'
	and EXTRACT(MONTH FROM booking_date) = EXTRACT(MONTH FROM current_date - interval '1 month')
group by date_month;

select
	SUM(amount) as total_revenue,
	DATE_TRUNC('month', booking_date) as date_month
from bookings
where status = 'confirmed'
	and DATE_TRUNC('month', booking_date) = DATE_TRUNC('month', current_date - interval '1 month')
group by date_month;

select
	SUM(amount) as total_revenue,
	TO_CHAR(booking_date, 'YYYY-MM') as date_month
from bookings
where status = 'confirmed'
	and TO_CHAR(booking_date, 'YYYY-MM') = TO_CHAR(current_date - interval '1 month', 'YYYY-MM')
group by date_month;


-- 🧩 Exercise 5:
-- Count how many distinct customers made bookings

select
	COUNT(DISTINCT customer_id) as unique_customers
from bookings;

-- 🧩 Exercise 6:
-- Find duplicated booking_id values
-- Show booking_id and how many times it appears

select 
	booking_id,
	count(*) as duplicated_booking_id
from bookings
group by 1;

-- Now, show only the duplicated booking_id, just one time
select 
	booking_id,
	count(*) as duplicated_booking_id
from bookings
group by 1
having count(*) > 1;

-- 🧩 Exercise 7:
-- For each month, show two columns:
--   - confirmed_revenue
--   - cancelled_amount
-- Use CASE WHEN to build these two columns

select
	sum(case when status = 'confirmed' then amount else 0 end) as confirmed_total,
	sum(case when status = 'cancelled' then amount else 0 end) as cancelled_total
from bookings;

-- 🧩 Exercise 8:
-- Join bookings with customers to show revenue per country
-- Only include confirmed bookings
-- Columns: country, total_bookings, total_revenue

select 
	c.country,
	COUNT(*) as total_bookings,
	SUM(b.amount) as total_revenue
from bookings b 
left join customers c on b.customer_id = c.customer_id
where status = 'confirmed'
group by country;

-- 🧩 Exercise 9:
-- Filter the previous result to keep only countries
-- where total confirmed revenue > 400

select 
	c.country,
	COUNT(*) as total_bookings,
	SUM(b.amount) as total_revenue
from bookings b 
left join customers c on b.customer_id = c.customer_id
where b.status = 'confirmed'
group by c.country
having SUM(b.amount) > 400;

-- 🧩 Exercise 10:
-- Build a small monthly performance report showing:
--   - year_month
--   - total_bookings
--   - unique_customers
--   - confirmed_revenue
--   - cancelled_revenue
--   - avg_amount (rounded to 2 decimals)
-- Order by month ascending

select 
	COUNT(*) as total_bookings,
	COUNT(DISTINCT c.customer_id) as unique_customers,
	TO_CHAR(dedup_b.booking_date, 'YYYY-MM') as year_month,
	ROUND(AVG(dedup_b.amount), 2) as avg_amount,
	SUM(CASE WHEN dedup_b.status = 'confirmed' THEN amount ELSE 0 END) AS confirmed_revenue,
    SUM(CASE WHEN dedup_b.status = 'cancelled' THEN amount ELSE 0 END) AS cancelled_revenue
from (
	-- remove duplicate rows in bookings
	select distinct booking_id, customer_id, booking_date, amount, status from bookings
	) as dedup_b
left join customers c on dedup_b.customer_id = c.customer_id
group by year_month
order by year_month ASC;