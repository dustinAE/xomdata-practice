-- Xom Data · Top 3 campaigns by month-over-month growth
-- Problem: https://xomdata.com/practice/nightmare-pipeline-001
-- Solved: 2026-11-26



with campign_info as (
select campaign_id, to_char(spend_date::Date, 'YYYY-mm') as month, max (amount) as total_spend
from campaign_spend
group by campaign_id, to_char(spend_date::Date, 'YYYY-mm') 
), tmp as (
select *, lag(total_spend) over(partition by campaign_id order by month asc) pre_total_spend
from campign_info
order by campaign_id
), tmp1 as (
select *--, (coalesce(total_spend,0)* 1.0  -  coalesce(pre_total_spend,0)) / coalesce(pre_total_spend,1) * 100
, case
    when coalesce(pre_total_spend,0) =0 
        then NULL
    when coalesce(pre_total_spend,0) !=0 
        then round ((coalesce(total_spend,0)* 1.0  -  coalesce(pre_total_spend,0)) / coalesce(pre_total_spend,1) * 100,2) 
end as  growth_pct
from tmp 
), tmp2 as (
select *, dense_rank () over(partition by month order by growth_pct desc, campaign_id asc) as rank_in_month
from tmp1
where growth_pct is not null 
)
select month, campaign_id, total_spend, growth_pct, rank_in_month
from tmp2
where  rank_in_month <=3 
order by month asc, rank_in_month asc
