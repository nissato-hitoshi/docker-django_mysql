SELECT
  A.supervising_department,
  IFNULL(B.社員, 0) 社員,
  IFNULL(B.外注, 0) 外注,
  IFNULL(B.物販, 0) 物販,
  IFNULL(B.sales_budget_total, 0) sales_budget_total,
  IFNULL(C.amount_of_sales_total, 0) amount_of_sales_total,
  IFNULL(C.material_cost_total, 0) material_cost_total,
  IFNULL(C.labor_cost_total, 0) labor_cost_total,
  IFNULL(C.outsourcing_cost_total, 0) outsourcing_cost_total,
  IFNULL(C.expenses_total, 0) expenses_total,
  IFNULL(C.gross_profit_total, 0) gross_profit_total,
  concat(
    IFNULL(format(C.gross_profit_margin_total, 2), 0.00),
    '%'
  ) gross_profit_margin_total,
  IFNULL(C.amount_of_sales_total, 0) - IFNULL(B.sales_budget_total, 0) difference_total,
  concat(
    IFNULL(
      format(
        IFNULL(C.amount_of_sales_total, 0) / IFNULL(B.sales_budget_total, 0),
        2
      ),
      0.00
    ),
    '%'
  ) compare_total
FROM
  (
    SELECT
      supervising_department
    FROM
      sales_budget
    GROUP BY
      supervising_department
    UNION
    SELECT
      business_sector
    FROM
      sales_achievement
    GROUP BY
      business_sector
  ) A
  LEFT JOIN (
    SELECT
      supervising_department,
      SUM(
        CASE
          WHEN classification = "1:社員" THEN sales_budget
          ELSE 0
        END
      ) AS '社員',
      SUM(
        CASE
          WHEN classification = "2:外注" THEN sales_budget
          ELSE 0
        END
      ) AS '外注',
      SUM(
        CASE
          WHEN classification = "3:物販" THEN sales_budget
          ELSE 0
        END
      ) AS '物販',
      sum(sales_budget) sales_budget_total
    FROM
      sales_budget
    WHERE
      accounting_month = "202203"
    GROUP BY
      supervising_department
  ) B ON A.supervising_department = B.supervising_department
  LEFT JOIN (
    SELECT
      business_sector,
      sum(amount_of_sales) amount_of_sales_total,
      sum(material_cost) material_cost_total,
      sum(labor_cost) labor_cost_total,
      sum(outsourcing_cost) outsourcing_cost_total,
      sum(expenses) expenses_total,
      sum(gross_profit) gross_profit_total,(sum(gross_profit) / sum(amount_of_sales)) gross_profit_margin_total
    FROM
      sales_achievement
    WHERE
      accounting_month = "202203"
    GROUP BY
      business_sector
  ) C ON A.supervising_department = C.business_sector
ORDER BY
  difference_total desc; 