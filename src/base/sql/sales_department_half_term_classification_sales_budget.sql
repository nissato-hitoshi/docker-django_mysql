SELECT
  accounting_period AS 会計期
  ,sales_department AS 営業部
  ,SUM(
      CASE WHEN half_period = "1:上期" AND
      classification = "1:社員" THEN sales_budget
      ELSE 0 END
  ) AS 上期：社員
  ,SUM(
      CASE WHEN half_period = "1:上期" AND
      classification = "2:外注" THEN sales_budget
      ELSE 0 END
  ) AS 上期：外注
  ,SUM(
      CASE WHEN half_period = "1:上期" AND
      classification = "3:物販" THEN sales_budget
      ELSE 0 END
  ) AS 上期：物販
  ,SUM(
      CASE WHEN half_period = "1:上期" THEN sales_budget
      ELSE 0 END
  ) AS 上期：合計
  ,SUM(
      CASE WHEN half_period = "2:下期" AND
      classification = "1:社員" THEN sales_budget
      ELSE 0 END
  ) AS 下期：社員
  ,SUM(
      CASE WHEN half_period = "2:下期" AND
      classification = "2:外注" THEN sales_budget
      ELSE 0 END
  ) AS 下期：外注
  ,SUM(
      CASE WHEN half_period = "2:下期" AND
      classification = "3:物販" THEN sales_budget
      ELSE 0 END
  ) AS 下期：物販
  ,SUM(
      CASE WHEN half_period = "2:下期" THEN sales_budget
      ELSE 0 END
  ) AS 下期：合計
  ,SUM(
      CASE WHEN classification = "1:社員" THEN sales_budget
      ELSE 0 END 
  ) AS 通期：社員
  ,SUM(
      CASE WHEN classification = "2:外注" THEN sales_budget
      ELSE 0 END
  ) AS 通期：外注
  ,SUM(
      CASE WHEN classification = "3:物販" THEN sales_budget
      ELSE 0 END
  ) AS 通期：物販
  ,SUM(sales_budget) AS 通期：合計
FROM
  sales_budget
WHERE
  accounting_period = 43
GROUP BY
  accounting_period
  ,sales_department
ORDER BY
  通期：合計 DESC;
