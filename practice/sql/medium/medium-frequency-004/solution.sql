-- Xom Data · A Picture of Engagement Distribution
-- Problem: https://xomdata.com/practice/medium-frequency-004
-- Solved: 2026-11-23




with tmp as (
select customer_id, count (*)  as SL
from orders 
group by customer_id
), tmp1 as (
select *, 
case 
    when sl = 1 then '1 order'
    when sl = 2 then '2 orders'
    when sl >=3 then '3+ orders'

    end engagement_bucket
from tmp
)
select engagement_bucket, count (*) as customer_count
from tmp1 
group by engagement_bucket
order by engagement_bucket
-- select
--     sum (
--         case 
--             when sl = 1 then 1
--             else 0
--         end 
--     ) as one_order
--     , sum (
--         case 
--             when sl = 2 then 1
--             else 0
--         end 
--     ) as two_order 
--     , sum (
--         case 
--             when sl >2  then 1
--             else 0
--         end 
--     ) as over_order 
-- from tmp
