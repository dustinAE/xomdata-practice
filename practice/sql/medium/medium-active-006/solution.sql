-- Xom Data · Head-to-head customer count across quarters
-- Problem: https://xomdata.com/practice/medium-active-006
-- Solved: 2026-11-23



-- calculate Q1
with q1 as (
    select concat(to_char(order_date::date,'YYYY'),'-','Q1') quarter, count(distinct  customer_id) active_customers
from orders
where to_char(order_date::date, 'mm') in ('01','02','03')
group by concat(to_char(order_date::date,'YYYY'),'-','Q1')
),
q2 as (
select concat(to_char(order_date::date,'YYYY'),'-','Q2') quarter, count(distinct  customer_id) active_customers
from orders
where to_char(order_date::date, 'mm') in ('04','05','06')
group by concat(to_char(order_date::date,'YYYY'),'-','Q2')
),
q3 as (
select concat(to_char(order_date::date,'YYYY'),'-','Q3') quarter, count(distinct  customer_id) active_customers
from orders
where to_char(order_date::date, 'mm') in ('07','08','09')
group by concat(to_char(order_date::date,'YYYY'),'-','Q3')
),
q4 as (
select concat(to_char(order_date::date,'YYYY'),'-','Q4') quarter, count(distinct  customer_id) active_customers
from orders
where to_char(order_date::date, 'mm') in('10','11','12') 
group by concat(to_char(order_date::date,'YYYY'),'-','Q4')
), tmp as (
select *
from q1
union all 
select *
from q2
union all 
select *
from q3
union all 
select *
from q4
)
select *, active_customers - lag(active_customers) over(order by  quarter asc) change_vs_prev
from tmp
