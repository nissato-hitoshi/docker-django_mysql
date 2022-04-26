SELECT
  AA.supervising_department
  ,BB.first_half_Employee_total
  ,BB.first_half_outsourcing_total
  ,BB.first_half_product_sales_total
  ,BB.first_half_sales_budget_total
  ,CC.second_half_Employee_total
  ,CC.second_half_outsourcing_total
  ,CC.second_half_product_sales_total
  ,CC.second_half_sales_budget_total
  ,AA.full_year_Employee_total
  ,AA.full_year_outsourcing_total
  ,AA.full_year_product_sales_total
  ,AA.full_year_sales_budget_total
FROM
  (                                                                        --通期
    SELECT
      A.supervising_department
      ,IFNULL(B.full_year_Employee_total,0) full_year_Employee_total
      ,C.full_year_outsourcing_total
      ,IFNULL(D.full_year_product_sales_total,0) full_year_product_sales_total
      ,A.full_year_sales_budget_total
    FROM
      (
        SELECT
          supervising_department
          ,sum(sales_budget) full_year_sales_budget_total
        FROM
          sales_budget
        GROUP BY
          supervising_department
      ) A
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) full_year_Employee_total
        FROM
          sales_budget
        WHERE
          classification = "1:社員"
        GROUP BY
          supervising_department
      ) B ON A.supervising_department = B.supervising_department
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) full_year_outsourcing_total
        FROM
          sales_budget
        WHERE
          classification = "2:外注"
        GROUP BY
          supervising_department
      ) C ON A.supervising_department = C.supervising_department
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) full_year_product_sales_total
        FROM
          sales_budget
        WHERE
          classification = "3:物販"
        GROUP BY
          supervising_department
      ) D ON A.supervising_department = D.supervising_department
  ) AA
  LEFT JOIN                                                          
  (                                                                  --上期
    SELECT
      A.supervising_department
      ,IFNULL(B.first_half_Employee_total,0) first_half_Employee_total
      ,C.first_half_outsourcing_total
      ,IFNULL(D.first_half_product_sales_total,0) first_half_product_sales_total
      ,A.first_half_sales_budget_total
    FROM
      (
        SELECT
          supervising_department
          ,sum(sales_budget) first_half_sales_budget_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
        GROUP BY
          supervising_department
      ) A
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) first_half_Employee_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "1:社員"
        GROUP BY
          supervising_department
      ) B ON A.supervising_department = B.supervising_department
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) first_half_outsourcing_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "2:外注"
        GROUP BY
          supervising_department
      ) C ON A.supervising_department = C.supervising_department
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) first_half_product_sales_total
        FROM
          sales_budget
        WHERE
          half_period = "1:上期"
          AND classification = "3:物販"
        GROUP BY
          supervising_department
      ) D ON A.supervising_department = D.supervising_department
  ) BB ON AA.supervising_department = BB.supervising_department
  LEFT JOIN                                                                 
  (                                                                         --下期 
    SELECT
      A.supervising_department
      ,IFNULL(B.second_half_Employee_total,0) second_half_Employee_total
      ,C.second_half_outsourcing_total
      ,IFNULL(D.second_half_product_sales_total, 0) second_half_product_sales_total
      ,A.second_half_sales_budget_total
    FROM
      (
        SELECT
          supervising_department
          ,sum(sales_budget) second_half_sales_budget_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
        GROUP BY
          supervising_department
      ) A
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) second_half_Employee_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "1:社員"
        GROUP BY
          supervising_department
      ) B ON A.supervising_department = B.supervising_department
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) second_half_outsourcing_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "2:外注"
        GROUP BY
          supervising_department
      ) C ON A.supervising_department = C.supervising_department
      LEFT JOIN (
        SELECT
          supervising_department
          ,sum(sales_budget) second_half_product_sales_total
        FROM
          sales_budget
        WHERE
          half_period = "2:下期"
          AND classification = "3:物販"
        GROUP BY
          supervising_department
      ) D ON A.supervising_department = D.supervising_department
  ) CC ON AA.supervising_department = CC.supervising_department
ORDER BY
  AA.full_year_sales_budget_total desc;