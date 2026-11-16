-- Xom Data · Which channel brings in the most durable customers
-- Problem: https://xomdata.com/practice/hard-retention-009
-- Solved: 2026-11-16





with orders_per_customer as (
select ord.*, signup_date, channel, row_number() over(partition by ord.customer_id) rk
from orders ord 
left join customers cst 
    on ord.customer_id = cst.customer_id
), cohort_customers_info as (
select channel, count(distinct customer_id) cohort_customers
from orders_per_customer
group by channel 
), tmp as (
select *, lead(order_date) over(partition by customer_id) next_date
from orders_per_customer 
where rk <=2
), pre_result as (
select *
  ,(EXTRACT(YEAR FROM next_date::date) - EXTRACT(YEAR FROM order_date::date)) * 12 
  + (EXTRACT(MONTH FROM next_date::date) - EXTRACT(MONTH FROM order_date::date)) AS month_diff

from tmp
where rk = 1 and next_date is not null
), retained_info as (
select channel, 
sum (
    case 
        when month_diff =1
        then 1
        else 0
    end
) retained
from pre_result 
group by channel
)
select ci.channel, cohort_customers, coalesce(retained,0) as retained, round ((coalesce(retained,0)*1.0 / cohort_customers  ) *100,2)  retention_pct
from cohort_customers_info ci
left join retained_info ri
on ci.channel = ri.channel  
order by round ((coalesce(retained,0)*1.0 / cohort_customers  ) *100,2)  desc
