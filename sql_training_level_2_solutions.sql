-- Make sure to select the 'practice@sandbox_db' schema about in the dropdown menu in the top bar of Dbeaver's IDE

-- 🧩 Exercise 1:
-- Business question: "How does each individual booking compare to that customer’s total spending?"
-- For each booking, show:
--   booking_id, customer_id, booking_date, amount,
--   and total revenue per customer (using a window function).
--
-- Goal:
--   Understand each booking in the context of the customer's total value.
--   This allows analysts to identify high-value customers or outlier bookings.

-- Here, you want to “Compute an aggregate, but keep all original rows.”
-- You do this using the help of a window function that will operate only for the aggregation per customer

select
	booking_id,
	customer_id,
	booking_date,
	amount,
	SUM(amount) over (partition by customer_id) as total_revenue_per_customer
from bookings_dedup;

-- 🧩 Exercise 2:
-- Business question: "How does each booking compare to that customer’s usual spending behavior?"
-- For each booking, show:
--   booking_id, customer_id, amount,
--   and the average booking amount for that customer.
--
-- Goal:
--   Evaluate whether a booking is above or below a customer’s average.
--   Useful for detecting high-ticket purchases or behavioral changes.

-- Here, you want to “Compute an aggregate, but keep all original rows.”
-- You do this using the help of a window function that will operate only for the aggregation per customer

select
	booking_id,
	customer_id,
	amount,
	AVG(amount) over (partition by customer_id) avg_amount_per_customer
from bookings_dedup;

-- 🧩 Exercise 3:
-- Business question: "How is our confirmed revenue growing as new bookings come in?"
-- Add a running total of confirmed revenue ordered by booking_date.
--
-- Goal:
--   Track cumulative revenue over time to monitor growth trends.
--   Useful for dashboards showing revenue progression month-to-date or year-to-date.

-- Note about Window Function:
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
-- Business question: "Who are our top customers by total confirmed revenue?"
-- Rank all customers by total confirmed revenue (1 = highest).
-- (use ROW_NUMBER or RANK)
--
-- Goal:
--   Identify the most valuable customers overall.
--   Ranking helps target retention or upsell campaigns.

-- Version using RANK()
select
    customer_id,
    sum(amount) as total_confirmed_revenue,                 -- total confirmed revenue per customer
    rank() over (order by sum(amount) desc) as rank         -- assign a rank to the grouped result set based on total revenue (1 = highest)
from bookings_dedup
where status = 'confirmed'                                  -- only consider confirmed bookings
group by customer_id;                                       -- one row per customer (aggregates multiple bookings)

-- Version using ROW_NUMBER() — assigns unique rank even for ties
select
    customer_id,
    sum(amount) as total_confirmed_revenue,                 -- total confirmed revenue per customer
    ROW_NUMBER() over (order by sum(amount) desc) as rank         -- assign a rank to the grouped result set based on total revenue (1 = highest)
from bookings_dedup
where status = 'confirmed'                                  -- only consider confirmed bookings
group by customer_id;                                       -- one row per customer (aggregates multiple bookings)

-- 🧩 Exercise 5:
-- Business question: "Who are our top customers by revenue in each country?"
-- Within each country, rank customers by total confirmed revenue.
--
-- Goal:
--   Identify top customers by country.
--   This helps local marketing teams focus on high-value clients in their region.

select
    c.country,
    bd.customer_id,
    sum(bd.amount) as total_confirmed_revenue,                 							-- total confirmed revenue per customer
    rank() over (partition by c.country order by sum(bd.amount) desc) as country_rank   -- assign a rank to the grouped result set based on total revenue (1 = highest)
from bookings_dedup bd
left join customers as c on bd.customer_id = c.customer_id
where status = 'confirmed'                                  
group by  c.country, bd.customer_id;                                       

-- 🧩 Exercise 6:
-- Business question: "How frequently do customers book?"
-- For each booking, show its previous and next booking_date (by customer_id).
-- (use LAG and LEAD by customer_id).
--
-- Goal:
--   Calculate booking frequency or inactivity periods between bookings.

select
    customer_id,                                          -- identifies which customer made the booking
    booking_id,                                           -- unique ID of each booking
    booking_date,                                         -- date when the booking was made

    lag(booking_date) over (                              -- LAG: looks backward within the window
        partition by customer_id                          -- restart the window for each customer 
        order by booking_date                             -- define chronological order of bookings
    ) as previous_booking_date,                           -- shows the date of the previous booking by the same customer

    lead(booking_date) over (                             -- LEAD: looks forward within the window
        partition by customer_id                          -- restart the window for each customer
        order by booking_date                             -- define chronological order of bookings
    ) as next_booking_date                                -- shows the date of the next booking by the same customer

from bookings_dedup;                                      -- base table containing all booking records


-- 🧩 Exercise 7:
-- Business question: "How do we ensure we only keep the latest version of each booking?"
-- Deduplicate bookings, keeping only the most recent record per booking_id.
-- (use ROW_NUMBER)
--
-- Goal:
--   Clean historical data where the same booking_id may appear multiple times due to ETL reloads.

-- First, notice that we have a duplicate in bookings due to a problem runinng the ETL two time in the same ingestion_day
-- booking_id = 4 refers to the the duplicated row

select 
	*,
	count(*) duplicates_count
from bookings
group by 1, 2, 3, 4, 5, 6
having count(*) > 1;

-- Now, let's make sure that our code don't account for this duplicate
select
	*
from (
	select 
		*,
		ROW_NUMBER() OVER(partition by booking_id order by ingestion_date DESC) as latest_record
	from bookings
	) as rn
where latest_record = 1;

-- 🧩 Exercise 8:
-- Business question: "Which customers are high-value (total confirmed revenue > 400 EUR)?"
-- Build a subquery that finds each customer's total confirmed revenue,
-- then filter to only those above 400 EUR.
--
-- Goal:
--   Identify VIP customers for potential loyalty or retention programs.

select
	customer_id
from (
	select
		customer_id,
		sum(amount) as total_confirmed_revenue
	from bookings_dedup
	where status = 'confirmed'
	group by customer_id
	)
where total_confirmed_revenue > 400;


-- 🧩 Exercise 9:
-- Business question: "Is each month performing above or below our average revenue?"
-- Compute average monthly revenue and compare each month's revenue to the overall average using window functions.
--
-- Goal:
--   Detect underperforming months for performance reviews or seasonality analysis.

-- First, let's calculate the overall avg just so that we know it.
select
	avg(amount) as overall_avg	
from bookings_dedup
where status = 'confirmed';

-- Now, let's calculate the revenue per month (the total sum of this is the same as the total revenue above)
select
	DATE_TRUNC('month', booking_date) as date_month,
	SUM(amount) as confirmed_revenue_per_month,
	(SELECT AVG(amount)
     FROM bookings_dedup
     WHERE status = 'confirmed') AS overall_avg
from bookings_dedup
where status = 'confirmed'
group by date_month;


-- 🧩 Exercise 10:
-- Business question: "Who are our top customers globally?"
-- Create a customer leaderboard with:
--   customer_id, country, total_bookings, total_revenue, revenue_rank (across all customers)
--
-- Goal:
--   Produce a ranked leaderboard of all customers by revenue, to feed dashboards or CRM enrichment.

select
	bd.customer_id,
	c.country,
	count(DISTINCT bd.booking_id) as total_bookings,
	sum(bd.amount) as total_revenue,
	RANK() OVER(order by sum(bd.amount) DESC) as revenue_rank
from bookings_dedup as bd
left join customers as c on bd.customer_id = c.customer_id
where bd.status = 'confirmed'
group by bd.customer_id, c.country;

-- 🧩 Exercise 11:
-- Business question: "Who are our top customers within each country?"
-- What do you need to add to the exercise 10 to reach the answer?

-- We need to add "partition by c.country" in the OVER() from RANK()

select
	bd.customer_id,
	c.country,
	count(DISTINCT bd.booking_id) as total_bookings,
	sum(bd.amount) as total_revenue,
	RANK() OVER(partition by c.country order by sum(bd.amount) DESC) as revenue_rank
from bookings_dedup as bd
left join customers as c on bd.customer_id = c.customer_id
where bd.status = 'confirmed'
group by bd.customer_id, c.country;