SELECT
  AA.sales_department
  ,BB.first_half_Employee_total
  ,BB.first_half_outsourcing_total
  ,BB.first_half_product_sales_total
  ,(BB.first_half_Employee_total + BB.first_half_outsourcing_total + BB.first_half_product_sales_total) first_half_sales_budget_total
  ,CC.second_half_Employee_total
  ,CC.second_half_outsourcing_total
  ,CC.second_half_product_sales_total
  ,(CC.second_half_Employee_total + CC.second_half_outsourcing_total + CC.second_half_product_sales_total) second_half_sales_budget_total
  ,AA.full_year_Employee_total
  ,AA.full_year_outsourcing_total
  ,AA.full_year_product_sales_total
  ,(AA.full_year_Employee_total + AA.full_year_outsourcing_total + AA.full_year_product_sales_total) full_year_salse_budget_total
FROM
  (                                                                        --通期
    SELECT
      A.sales_department
      ,B.full_year_Employee_total
      ,C.full_year_outsourcing_total
      ,D.full_year_product_sales_total
      ,(B.full_year_Employee_total + C.full_year_outsourcing_total + D.full_year_product_sales_total) full_year_salse_budget_total
    FROM
      (
        SELECT
          sales_department
          ,sum(sales_budget) classification
        FROM
          sales_budget
        GROUP BY
          sales_department
      ) A
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) full_year_Employee_total
        FROM
          sales_budget
        WHERE
          classification = "1:社員"
        GROUP BY
          sales_department
      ) B ON A.sales_department = B.sales_department
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) full_year_outsourcing_total
        FROM
          sales_budget
        WHERE
          classification = "2:外注"
        GROUP BY
          sales_department
      ) C ON A.sales_department = C.sales_department
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) full_year_product_sales_total
        FROM
          sales_budget
        WHERE
          classification = "3:物販"
        GROUP BY
          sales_department
      ) D ON A.sales_department = D.sales_department
  ) AA
  LEFT JOIN                                                          
  (                                                                  --上期
    SELECT
      A.sales_department
      ,B.first_half_Employee_total
      ,C.first_half_outsourcing_total
      ,D.first_half_product_sales_total
      ,(B.first_half_Employee_total + C.first_half_outsourcing_total + D.first_half_product_sales_total) first_half_sales_budget_total
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
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) first_half_Employee_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "1:社員"
        GROUP BY
          sales_department
      ) B ON A.sales_department = B.sales_department
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) first_half_outsourcing_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "2:外注"
        GROUP BY
          sales_department
      ) C ON A.sales_department = C.sales_department
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) first_half_product_sales_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "3:物販"
        GROUP BY
          sales_department
      ) D ON A.sales_department = D.sales_department
  ) BB ON AA.sales_department = BB.sales_department
  LEFT JOIN                                                                 
  (                                                                         --下期 
    SELECT
      A.sales_department
      ,B.second_half_Employee_total
      ,C.second_half_outsourcing_total
      ,IFNULL(D.second_half_product_sales_total, 0) second_half_product_sales_total
      ,(
        B.second_half_Employee_total + C.second_half_outsourcing_total + IFNULL(second_half_product_sales_total, 0)
      ) second_half_sales_budget_total
    FROM
      (
        SELECT
          sales_department
          ,sum(sales_budget) second_half_sales_budget_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
        GROUP BY
          sales_department
      ) A
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) second_half_Employee_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "1:社員"
        GROUP BY
          sales_department
      ) B ON A.sales_department = B.sales_department
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) second_half_outsourcing_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "2:外注"
        GROUP BY
          sales_department
      ) C ON A.sales_department = C.sales_department
      LEFT JOIN (
        SELECT
          sales_department
          ,sum(sales_budget) second_half_product_sales_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "3:物販"
        GROUP BY
          sales_department
      ) D ON A.sales_department = D.sales_department
  ) CC ON AA.sales_department = CC.sales_department;