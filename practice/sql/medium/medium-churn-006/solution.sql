-- Xom Data · A snapshot of the customer base at a point in time
-- Problem: https://xomdata.com/practice/medium-churn-006
-- Solved: 2026-11-21



with order_info as (
select *, row_number() over(partition by customer_id order by order_date asc) rk , to_char(order_date::date, 'YYYY-mm') month_year,
'2024-06-30'::date - order_date::date as count_date,
row_number() over(partition by customer_id order by order_date desc) rk_churned
from orders
), active_info as (
    select ''
    from order_info
    where rk = 1 and month_year = '2024-06'
)
, tmp as (
select *
,
case 
    when rk = 1 and month_year = '2024-06' then 'new'
    when rk_churned = 1 and  count_date >90
        then 'churned'
    else 'active'
             
end checkk
from order_info
), tmp1 as (
select distinct customer_id, checkk
from tmp
)
select checkk as segment, count(*) customer_count
-- sum(
--     case 
--         when checkk = 'active'
--             then 1
--     end 
-- )
from tmp1
group by checkk
