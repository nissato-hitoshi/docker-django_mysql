SELECT
    C.accounting_period,
    C.sales_department,
    C.classification,
    C.sales_representative,
    C.supervising_department,
    C.client_name,
    C.project_name,
    C.operator,
    C.accounting_month,
    C.accuracy,
    IFNULL(B.sales_budget_total,0) - IFNULL(A.sales_budget_total,0) diff
from(
        SELECT
            accounting_period,
            sales_department,
            classification,
            sales_representative,
            supervising_department,
            client_name,
            project_name,
            operator,
            accounting_month,
            accuracy
        FROM
            sales_budget
        WHERE
            accounting_period = 43
        GROUP BY
            accounting_period,
            sales_department,
            classification,
            sales_representative,
            supervising_department,
            client_name,
            project_name,
            operator,
            accounting_month,
            accuracy
    ) C
    LEFT JOIN(
        SELECT
            accounting_period,
            sales_department,
            classification,
            sales_representative,
            supervising_department,
            client_name,
            project_name,
            operator,
            accounting_month,
            accuracy,
            SUM(sales_budget) sales_budget_total
        FROM
            sales_budget
        WHERE
            accounting_period = 43
            AND version = 1
        GROUP BY
            accounting_period,
            sales_department,
            classification,
            sales_representative,
            supervising_department,
            client_name,
            project_name,
            operator,
            accounting_month,
            accuracy
    ) A ON C.accounting_period = A.accounting_period
    AND C.sales_department = A.sales_department
    AND C.classification = A.classification
    AND C.sales_representative = A.sales_representative
    AND C.supervising_department = A.supervising_department
    AND C.client_name = A.client_name
    AND C.project_name = A.project_name
    AND C.operator = A.operator
    AND C.accounting_month = A.accounting_month
    AND C.accuracy = A.accuracy
    LEFT JOIN(
        SELECT
            accounting_period,
            sales_department,
            classification,
            sales_representative,
            supervising_department,
            client_name,
            project_name,
            operator,
            accounting_month,
            accuracy,
            SUM(sales_budget) sales_budget_total
        FROM
            sales_budget
        WHERE
            accounting_period = 43
            AND version = (
                SELECT
                    MAX(version)
                FROM
                    sales_budget
            )
        GROUP BY
            accounting_period,
            sales_department,
            classification,
            sales_representative,
            supervising_department,
            client_name,
            project_name,
            operator,
            accounting_month,
            accuracy
    ) B ON C.accounting_period = B.accounting_period
    AND C.sales_department = B.sales_department
    AND C.classification = B.classification
    AND C.sales_representative = B.sales_representative
    AND C.supervising_department = B.supervising_department
    AND C.client_name = B.client_name
    AND C.project_name = B.project_name
    AND C.operator = B.operator
    AND C.accounting_month = B.accounting_month
    AND C.accuracy = B.accuracy
HAVING
    diff <> 0;