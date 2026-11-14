-- Xom Data · Revenue walking out the door with old customers
-- Problem: https://xomdata.com/practice/medium-churn-007
-- Solved: 2026-11-14







with last_order_date as (
select *, row_number() over(partition by customer_id order by order_date desc) last_order_date
from orders 
), 
revenue_customer as (
select customer_id, sum (amount) as lost_revenue 
from orders 
group by customer_id
)
select ld.customer_id, order_date as last_order_date, rc.lost_revenue --*, '2024-06-30'::date - order_date::date as count_days
from last_order_date ld
left join revenue_customer rc on ld.customer_id =  rc.customer_id
where last_order_date = 1 and '2024-06-30'::date - order_date::date >90
order by rc.lost_revenue desc, customer_id asc
