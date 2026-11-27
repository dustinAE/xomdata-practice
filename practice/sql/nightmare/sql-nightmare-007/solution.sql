-- Xom Data · Inventory value using FIFO
-- Problem: https://xomdata.com/practice/sql-nightmare-007
-- Solved: 2026-11-27



with info_inventory as (
select i.*,  a.demand_qty
from inventory i
cross join  sales_demand a
where batch_date <= (select demand_date from sales_demand)
), tmp as (
select *, --demand_qty - sum (quantity) over(order by batch_date asc) conlai
case 
    when demand_qty > (select quantity from info_inventory where batch_id = 1)
        then demand_qty - sum (quantity) over(order by batch_date asc) 
    else sum (quantity) over(order by batch_date asc)  - demand_qty
end  as conlai

from info_inventory
), tmp1 as (
select *, coalesce(lag(conlai) over(order by batch_date asc),0) sodu
from tmp 
), re_result1 as (
select *,
case 
    when conlai <= 0 and sodu >= 0  
        THEN quantity - sodu
end remaining_qty
from tmp1 

), result1 as (
    select *
    from re_result1
    where remaining_qty is not null
)
, pre_result2 as (
select *
from tmp1 where batch_id  > coalesce((select batch_id from result1),0)
), result2 as (
select  batch_id, batch_date,
case 
    when conlai < 0
        then quantity
    else quantity - demand_qty 
end as remaining_qty_check ,unit_cost, quantity as quantity_original
from pre_result2 
), result2_final as (

select batch_id, batch_date, 
case 
    when remaining_qty_check >=0 then  remaining_qty_check

        else  quantity_original
end remaining_qty, unit_cost
from result2
)
select batch_id, batch_date, remaining_qty, unit_cost, remaining_qty* unit_cost as remaining_value
from result1
union all 
select batch_id, batch_date, remaining_qty , unit_cost, remaining_qty* unit_cost as remaining_value
from result2_final
