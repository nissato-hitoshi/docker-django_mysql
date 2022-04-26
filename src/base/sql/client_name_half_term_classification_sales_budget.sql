SELECT
  AA.client_name
  ,IFNULL(BB.first_half_Employee_total,0) first_half_Employee_total
  ,IFNULL(BB.first_half_outsourcing_total,0) first_half_outsourcing_total
  ,IFNULL(BB.first_half_product_sales_total,0) first_half_product_sales_total
  ,IFNULL(BB.first_half_sales_budget_total,0) first_half_sales_budget_total
  ,IFNULL(CC.second_half_Employee_total,0) second_half_Employee_total
  ,IFNULL(CC.second_half_outsourcing_total,0) second_half_outsourcing_total
  ,IFNULL(CC.second_half_product_sales_total,0) second_half_product_sales_total
  ,IFNULL(CC.second_half_sales_budget_total,0) second_half_sales_budget_total
  ,AA.full_year_Employee_total
  ,AA.full_year_outsourcing_total
  ,AA.full_year_product_sales_total
  ,AA.full_year_sales_budget_total
FROM
  (                                                                        --通期
    SELECT
      A.client_name
      ,IFNULL(B.full_year_Employee_total,0) full_year_Employee_total
      ,IFNULL(C.full_year_outsourcing_total,0) full_year_outsourcing_total
      ,IFNULL(D.full_year_product_sales_total,0) full_year_product_sales_total
      ,A.full_year_sales_budget_total
    FROM
      (
        SELECT
          client_name
          ,sum(sales_budget) full_year_sales_budget_total
        FROM
          sales_budget
        GROUP BY
          client_name
      ) A
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) full_year_Employee_total
        FROM
          sales_budget
        WHERE
          classification = "1:社員"
        GROUP BY
          client_name
      ) B ON A.client_name = B.client_name
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) full_year_outsourcing_total
        FROM
          sales_budget
        WHERE
          classification = "2:外注"
        GROUP BY
          client_name
      ) C ON A.client_name = C.client_name
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) full_year_product_sales_total
        FROM
          sales_budget
        WHERE
          classification = "3:物販"
        GROUP BY
          client_name
      ) D ON A.client_name = D.client_name
  ) AA
  LEFT JOIN                                                          
  (                                                                  --上期
    SELECT
      A.client_name
      ,IFNULL(B.first_half_Employee_total,0) first_half_Employee_total
      ,IFNULL(C.first_half_outsourcing_total,0) first_half_outsourcing_total
      ,IFNULL(D.first_half_product_sales_total,0) first_half_product_sales_total
      ,A.first_half_sales_budget_total
    FROM
      (
        SELECT
          client_name
          ,sum(sales_budget) first_half_sales_budget_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
        GROUP BY
          client_name
      ) A
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) first_half_Employee_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "1:社員"
        GROUP BY
          client_name
      ) B ON A.client_name = B.client_name
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) first_half_outsourcing_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "2:外注"
        GROUP BY
          client_name
      ) C ON A.client_name = C.client_name
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) first_half_product_sales_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "3:物販"
        GROUP BY
          client_name
      ) D ON A.client_name = D.client_name
  ) BB ON AA.client_name = BB.client_name
  LEFT JOIN                                                                 
  (                                                                         --下期 
    SELECT
      A.client_name
      ,IFNULL(B.second_half_Employee_total,0) second_half_Employee_total
      ,IFNULL(C.second_half_outsourcing_total,0) second_half_outsourcing_total
      ,IFNULL(D.second_half_product_sales_total, 0) second_half_product_sales_total
      ,A.second_half_sales_budget_total
    FROM
      (
        SELECT
          client_name
          ,sum(sales_budget) second_half_sales_budget_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
        GROUP BY
          client_name
      ) A
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) second_half_Employee_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "1:社員"
        GROUP BY
          client_name
      ) B ON A.client_name = B.client_name
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) second_half_outsourcing_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "2:外注"
        GROUP BY
          client_name
      ) C ON A.client_name = C.client_name
      LEFT JOIN (
        SELECT
          client_name
          ,sum(sales_budget) second_half_product_sales_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "3:物販"
        GROUP BY
          client_name
      ) D ON A.client_name = D.client_name
  ) CC ON AA.client_name = CC.client_name
ORDER BY
  AA.full_year_sales_budget_total desc;