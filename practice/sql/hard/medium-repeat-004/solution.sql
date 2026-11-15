-- Xom Data · Closing a second order within a month
-- Problem: https://xomdata.com/practice/medium-repeat-004
-- Solved: 2026-11-15




with list_ordpercust as (
select *, row_number() over(partition by customer_id order by order_date asc) rk 
from orders
), order_list as (
select *, lag(order_date) over(partition by customer_id order by order_date) prev_order  
from list_ordpercust 
where rk <=2
), result as (
select customer_id, order_date as second_order_date, prev_order as first_order_date, order_date::date - prev_order::date as days_to_second
from order_list
where rk = 2
)
select customer_id, first_order_date, second_order_date, days_to_second
from result

where days_to_second <=30
order by first_order_date asc , customer_id asc
