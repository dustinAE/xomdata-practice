-- Xom Data · How long does it take to win a customer back
-- Problem: https://xomdata.com/practice/hard-winback-004
-- Solved: 2026-11-18




with first_purchase as (
    select ord.*, channel, order_date::date - (lag(order_date) over(partition by ord.customer_id order by order_date asc))::date  count_date_comeback 
    ,row_number() over(partition by ord.customer_id order by order_date asc) rk_customers
    from orders ord 
    left join customers cst 
        on ord.customer_id =   cst.customer_id 
), result as (
select 
channel, 
sum (
    case when rk_customers >1 and count_date_comeback >= 60 then 1
    else 0
    end 
) winback_count,
sum (
    case 
        when count_date_comeback >= 60
            then count_date_comeback
        else 0
    end 
) as date_comeback
from first_purchase
group by channel


)
select channel, coalesce(winback_count,0) as winback_count, coalesce(round (coalesce(date_comeback,0) * 1.0 / coalesce(winback_count,0) ,2),0) avg_absence_days
from result 
where winback_count > 0
order by  coalesce(round (coalesce(date_comeback,0) * 1.0 / coalesce(winback_count,0) ,2),0)  asc, channel asc
