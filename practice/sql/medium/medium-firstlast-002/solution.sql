-- Xom Data · Each Channel's Most Recent Face
-- Problem: https://xomdata.com/practice/medium-firstlast-002
-- Solved: 2026-11-15


with tmp as (
select ord.*, row_number() over(partition by channel order by order_date desc, ord.customer_id asc) rk, channel
from orders ord 
left join customers cst 
on ord.customer_id = cst.customer_id
)
select channel, customer_id, order_date as last_order_date
from tmp 
where rk = 1
order by channel
