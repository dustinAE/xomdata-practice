-- Xom Data · This invoice's share of the client's spend
-- Problem: https://xomdata.com/practice/medium-winjoin-005
-- Solved: 2026-11-21

-- Write your SQL here



with tmp as (
select client_name, invoice_code, amount, sum(amount) over(partition by client_id) total_amount
from invoices i
left join clients ci 
    on i.client_id = ci.id 
)
select client_name, invoice_code, amount, round(amount * 1.0 /total_amount * 100,2) pct_of_client
from tmp
order by   client_name asc, round(amount * 1.0 /total_amount * 100,2) desc, invoice_code asc
