SELECT
    A.accounting_period
    ,A.accounting_month
    ,A.sales_budget_total
    ,IFNULL(B.amount_of_sales_total, 0) amount_of_sales_total
    ,(IFNULL(B.amount_of_sales_total, 0) - A.sales_budget_total) difference_total

FROM
    (
        SELECT 
            accounting_period
            ,accounting_month
            ,sum(sales_budget) sales_budget_total
        FROM
            sales_budget
        GROUP BY
            accounting_period
            ,accounting_month
    ) A

    LEFT JOIN

    (
        SELECT
            accounting_period
            ,accounting_month
            ,sum(amount_of_sales) amount_of_sales_total
        FROM
            sales_achievement
        GROUP BY
            accounting_period
            ,accounting_month
    ) B

    ON
        A.accounting_period = B.accounting_period AND
        A.accounting_month = B.accounting_month
    WHERE
        A.accounting_period = 43;