-- Xom Data · How much of a customer's life is the first month
-- Problem: https://xomdata.com/practice/hard-ltv-004
-- Solved: 2026-11-20


with orders_info as (
SELECT order_id, customer_id, to_char(order_date::date, 'YYYY-mm') order_date, amount 
FROM orders
), first_month_revenue as (
    select *, row_number() over(partition by customer_id order by order_date asc) rk 
    from orders_info 
), first_month_revenue_info as (
    select order_date, sum (amount) as first_month_revenue
    from first_month_revenue
    group by order_date
), tmp as (
select customer_id, order_date, sum (amount) over(partition by customer_id) as total_amount, row_number() over(partition by customer_id order by order_date asc) rk 

from first_month_revenue

), tmp1 as (
select *
from tmp
where rk = 1
)
, lifetime_revenue_info as (
select order_date, sum(total_amount) lifetime_revenue
from tmp1
group by order_date
)

select a.order_date as cohort_month, first_month_revenue, lifetime_revenue, round ((first_month_revenue* 1.0 / lifetime_revenue) * 100,2) first_month_share_pct
from first_month_revenue_info a 
 join  lifetime_revenue_info b on a.order_date = b.order_date 
-- where round ((first_month_revenue* 1.0 / lifetime_revenue) * 100,2)  > 50
order by round ((first_month_revenue* 1.0 / lifetime_revenue) * 100,2)  asc
