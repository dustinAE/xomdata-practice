-- Xom Data · Each customer's starting quarter
-- Problem: https://xomdata.com/practice/medium-cohort-005
-- Solved: 2026-11-21



with info_orders as (
select *, row_number() over(partition by customer_id order by order_date asc) rk, to_char(order_date::date, 'YYYY') year_info, to_char(order_date::date, 'mm') month_info
from orders
), result as (
select *, 
case 
    when month_info::integer between 1 and 3
        then 'Q1'
    when month_info::integer between 4 and 6
        then 'Q2' 
    when month_info::integer between 7 and 9
        then 'Q3'
    when month_info::integer between 10 and 12
        then 'Q4'  
end as quarter
from info_orders
where rk = 1
)
select customer_id, concat(year_info,'-',quarter) first_quarter
from result
