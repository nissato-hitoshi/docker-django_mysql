set character_set_database=utf8;

delete from sales_achievement where accounting_period = 43;

load data
infile '/workspace/output/43_202202_sales_achievement.csv'
into table sales_achievement
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20)
set created=now(), updated=now()
    , accounting_period=@1
    , project_code=@2
    , project_name=@3
    , client_name=@4
    , accounting_month=@5
    , sales_department=@6
    , business_sector=@7
    , supervising_department=@8
    , mount_of_sales=@9
    , material_cost=@10
    , labor_cost=@11
    , outsourcing_cost=@12
    , expenses=@13
    , cost_total=@14
    , gross_profit=@15
    , gross_profit_margin=@16
    , type_of_contract=@17
    , kinds=@18
    , project_parent_code=@19
    , project_parent_name=@20;
