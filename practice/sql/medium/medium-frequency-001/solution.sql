-- Xom Data · Customers Active Over the Past Half Year
-- Problem: https://xomdata.com/practice/medium-frequency-001
-- Solved: 2026-11-21


with order_date_info as (
select *
from orders 
where order_date::date >= '2024-01-01'::date and order_date::date <= '2024-06-30'::date
)
select customer_id, count (*) order_count
from order_date_info
group by customer_id
order by count(*) desc, customer_id asc
