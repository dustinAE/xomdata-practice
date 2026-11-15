-- Xom Data · Active or stopped subscription
-- Problem: https://xomdata.com/practice/medium-churn-002
-- Solved: 2026-11-15




select sub_id, customer_id, 
case 
    when end_date::date  >= '2024-06-30'::date or end_date is null
        then 'active'
    else 
        'stopped'

end as status
from subscriptions
