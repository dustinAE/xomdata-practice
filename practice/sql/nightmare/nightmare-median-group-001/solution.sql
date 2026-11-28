-- Xom Data · Median department salary
-- Problem: https://xomdata.com/practice/nightmare-median-group-001
-- Solved: 2026-11-28







SELECT  department,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees
group by department
