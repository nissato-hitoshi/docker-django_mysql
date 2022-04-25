SELECT
  A.client_name
  ,IFNULL(B.first_half_sales_budget_total,0) first_half_sales_budget_total
  ,IFNULL(C.second_half_sales_budget_total,0) second_half_sales_budget_total
  ,(
  IFNULL(B.first_half_sales_budget_total,0) + IFNULL(C.second_half_sales_budget_total,0) 
  ) full_year_budget
FROM
  (
    SELECT
      client_name
      ,sum(sales_budget) sales_budget_total
    FROM
      sales_budget
    GROUP BY
      client_name
  ) A
  LEFT JOIN (
    SELECT
      client_name
      ,sum(sales_budget) first_half_sales_budget_total
    FROM
      sales_budget
    WHERE
      half_period = "1:上期"
    GROUP BY
      client_name
  ) B ON A.client_name = B.client_name
  LEFT JOIN (
    SELECT
      client_name
      ,sum(sales_budget) second_half_sales_budget_total
    FROM
      sales_budget
    WHERE
      half_period = "2:下期"
    GROUP BY
      client_name
  ) C ON A.client_name = C.client_name;