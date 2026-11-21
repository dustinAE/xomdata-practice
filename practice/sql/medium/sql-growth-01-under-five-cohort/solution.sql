-- Xom Data · Identify children under five
-- Problem: https://xomdata.com/practice/sql-growth-01-under-five-cohort
-- Solved: 2026-11-20



with tmp as (
select visit_id, patient_id, 

DATE_PART('year', admission_at) - DATE_PART('year', birth_date)
    - CASE
        WHEN (DATE_PART('month', admission_at), DATE_PART('day', admission_at))
           < (DATE_PART('month', birth_date), DATE_PART('day', birth_date))
        THEN 1
        ELSE 0
      END AS age_years, birth_date, admission_at
from medical_visits
where admission_at::date >= birth_date::date and   birth_date IS NOT NULL
      AND admission_at IS NOT NULL
      AND admission_at::date >= birth_date
AND admission_at::date < (birth_date + INTERVAL '5 years')::date

)
select visit_id, patient_id, admission_at::date - birth_date::date as age_days
from tmp 
where age_years <5
order by visit_id  asc
