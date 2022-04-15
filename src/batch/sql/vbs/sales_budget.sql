set character_set_database=cp932;
load data
infile '/workspace/output/43_1_sales_budget.csv'
into table sales_budget
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16)
set created=now(), updated=now(), accounting_period=@1, version=@2, sales_department=@3, classification=@4, sales_representative=@5, supervising_department=@6, client_name=@7, project_name=@8, operator=@9, accounting_month=@10, sales_budget=@11, sales_expected=@12, sales_achievement=@13, half_period=@14, quarter=@15, accuracy=@16;
