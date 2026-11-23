-- Xom Data · The Silence Between Two Consecutive Purchases
-- Problem: https://xomdata.com/practice/medium-gap-001
-- Solved: 2026-11-23


with order_info as (
select *, LAG(order_date) over(partition by customer_id order by order_date asc) prev_order 
from orders 

)

select customer_id, order_date, order_date::date  - prev_order::date as days_since_prev
from order_info
where prev_order is not null
