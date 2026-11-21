-- Xom Data · The yellow warning zone before losing a customer
-- Problem: https://xomdata.com/practice/medium-churn-005
-- Solved: 2026-11-21




with orders_info as (
select *, row_number() over(partition by customer_id order by order_date desc) rk  
from orders
), tmp as (
select customer_id, order_date as last_order_date, '2024-06-30'::date - order_date::date days_silent
from orders_info
where rk = 1
)
select *
from tmp 
where   days_silent >= 60 and days_silent <= 89
order by days_silent desc, customer_id asc
