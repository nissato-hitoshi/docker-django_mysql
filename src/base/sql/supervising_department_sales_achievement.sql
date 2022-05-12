SELECT
  A.accounting_period AS 会計期
  ,A.accounting_month AS 年月
  ,A.supervising_department AS 事業部
  ,IFNULL(B.社員, 0) AS 社員
  ,IFNULL(B.外注, 0) AS 外注
  ,IFNULL(B.物販, 0) AS 物販
  ,IFNULL(B.予算計, 0) AS 予算計
  ,IFNULL(C.売上高, 0) AS 売上高
  ,IFNULL(C.材料費, 0) AS 材料費
  ,IFNULL(C.労務費, 0) AS 労務費
  ,IFNULL(C.外注費, 0) AS 外注費
  ,IFNULL(C.経費, 0) AS 経費
  ,IFNULL(C.粗利額, 0) AS 粗利額
  ,concat(IFNULL(format(C.粗利率, 2), 0.00),'%') AS 粗利率
  ,IFNULL(売上高, 0) - IFNULL(予算計, 0) AS 予実差
  ,concat(IFNULL(format(IFNULL(売上高, 0) / IFNULL(予算計, 0),2),0.00),'%') AS 予実比
FROM
  (
    SELECT
      accounting_period
      ,accounting_month
      ,supervising_department
    FROM
      sales_budget
    GROUP BY
      accounting_period
      ,accounting_month
      ,supervising_department
    UNION
    SELECT
      accounting_period
      ,accounting_month
      ,business_sector
    FROM
      sales_achievement
    GROUP BY
      accounting_period
      ,accounting_month
      ,business_sector
  ) A
  LEFT JOIN (
    SELECT
      accounting_period
      ,accounting_month
      ,supervising_department
      ,SUM(
          CASE WHEN classification = "1:社員" THEN sales_budget
          ELSE 0 END
      ) AS 社員
      ,SUM(
          CASE WHEN classification = "2:外注" THEN sales_budget
          ELSE 0 END
      ) AS 外注
      ,SUM(
          CASE WHEN classification = "3:物販" THEN sales_budget
          ELSE 0 END
      ) AS 物販
      ,sum(sales_budget) AS 予算計
    FROM
      sales_budget
    GROUP BY
      accounting_period
      ,accounting_month
      ,supervising_department
  ) B ON A.accounting_period = B.accounting_period AND
         A.accounting_month = B.accounting_month AND
         A.supervising_department = B.supervising_department
  LEFT JOIN (
    SELECT
      accounting_period
      ,accounting_month
      ,business_sector
      ,sum(amount_of_sales) AS 売上高
      ,sum(material_cost) AS 材料費
      ,sum(labor_cost) AS 労務費
      ,sum(outsourcing_cost) AS 外注費
      ,sum(expenses) AS 経費
      ,sum(gross_profit) AS 粗利額
      ,(sum(gross_profit) / sum(amount_of_sales)) AS 粗利率
    FROM
      sales_achievement
    GROUP BY
      accounting_period
      ,accounting_month
      ,business_sector
  ) C ON A.accounting_period = C.accounting_period AND
         A.accounting_month = C.accounting_month AND 
         A.supervising_department = C.business_sector
WHERE
  A.accounting_period = 43 AND
  A.accounting_month LIKE "%10"
ORDER BY
  予実差 desc; 