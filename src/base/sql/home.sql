select
    v1.accounting_period
    ,v1.budget_total
    ,IFNULL(v2.achievement_total, 0) achievement_total
    ,IFNULL(v2.achievement_total, 0) - v1.budget_total diff_total
from
    (
        select 
            accounting_period
            ,sum(sales_budget.sales_budget) budget_total
        from sales_budget 
        where
            version = 1 
            group by accounting_period
    ) v1 left outer join (
        select 
            accounting_period
            ,sum(sales_achievement.amount_of_sales) achievement_total 
        from
            sales_achievement 
        group by
            accounting_period
    ) v2 on 
        v1.accounting_period = v2.accounting_period
order by
    v1.accounting_period
