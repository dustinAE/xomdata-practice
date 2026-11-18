-- Xom Data · Three raw metrics per customer profile
-- Problem: https://xomdata.com/practice/medium-recency-006
-- Solved: 2026-11-18



with pre_orders as (
select *,  row_number () over(partition by customer_id order by order_date desc) rk
from orders 
), days_silent as (
select customer_id, '2024-06-30'::date - order_date::date  as days_silent
from pre_orders
where rk = 1
), order_sum_count as (
select customer_id, count (order_id) order_count, sum (amount) as total_spent
from pre_orders
group by customer_id 
)
select a.customer_id, a.days_silent, b.order_count, b.total_spent
from days_silent a 
left join order_sum_count b 
on a.customer_id =b.customer_id
order by customer_id asc
