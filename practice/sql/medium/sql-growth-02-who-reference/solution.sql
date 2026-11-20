-- Xom Data · Match WHO weight references
-- Problem: https://xomdata.com/practice/sql-growth-02-who-reference
-- Solved: 2026-11-19




select ev.visit_id, ev.age_days, ev.sex_code, ev.weight_kg,
l, m,s,sd_neg_3,sd_neg_2, sd_pos_2, sd_pos_3
from eligible_visits ev
left join who_weight_for_age_daily wd 
    on ev.sex_code = wd.sex_code and ev.age_days = wd.age_days 

ORDER BY VISIT_ID
