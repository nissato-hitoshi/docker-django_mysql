SELECT
  accounting_period AS 会計期
  ,client_name AS 取引先
  ,SUM(
      CASE WHEN half_period = "1:上期" THEN sales_budget
      ELSE 0 END
  ) AS 上期
  ,SUM(
      CASE  WHEN half_period = "2:下期" THEN sales_budget
      ELSE 0 END
  ) AS 下期
  ,SUM(sales_budget) AS 合計
FROM
  sales_budget
WHERE
  accounting_period = 43
GROUP BY
  accounting_period
  ,client_name
ORDER BY
  合計 DESC;