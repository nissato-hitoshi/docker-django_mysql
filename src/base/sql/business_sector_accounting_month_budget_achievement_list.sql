SELECT
  divfullyearDiff.business_sector,
  IFNULL(div10monthDiff.10_sales_budget_total, 0) 202110_sales_budget_total,
  IFNULL(div10monthDiff.10_amount_of_sales_total, 0) 202110_amount_of_sales_total,
  IFNULL(div10monthDiff.10_difference_total, 0) 202110_difference_total,
  IFNULL(div11monthDiff.11_sales_budget_total, 0) 202111_sales_budget_total,
  IFNULL(div11monthDiff.11_amount_of_sales_total, 0) 202111_amount_of_sales_total,
  IFNULL(div11monthDiff.11_difference_total, 0) 202111_difference_total,
  IFNULL(div12monthDiff.12_sales_budget_total, 0) 202112_sales_budget_total,
  IFNULL(div12monthDiff.12_amount_of_sales_total, 0) 202112_amount_of_sales_total,
  IFNULL(div12monthDiff.12_difference_total, 0) 202112_difference_total,
  IFNULL(div01monthDiff.01_sales_budget_total, 0) 202201_sales_budget_total,
  IFNULL(div01monthDiff.01_amount_of_sales_total, 0) 202201_amount_of_sales_total,
  IFNULL(div01monthDiff.01_difference_total, 0) 202201_difference_total,
  IFNULL(div02monthDiff.02_sales_budget_total, 0) 202202_sales_budget_total,
  IFNULL(div02monthDiff.02_amount_of_sales_total, 0) 202202_amount_of_sales_total,
  IFNULL(div02monthDiff.02_difference_total, 0) 202202_difference_total,
  IFNULL(div03monthDiff.03_sales_budget_total,0) 202203_sales_budget_total,
  IFNULL(div03monthDiff.03_amount_of_sales_total, 0) 202203_amount_of_sales_total,
  IFNULL(div03monthDiff.03_difference_total,0) 202203_difference_total,
  IFNULL(div04monthDiff.04_sales_budget_total, 0) 202204_sales_budget_total,
  IFNULL(div04monthDiff.04_amount_of_sales_total, 0) 202204_amount_of_sales_total,
  IFNULL(div04monthDiff.04_difference_total, 0) 202204_difference_total,
  IFNULL(div05monthDiff.05_sales_budget_total, 0) 202205_sales_budget_total,
  IFNULL(div05monthDiff.05_amount_of_sales_total, 0) 202205_amount_of_sales_total,
  IFNULL(div05monthDiff.05_difference_total, 0) 202205_difference_total,
  IFNULL(div06monthDiff.06_sales_budget_total, 0) 202206_sales_budget_total,
  IFNULL(div06monthDiff.06_amount_of_sales_total, 0) 202206_amount_of_sales_total,
  IFNULL(div06monthDiff.06_difference_total, 0) 202206_difference_total,
  IFNULL(div07monthDiff.07_sales_budget_total, 0) 202207_sales_budget_total,
  IFNULL(div07monthDiff.07_amount_of_sales_total, 0) 202207_amount_of_sales_total,
  IFNULL(div07monthDiff.07_difference_total, 0) 202207_difference_total,
  IFNULL(div08monthDiff.08_sales_budget_total, 0) 202208_sales_budget_total,
  IFNULL(div08monthDiff.08_amount_of_sales_total, 0) 202208_amount_of_sales_total,
  IFNULL(div08monthDiff.08_difference_total, 0) 202208_difference_total,
  IFNULL(div09monthDiff.09_sales_budget_total, 0) 202209_sales_budget_total,
  IFNULL(div09monthDiff.09_amount_of_sales_total, 0) 202209_amount_of_sales_total,
  IFNULL(div09monthDiff.09_difference_total, 0) 202209_difference_total,
  divfullyearDiff.full_year_sales_budget_total,
  divfullyearDiff.full_year_amount_of_sales_total,
  divfullyearDiff.full_year_difference_total
from
  (
    SELECT
      IFNULL(divAchievement.business_sector, "") business_sector,
      IFNULL(divBudget.full_year_sales_budget_total, 0) full_year_sales_budget_total,
      IFNULL(
        divAchievement.full_year_amount_of_sales_total,
        0
      ) full_year_amount_of_sales_total,(
        IFNULL(full_year_amount_of_sales_total, 0) - IFNULL(full_year_sales_budget_total, 0)
      ) full_year_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) full_year_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_period = 43
        GROUP BY
          supervising_department
      ) divBudget
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) full_year_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_period = 43
        GROUP BY
          business_sector
      ) divAchievement ON divBudget.supervising_department = divAchievement.business_sector
    UNION
    SELECT
      IFNULL(divAchievement.business_sector, "") business_sector,
      IFNULL(divBudget.full_year_sales_budget_total, 0) full_year_sales_budget_total,
      IFNULL(
        divAchievement.full_year_amount_of_sales_total,
        0
      ) full_year_amount_of_sales_total,
      IFNULL(full_year_amount_of_sales_total, 0) - IFNULL(full_year_sales_budget_total, 0) full_year_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) full_year_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_period = 43
        GROUP BY
          supervising_department
      ) divBudget
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) full_year_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_period = 43
        GROUP BY
          business_sector
      ) divAchievement ON divBudget.supervising_department = divAchievement.business_sector
  ) divfullyearDiff
  LEFT JOIN --202110
  (
    SELECT
      IFNULL(divAchievement10.business_sector, "") business_sector,
      IFNULL(divBudget10.10_sales_budget_total, 0) 10_sales_budget_total,
      IFNULL(divAchievement10.10_amount_of_sales_total, 0) 10_amount_of_sales_total,(
        IFNULL(10_amount_of_sales_total, 0) - IFNULL(10_sales_budget_total, 0)
      ) 10_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 10_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202110"
        GROUP BY
          supervising_department
      ) divBudget10
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 10_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202110"
        GROUP BY
          business_sector
      ) divAchievement10 ON divBudget10.supervising_department = divAchievement10.business_sector
    UNION
    SELECT
      IFNULL(divAchievement10.business_sector, "") business_sector,
      IFNULL(divBudget10.10_sales_budget_total, 0) 10_sales_budget_total,
      IFNULL(divAchievement10.10_amount_of_sales_total, 0) 10_amount_of_sales_total,
      IFNULL(10_amount_of_sales_total, 0) - IFNULL(10_sales_budget_total, 0) 10_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 10_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202110"
        GROUP BY
          supervising_department
      ) divBudget10
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 10_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202110"
        GROUP BY
          business_sector
      ) divAchievement10 ON divBudget10.supervising_department = divAchievement10.business_sector
  ) div10monthDiff ON divfullyearDiff.business_sector = div10monthDiff.business_sector
  LEFT JOIN --202111
  (
    SELECT
      IFNULL(divAchievement11.business_sector, "") business_sector,
      IFNULL(divBudget11.11_sales_budget_total, 0) 11_sales_budget_total,
      IFNULL(divAchievement11.11_amount_of_sales_total, 0) 11_amount_of_sales_total,(
        IFNULL(11_amount_of_sales_total, 0) - IFNULL(11_sales_budget_total, 0)
      ) 11_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 11_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202111"
        GROUP BY
          supervising_department
      ) divBudget11
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 11_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202111"
        GROUP BY
          business_sector
      ) divAchievement11 ON divBudget11.supervising_department = divAchievement11.business_sector
    UNION
    SELECT
      IFNULL(divAchievement11.business_sector, "") business_sector,
      IFNULL(divBudget11.11_sales_budget_total, 0) 11_sales_budget_total,
      IFNULL(divAchievement11.11_amount_of_sales_total, 0) 11_amount_of_sales_total,
      IFNULL(11_amount_of_sales_total, 0) - IFNULL(11_sales_budget_total, 0) 11_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 11_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202111"
        GROUP BY
          supervising_department
      ) divBudget11
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 11_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202111"
        GROUP BY
          business_sector
      ) divAchievement11 ON divBudget11.supervising_department = divAchievement11.business_sector
  ) div11monthDiff ON divfullyearDiff.business_sector = div11monthDiff.business_sector
  LEFT JOIN --202112
  (
    SELECT
      IFNULL(divAchievement12.business_sector, "") business_sector,
      IFNULL(divBudget12.12_sales_budget_total, 0) 12_sales_budget_total,
      IFNULL(divAchievement12.12_amount_of_sales_total, 0) 12_amount_of_sales_total,(
        IFNULL(12_amount_of_sales_total, 0) - IFNULL(12_sales_budget_total, 0)
      ) 12_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 12_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202112"
        GROUP BY
          supervising_department
      ) divBudget12
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 12_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202112"
        GROUP BY
          business_sector
      ) divAchievement12 ON divBudget12.supervising_department = divAchievement12.business_sector
    UNION
    SELECT
      IFNULL(divAchievement12.business_sector, "") business_sector,
      IFNULL(divBudget12.12_sales_budget_total, 0) 12_sales_budget_total,
      IFNULL(divAchievement12.12_amount_of_sales_total, 0) 12_amount_of_sales_total,
      IFNULL(12_amount_of_sales_total, 0) - IFNULL(12_sales_budget_total, 0) 12_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 12_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202112"
        GROUP BY
          supervising_department
      ) divBudget12
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 12_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202112"
        GROUP BY
          business_sector
      ) divAchievement12 ON divBudget12.supervising_department = divAchievement12.business_sector
  ) div12monthDiff ON divfullyearDiff.business_sector = div12monthDiff.business_sector
  LEFT JOIN --202201
  (
    SELECT
      IFNULL(divAchievement01.business_sector, "") business_sector,
      IFNULL(divBudget01.01_sales_budget_total, 0) 01_sales_budget_total,
      IFNULL(divAchievement01.01_amount_of_sales_total, 0) 01_amount_of_sales_total,(
        IFNULL(01_amount_of_sales_total, 0) - IFNULL(01_sales_budget_total, 0)
      ) 01_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 01_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202201"
        GROUP BY
          supervising_department
      ) divBudget01
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 01_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202201"
        GROUP BY
          business_sector
      ) divAchievement01 ON divBudget01.supervising_department = divAchievement01.business_sector
    UNION
    SELECT
      IFNULL(divAchievement01.business_sector, "") business_sector,
      IFNULL(divBudget01.01_sales_budget_total, 0) 01_sales_budget_total,
      IFNULL(divAchievement01.01_amount_of_sales_total, 0) 01_amount_of_sales_total,
      IFNULL(01_amount_of_sales_total, 0) - IFNULL(01_sales_budget_total, 0) 01_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 01_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202201"
        GROUP BY
          supervising_department
      ) divBudget01
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 01_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202201"
        GROUP BY
          business_sector
      ) divAchievement01 ON divBudget01.supervising_department = divAchievement01.business_sector
  ) div01monthDiff ON divfullyearDiff.business_sector = div01monthDiff.business_sector
  LEFT JOIN --202202
  (
    SELECT
      IFNULL(divAchievement02.business_sector, "") business_sector,
      IFNULL(divBudget02.02_sales_budget_total, 0) 02_sales_budget_total,
      IFNULL(divAchievement02.02_amount_of_sales_total, 0) 02_amount_of_sales_total,(
        IFNULL(02_amount_of_sales_total, 0) - IFNULL(02_sales_budget_total, 0)
      ) 02_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 02_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202202"
        GROUP BY
          supervising_department
      ) divBudget02
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 02_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202202"
        GROUP BY
          business_sector
      ) divAchievement02 ON divBudget02.supervising_department = divAchievement02.business_sector
    UNION
    SELECT
      IFNULL(divAchievement02.business_sector, "") business_sector,
      IFNULL(divBudget02.02_sales_budget_total, 0) 02_sales_budget_total,
      IFNULL(divAchievement02.02_amount_of_sales_total, 0) 02_amount_of_sales_total,
      IFNULL(02_amount_of_sales_total, 0) - IFNULL(02_sales_budget_total, 0) 02_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 02_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202202"
        GROUP BY
          supervising_department
      ) divBudget02
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 02_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202202"
        GROUP BY
          business_sector
      ) divAchievement02 ON divBudget02.supervising_department = divAchievement02.business_sector
  ) div02monthDiff ON divfullyearDiff.business_sector = div02monthDiff.business_sector
  LEFT JOIN --202203
  (
    SELECT
      IFNULL(divAchievement03.business_sector, "") business_sector,
      IFNULL(divBudget03.03_sales_budget_total, 0) 03_sales_budget_total,
      IFNULL(divAchievement03.03_amount_of_sales_total, 0) 03_amount_of_sales_total,(
        IFNULL(03_amount_of_sales_total, 0) - IFNULL(03_sales_budget_total, 0)
      ) 03_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 03_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202203"
        GROUP BY
          supervising_department
      ) divBudget03
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 03_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202203"
        GROUP BY
          business_sector
      ) divAchievement03 ON divBudget03.supervising_department = divAchievement03.business_sector
    UNION
    SELECT
      IFNULL(divAchievement03.business_sector, "") business_sector,
      IFNULL(divBudget03.03_sales_budget_total, 0) 03_sales_budget_total,
      IFNULL(divAchievement03.03_amount_of_sales_total, 0) 03_amount_of_sales_total,
      IFNULL(03_amount_of_sales_total, 0) - IFNULL(03_sales_budget_total, 0) 03_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 03_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202203"
        GROUP BY
          supervising_department
      ) divBudget03
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 03_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202203"
        GROUP BY
          business_sector
      ) divAchievement03 ON divBudget03.supervising_department = divAchievement03.business_sector
  ) div03monthDiff ON divfullyearDiff.business_sector = div03monthDiff.business_sector
  LEFT JOIN --202204
  (
    SELECT
      IFNULL(divBudget04.supervising_department, "") supervising_department,
      IFNULL(divBudget04.04_sales_budget_total, 0) 04_sales_budget_total,
      IFNULL(divAchievement04.04_amount_of_sales_total, 0) 04_amount_of_sales_total,(
        IFNULL(04_amount_of_sales_total, 0) - IFNULL(04_sales_budget_total, 0)
      ) 04_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 04_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202204"
        GROUP BY
          supervising_department
      ) divBudget04
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 04_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202204"
        GROUP BY
          business_sector
      ) divAchievement04 ON divBudget04.supervising_department = divAchievement04.business_sector
    UNION
    SELECT
      IFNULL(divAchievement04.business_sector, "") business_sector,
      IFNULL(divBudget04.04_sales_budget_total, 0) 04_sales_budget_total,
      IFNULL(divAchievement04.04_amount_of_sales_total, 0) 04_amount_of_sales_total,
      IFNULL(04_amount_of_sales_total, 0) - IFNULL(04_sales_budget_total, 0) 04_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 04_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202204"
        GROUP BY
          supervising_department
      ) divBudget04
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 04_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202204"
        GROUP BY
          business_sector
      ) divAchievement04 ON divBudget04.supervising_department = divAchievement04.business_sector
  ) div04monthDiff ON divfullyearDiff.business_sector = div04monthDiff.supervising_department
  LEFT JOIN --202205
  (
    SELECT
      IFNULL(divBudget05.supervising_department, "") supervising_department,
      IFNULL(divBudget05.05_sales_budget_total, 0) 05_sales_budget_total,
      IFNULL(divAchievement05.05_amount_of_sales_total, 0) 05_amount_of_sales_total,(
        IFNULL(05_amount_of_sales_total, 0) - IFNULL(05_sales_budget_total, 0)
      ) 05_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 05_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202205"
        GROUP BY
          supervising_department
      ) divBudget05
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 05_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202205"
        GROUP BY
          business_sector
      ) divAchievement05 ON divBudget05.supervising_department = divAchievement05.business_sector
    UNION
    SELECT
      IFNULL(divAchievement05.business_sector, "") business_sector,
      IFNULL(divBudget05.05_sales_budget_total, 0) 05_sales_budget_total,
      IFNULL(divAchievement05.05_amount_of_sales_total, 0) 05_amount_of_sales_total,
      IFNULL(05_amount_of_sales_total, 0) - IFNULL(05_sales_budget_total, 0) 05_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 05_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202205"
        GROUP BY
          supervising_department
      ) divBudget05
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 05_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202205"
        GROUP BY
          business_sector
      ) divAchievement05 ON divBudget05.supervising_department = divAchievement05.business_sector
  ) div05monthDiff ON divfullyearDiff.business_sector = div05monthDiff.supervising_department
  LEFT JOIN --202206
  (
    SELECT
      IFNULL(divBudget06.supervising_department, "") supervising_department,
      IFNULL(divBudget06.06_sales_budget_total, 0) 06_sales_budget_total,
      IFNULL(divAchievement06.06_amount_of_sales_total, 0) 06_amount_of_sales_total,(
        IFNULL(06_amount_of_sales_total, 0) - IFNULL(06_sales_budget_total, 0)
      ) 06_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 06_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202206"
        GROUP BY
          supervising_department
      ) divBudget06
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 06_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202206"
        GROUP BY
          business_sector
      ) divAchievement06 ON divBudget06.supervising_department = divAchievement06.business_sector
    UNION
    SELECT
      IFNULL(divAchievement06.business_sector, "") business_sector,
      IFNULL(divBudget06.06_sales_budget_total, 0) 06_sales_budget_total,
      IFNULL(divAchievement06.06_amount_of_sales_total, 0) 06_amount_of_sales_total,
      IFNULL(06_amount_of_sales_total, 0) - IFNULL(06_sales_budget_total, 0) 06_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 06_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202206"
        GROUP BY
          supervising_department
      ) divBudget06
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 06_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202206"
        GROUP BY
          business_sector
      ) divAchievement06 ON divBudget06.supervising_department = divAchievement06.business_sector
  ) div06monthDiff ON divfullyearDiff.business_sector = div06monthDiff.supervising_department
  LEFT JOIN --202207
  (
    SELECT
      IFNULL(divBudget07.supervising_department, "") supervising_department,
      IFNULL(divBudget07.07_sales_budget_total, 0) 07_sales_budget_total,
      IFNULL(divAchievement07.07_amount_of_sales_total, 0) 07_amount_of_sales_total,(
        IFNULL(07_amount_of_sales_total, 0) - IFNULL(07_sales_budget_total, 0)
      ) 07_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 07_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202207"
        GROUP BY
          supervising_department
      ) divBudget07
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 07_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202207"
        GROUP BY
          business_sector
      ) divAchievement07 ON divBudget07.supervising_department = divAchievement07.business_sector
    UNION
    SELECT
      IFNULL(divAchievement07.business_sector, "") business_sector,
      IFNULL(divBudget07.07_sales_budget_total, 0) 07_sales_budget_total,
      IFNULL(divAchievement07.07_amount_of_sales_total, 0) 07_amount_of_sales_total,
      IFNULL(07_amount_of_sales_total, 0) - IFNULL(07_sales_budget_total, 0) 07_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 07_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202207"
        GROUP BY
          supervising_department
      ) divBudget07
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 07_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202207"
        GROUP BY
          business_sector
      ) divAchievement07 ON divBudget07.supervising_department = divAchievement07.business_sector
  ) div07monthDiff ON divfullyearDiff.business_sector = div07monthDiff.supervising_department
  LEFT JOIN --202208
  (
    SELECT
      IFNULL(divBudget08.supervising_department, "") supervising_department,
      IFNULL(divBudget08.08_sales_budget_total, 0) 08_sales_budget_total,
      IFNULL(divAchievement08.08_amount_of_sales_total, 0) 08_amount_of_sales_total,(
        IFNULL(08_amount_of_sales_total, 0) - IFNULL(08_sales_budget_total, 0)
      ) 08_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 08_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202208"
        GROUP BY
          supervising_department
      ) divBudget08
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 08_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202208"
        GROUP BY
          business_sector
      ) divAchievement08 ON divBudget08.supervising_department = divAchievement08.business_sector
    UNION
    SELECT
      IFNULL(divAchievement08.business_sector, "") business_sector,
      IFNULL(divBudget08.08_sales_budget_total, 0) 08_sales_budget_total,
      IFNULL(divAchievement08.08_amount_of_sales_total, 0) 08_amount_of_sales_total,
      IFNULL(08_amount_of_sales_total, 0) - IFNULL(08_sales_budget_total, 0) 08_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 08_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202208"
        GROUP BY
          supervising_department
      ) divBudget08
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 08_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202208"
        GROUP BY
          business_sector
      ) divAchievement08 ON divBudget08.supervising_department = divAchievement08.business_sector
  ) div08monthDiff ON divfullyearDiff.business_sector = div08monthDiff.supervising_department
  LEFT JOIN --202209
  (
    SELECT
      IFNULL(divBudget09.supervising_department, "") supervising_department,
      IFNULL(divBudget09.09_sales_budget_total, 0) 09_sales_budget_total,
      IFNULL(divAchievement09.09_amount_of_sales_total, 0) 09_amount_of_sales_total,(
        IFNULL(09_amount_of_sales_total, 0) - IFNULL(09_sales_budget_total, 0)
      ) 09_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 09_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202209"
        GROUP BY
          supervising_department
      ) divBudget09
      LEFT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 09_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202209"
        GROUP BY
          business_sector
      ) divAchievement09 ON divBudget09.supervising_department = divAchievement09.business_sector
    UNION
    SELECT
      IFNULL(divAchievement09.business_sector, "") business_sector,
      IFNULL(divBudget09.09_sales_budget_total, 0) 09_sales_budget_total,
      IFNULL(divAchievement09.09_amount_of_sales_total, 0) 09_amount_of_sales_total,
      IFNULL(09_amount_of_sales_total, 0) - IFNULL(09_sales_budget_total, 0) 08_difference_total
    FROM
      (
        SELECT
          supervising_department,
          sum(sales_budget) 09_sales_budget_total
        FROM
          sales_budget
        WHERE
          accounting_month = "202209"
        GROUP BY
          supervising_department
      ) divBudget09
      RIGHT JOIN (
        SELECT
          business_sector,
          sum(amount_of_sales) 09_amount_of_sales_total
        FROM
          sales_achievement
        WHERE
          accounting_month = "202209"
        GROUP BY
          business_sector
      ) divAchievement09 ON divBudget09.supervising_department = divAchievement09.business_sector
  ) div09monthDiff ON divfullyearDiff.business_sector = div09monthDiff.supervising_department
ORDER BY
  divfullyearDiff.full_year_difference_total asc;