SELECT
    A.accounting_period AS 会計期
    ,A.supervising_department AS 事業部
    ,IFNULL(B.10月予算,0) AS 10月予算
    ,IFNULL(C.10月実績,0) AS 10月実績
    ,IFNULL(10月実績,0) - IFNULL(10月予算,0) AS 10月予実差
    ,IFNULL(B.11月予算,0) AS 11月予算
    ,IFNULL(C.11月実績,0) AS 11月実績
    ,IFNULL(11月実績,0) - IFNULL(11月予算,0) AS 11月予実差
    ,IFNULL(B.12月予算,0) AS 12月予算
    ,IFNULL(C.12月実績,0) AS 12月実績
    ,IFNULL(12月実績,0) - IFNULL(12月予算,0) AS 12月予実差
    ,IFNULL(B.1月予算,0) AS 1月予算
    ,IFNULL(C.1月実績,0) AS 1月実績
    ,IFNULL(1月実績,0) - IFNULL(1月予算,0) AS 1月予実差
    ,IFNULL(B.2月予算,0) AS 2月予算
    ,IFNULL(C.2月実績,0) AS 2月実績
    ,IFNULL(2月実績,0) - IFNULL(2月予算,0) AS 2月予実差
    ,IFNULL(B.3月予算,0) AS 3月予算
    ,IFNULL(C.3月実績,0) AS 3月実績
    ,IFNULL(3月実績,0) - IFNULL(3月予算,0) AS 3月予実差
    ,IFNULL(B.4月予算,0) AS 4月予算
    ,IFNULL(C.4月実績,0) AS 4月実績
    ,IFNULL(4月実績,0) - IFNULL(4月予算,0) AS 4月予実差
    ,IFNULL(B.5月予算,0) AS 5月予算
    ,IFNULL(C.5月実績,0) AS 5月実績
    ,IFNULL(5月実績,0) - IFNULL(5月予算,0) AS 5月予実差
    ,IFNULL(B.6月予算,0) AS 6月予算
    ,IFNULL(C.6月実績,0) AS 6月実績
    ,IFNULL(6月実績,0) - IFNULL(6月予算,0) AS 6月予実差
    ,IFNULL(B.7月予算,0) AS 7月予算
    ,IFNULL(C.7月実績,0) AS 7月実績
    ,IFNULL(7月実績,0) - IFNULL(7月予算,0) AS 7月予実差
    ,IFNULL(B.8月予算,0) AS 8月予算
    ,IFNULL(C.8月実績,0) AS 8月実績
    ,IFNULL(8月実績,0) - IFNULL(8月予算,0) AS 8月予実差
    ,IFNULL(B.9月予算,0) AS 9月予算
    ,IFNULL(C.9月実績,0) AS 9月実績
    ,IFNULL(9月実績,0) - IFNULL(9月予算,0) AS 9月予実差
    ,IFNULL(B.予算合計,0) AS 予算合計
    ,IFNULL(C.実績合計,0) AS 実績合計
    ,IFNULL(実績合計,0) - IFNULL(予算合計,0) AS 予実差合計
FROM(
    SELECT
        accounting_period
        ,supervising_department
    FROM
        sales_budget
    GROUP BY
        accounting_period
        ,supervising_department

    UNION 

    SELECT 
        accounting_period
        ,business_sector
    FROM
        sales_achievement
    GROUP BY
        accounting_period
        ,business_sector
    )A
    
    LEFT JOIN
    (
    SELECT
        accounting_period 
        ,supervising_department 
        ,SUM(
            CASE WHEN accounting_month LIKE "%10" THEN sales_budget
            ELSE 0 END  
        ) AS 10月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%11" THEN sales_budget
            ELSE 0 END
        ) AS 11月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%12" THEN sales_budget
            ELSE 0 END
        ) AS 12月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%01" THEN sales_budget
            ELSE 0 END
        ) AS 1月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%02" THEN sales_budget
            ELSE 0 END
        ) AS 2月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%03" THEN sales_budget
            ELSE 0 END
        ) AS 3月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%04" THEN sales_budget
            ELSE 0 END
        ) AS 4月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%05" THEN sales_budget
            ELSE 0 END
        ) AS 5月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%06" THEN sales_budget
            ELSE 0 END
        ) AS 6月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%07" THEN sales_budget
            ELSE 0 END
        ) AS 7月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%08" THEN sales_budget
            ELSE 0 END
        ) AS 8月予算
        ,SUM(
            CASE WHEN accounting_month LIKE "%09" THEN sales_budget
            ELSE 0 END
        ) AS 9月予算
        ,SUM(sales_budget) AS 予算合計

    FROM
        sales_budget
    GROUP BY
        accounting_period
        ,supervising_department
    )B
    ON
        A.accounting_period = B.accounting_period AND
        A.supervising_department = B.supervising_department

    LEFT JOIN
    (
    SELECT
        accounting_period 
        ,business_sector 
        ,SUM(
            CASE WHEN accounting_month LIKE "%10" THEN amount_of_sales
            ELSE 0 END
        ) AS 10月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%11" THEN amount_of_sales
            ELSE 0 END
        ) AS 11月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%12" THEN amount_of_sales
            ELSE 0 END
        ) AS 12月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%01" THEN amount_of_sales
            ELSE 0 END
        ) AS 1月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%02" THEN amount_of_sales
            ELSE 0 END
        ) AS 2月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%03" THEN amount_of_sales
            ELSE 0 END
        ) AS 3月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%04" THEN amount_of_sales
            ELSE 0 END
        ) AS 4月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%05" THEN amount_of_sales
            ELSE 0 END
        ) AS 5月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%06" THEN amount_of_sales
            ELSE 0 END
        ) AS 6月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%07" THEN amount_of_sales
            ELSE 0 END
        ) AS 7月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%08" THEN amount_of_sales
            ELSE 0 END
        ) AS 8月実績
        ,SUM(
            CASE WHEN accounting_month LIKE "%09" THEN amount_of_sales
            ELSE 0 END
        ) AS 9月実績
        ,SUM(amount_of_sales) AS 実績合計
    FROM
        sales_achievement
    GROUP BY
        accounting_period
        ,business_sector
    )C
    ON
        A.accounting_period = C.accounting_period AND
        A.supervising_department = C.business_sector
WHERE
  A.accounting_period = 43
ORDER BY
  予実差合計 asc;
