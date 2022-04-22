SELECT
  A.sales_department
  ,A.first_half_sales_budget_total
  ,B.second_half_sales_budget_total
  ,
  (
    A.first_half_sales_budget_total + B.second_half_sales_budget_total
  ) full_year_sales_budget_total
FROM
  (
    SELECT
      sales_department
      ,sum(sales_budget) first_half_sales_budget_total
    FROM
      sales_budget
    WHERE
      half_period = "1:上期"
    GROUP BY
      sales_department
  ) A
  JOIN (
    SELECT
      sales_department
      ,sum(sales_budget) second_half_sales_budget_total
    FROM
      sales_budget
    WHERE
      half_period = "2:下期"
    GROUP BY
      sales_department
  ) B ON A.sales_department = B.sales_department;