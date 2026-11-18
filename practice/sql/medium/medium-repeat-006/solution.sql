-- Xom Data · Diligent customers across all four quarters
-- Problem: https://xomdata.com/practice/medium-repeat-006
-- Solved: 2026-11-18

--to_char(order_date::Date, 'mm')
with quater_col_info as (
select  customer_id ,
case 
    when to_char(order_date::Date, 'mm') in ('01','02','03')
        then 'Q1'
     when to_char(order_date::Date, 'mm') in ('04','05','06')
        then 'Q2'
     when to_char(order_date::Date, 'mm') in ('07','08','09')
        then 'Q3'
     when to_char(order_date::Date, 'mm') in ('10','11','12')
        then 'Q4'
end as quater_col 
from orders 
where to_char(order_date::Date, 'YYYY') = '2024'
)
select customer_id, count( *) orders_2024
from quater_col_info
group by customer_id
having count(distinct quater_col) >=4
