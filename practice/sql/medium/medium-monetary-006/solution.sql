-- Xom Data · Spend per Active Month
-- Problem: https://xomdata.com/practice/medium-monetary-006
-- Solved: 2026-11-21


with orders as (
    select order_id, customer_id, to_char(order_date::date,'YYYY-mm') date , amount
    from orders
)
, tmp as(


select customer_id, sum(amount) as total_spent, count(distinct date) as active_months
from orders
group by customer_id

)


 select customer_id, total_spent, active_months, round(total_spent* 1.0 / active_months,2)  as spend_per_month
from tmp 
order by round(total_spent* 1.0 / active_months,2)  desc
