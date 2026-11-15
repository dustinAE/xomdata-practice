-- Xom Data · Month-over-month momentum in customer count
-- Problem: https://xomdata.com/practice/medium-active-005
-- Solved: 2026-11-15



with pre_result as (
select to_Char(order_date::date, 'YYYY-mm') as month, count(distinct customer_id)as  active_customers
from orders
group by to_Char(order_date::date, 'YYYY-mm') 
), result as (
select *, lag(active_customers) over() as pre_ --, active_customers - COALESCE(lag(active_customers) over(),0)
from pre_result 
)
select month, active_customers, 
case when pre_ is null 
    then null
    else active_customers - pre_
end as change_vs_prev
from result 
order by month
