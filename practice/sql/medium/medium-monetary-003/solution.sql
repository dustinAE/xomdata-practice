-- Xom Data · Q2 Spending Ledger, Including the Silent Ones
-- Problem: https://xomdata.com/practice/medium-monetary-003
-- Solved: 2026-11-23




with customer_order as (
select cst.customer_id, customer_name, signup_date, channel, order_id, order_date, amount
from customers cst
left join orders ord 
on cst.customer_id = ord.customer_id 
-- where order_date between '2024-04-01' and '2024-06-30' or order_date is null

)
-- select customer_id, customer_name, sum(amount) as q2_spent
-- from customer_order
-- group by customer_id, customer_name
, customer_info as (select distinct customer_id, customer_name
from customer_order
), amount_customer as (
select customer_id, sum(amount) as q2_spent
from customer_order
where order_date between '2024-04-01' and '2024-06-30' 
group by customer_id, customer_name
)
select ci.customer_id, ci.customer_name, coalesce(q2_spent,0) as q2_spent 
from customer_info ci
left join amount_customer ac on ci.customer_id = ac.customer_id
order by coalesce(q2_spent,0)  desc, customer_id  asc
