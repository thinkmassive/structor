create database if not exists foodmart;
use foodmart;

DROP TABLE IF EXISTS sales_fact_1997;
CREATE EXTERNAL TABLE sales_fact_1997(product_id INT,time_id INT,customer_id INT,promotion_id INT,store_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS sales_fact_1998;
CREATE EXTERNAL TABLE sales_fact_1998(product_id INT,time_id INT,customer_id INT,promotion_id INT,store_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/sales_fact_1998'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS sales_fact_dec_1998;
CREATE EXTERNAL TABLE sales_fact_dec_1998(product_id INT,time_id INT,customer_id INT,promotion_id INT,store_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/sales_fact_dec_1998'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS inventory_fact_1997;
CREATE EXTERNAL TABLE inventory_fact_1997(product_id INT,time_id INT,warehouse_id INT,store_id INT,units_ordered INT,units_shipped INT,warehouse_sales DECIMAL(10,4),warehouse_cost DECIMAL(10,4),supply_time SMALLINT,store_invoice DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/inventory_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS inventory_fact_1998;
CREATE EXTERNAL TABLE inventory_fact_1998(product_id INT,time_id INT,warehouse_id INT,store_id INT,units_ordered INT,units_shipped INT,warehouse_sales DECIMAL(10,4),warehouse_cost DECIMAL(10,4),supply_time SMALLINT,store_invoice DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/inventory_fact_1998'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_pl_01_sales_fact_1997;
CREATE EXTERNAL TABLE agg_pl_01_sales_fact_1997(product_id INT,time_id INT,customer_id INT,store_sales_sum DECIMAL(10,4),store_cost_sum DECIMAL(10,4),unit_sales_sum DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_pl_01_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_ll_01_sales_fact_1997;
CREATE EXTERNAL TABLE agg_ll_01_sales_fact_1997(product_id INT,time_id INT,customer_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_ll_01_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_l_03_sales_fact_1997;
CREATE EXTERNAL TABLE agg_l_03_sales_fact_1997(time_id INT,customer_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_l_03_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_l_04_sales_fact_1997;
CREATE EXTERNAL TABLE agg_l_04_sales_fact_1997(time_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),customer_count INT,fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_l_04_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_l_05_sales_fact_1997;
CREATE EXTERNAL TABLE agg_l_05_sales_fact_1997(product_id INT,customer_id INT,promotion_id INT,store_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_l_05_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_c_10_sales_fact_1997;
CREATE EXTERNAL TABLE agg_c_10_sales_fact_1997(month_of_year SMALLINT,quarter VARCHAR(30),the_year SMALLINT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),customer_count INT,fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_c_10_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_c_14_sales_fact_1997;
CREATE EXTERNAL TABLE agg_c_14_sales_fact_1997(product_id INT,customer_id INT,store_id INT,promotion_id INT,month_of_year SMALLINT,quarter VARCHAR(30),the_year SMALLINT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_c_14_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_lc_100_sales_fact_1997;
CREATE EXTERNAL TABLE agg_lc_100_sales_fact_1997(product_id INT,customer_id INT,quarter VARCHAR(30),the_year SMALLINT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_lc_100_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_c_special_sales_fact_1997;
CREATE EXTERNAL TABLE agg_c_special_sales_fact_1997(product_id INT,promotion_id INT,customer_id INT,store_id INT,time_month SMALLINT,time_quarter VARCHAR(30),time_year SMALLINT,store_sales_sum DECIMAL(10,4),store_cost_sum DECIMAL(10,4),unit_sales_sum DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_c_special_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_g_ms_pcat_sales_fact_1997;
CREATE EXTERNAL TABLE agg_g_ms_pcat_sales_fact_1997(gender VARCHAR(30),marital_status VARCHAR(30),product_family VARCHAR(30),product_department VARCHAR(30),product_category VARCHAR(30),month_of_year SMALLINT,quarter VARCHAR(30),the_year SMALLINT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),customer_count INT,fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_g_ms_pcat_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS agg_lc_06_sales_fact_1997;
CREATE EXTERNAL TABLE agg_lc_06_sales_fact_1997(time_id INT,city VARCHAR(30),state_province VARCHAR(30),country VARCHAR(30),store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/agg_lc_06_sales_fact_1997'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS currency;
CREATE EXTERNAL TABLE currency(currency_id INT,`date` DATE,currency VARCHAR(30),conversion_ratio DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/currency'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS account;
CREATE EXTERNAL TABLE account(account_id INT,account_parent INT,account_description VARCHAR(30),account_type VARCHAR(30),account_rollup VARCHAR(30),Custom_Members VARCHAR(255))
stored as orc
location '/apps/hive/warehouse/foodmart.db/account'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS category;
CREATE EXTERNAL TABLE category(category_id VARCHAR(30),category_parent VARCHAR(30),category_description VARCHAR(30),category_rollup VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/category'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS customer;
CREATE EXTERNAL TABLE customer(customer_id INT,account_num BIGINT,lname VARCHAR(30),fname VARCHAR(30),mi VARCHAR(30),address1 VARCHAR(30),address2 VARCHAR(30),address3 VARCHAR(30),address4 VARCHAR(30),city VARCHAR(30),state_province VARCHAR(30),postal_code VARCHAR(30),country VARCHAR(30),customer_region_id INT,phone1 VARCHAR(30),phone2 VARCHAR(30),birthdate DATE,marital_status VARCHAR(30),yearly_income VARCHAR(30),gender VARCHAR(30),total_children SMALLINT,num_children_at_home SMALLINT,education VARCHAR(30),date_accnt_opened DATE,member_card VARCHAR(30),occupation VARCHAR(30),houseowner VARCHAR(30),num_cars_owned INT,fullname VARCHAR(60))
stored as orc
location '/apps/hive/warehouse/foodmart.db/customer'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS days;
CREATE EXTERNAL TABLE days(day INT,week_day VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/days'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS department;
CREATE EXTERNAL TABLE department(department_id INT,department_description VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/department'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS employee;
CREATE EXTERNAL TABLE employee(employee_id INT,full_name VARCHAR(30),first_name VARCHAR(30),last_name VARCHAR(30),position_id INT,position_title VARCHAR(30),store_id INT,department_id INT,birth_date DATE,hire_date TIMESTAMP,end_date TIMESTAMP,salary DECIMAL(10,4),supervisor_id INT,education_level VARCHAR(30),marital_status VARCHAR(30),gender VARCHAR(30),management_role VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/employee'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS employee_closure;
CREATE EXTERNAL TABLE employee_closure(employee_id INT,supervisor_id INT,distance INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/employee_closure'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS expense_fact;
CREATE EXTERNAL TABLE expense_fact(store_id INT,account_id INT,exp_date TIMESTAMP,time_id INT,category_id VARCHAR(30),currency_id INT,amount DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/expense_fact'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS position;
CREATE EXTERNAL TABLE position(position_id INT,position_title VARCHAR(30),pay_type VARCHAR(30),min_scale DECIMAL(10,4),max_scale DECIMAL(10,4),management_role VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/position'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS product;
CREATE EXTERNAL TABLE product(product_class_id INT,product_id INT,brand_name VARCHAR(60),product_name VARCHAR(60),SKU BIGINT,SRP DECIMAL(10,4),gross_weight DOUBLE,net_weight DOUBLE,recyclable_package BOOLEAN,low_fat BOOLEAN,units_per_case SMALLINT,cases_per_pallet SMALLINT,shelf_width DOUBLE,shelf_height DOUBLE,shelf_depth DOUBLE)
stored as orc
location '/apps/hive/warehouse/foodmart.db/product'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS product_class;
CREATE EXTERNAL TABLE product_class(product_class_id INT,product_subcategory VARCHAR(30),product_category VARCHAR(30),product_department VARCHAR(30),product_family VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/product_class'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS promotion;
CREATE EXTERNAL TABLE promotion(promotion_id INT,promotion_district_id INT,promotion_name VARCHAR(30),media_type VARCHAR(30),cost DECIMAL(10,4),start_date TIMESTAMP,end_date TIMESTAMP)
stored as orc
location '/apps/hive/warehouse/foodmart.db/promotion'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS region;
CREATE EXTERNAL TABLE region(region_id INT,sales_city VARCHAR(30),sales_state_province VARCHAR(30),sales_district VARCHAR(30),sales_region VARCHAR(30),sales_country VARCHAR(30),sales_district_id INT)
stored as orc
location '/apps/hive/warehouse/foodmart.db/region'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS reserve_employee;
CREATE EXTERNAL TABLE reserve_employee(employee_id INT,full_name VARCHAR(30),first_name VARCHAR(30),last_name VARCHAR(30),position_id INT,position_title VARCHAR(30),store_id INT,department_id INT,birth_date TIMESTAMP,hire_date TIMESTAMP,end_date TIMESTAMP,salary DECIMAL(10,4),supervisor_id INT,education_level VARCHAR(30),marital_status VARCHAR(30),gender VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/reserve_employee'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS salary;
CREATE EXTERNAL TABLE salary(pay_date TIMESTAMP,employee_id INT,department_id INT,currency_id INT,salary_paid DECIMAL(10,4),overtime_paid DECIMAL(10,4),vacation_accrued DOUBLE,vacation_used DOUBLE)
stored as orc
location '/apps/hive/warehouse/foodmart.db/salary'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS store;
CREATE EXTERNAL TABLE store(store_id INT,store_type VARCHAR(30),region_id INT,store_name VARCHAR(30),store_number INT,store_street_address VARCHAR(30),store_city VARCHAR(30),store_state VARCHAR(30),store_postal_code VARCHAR(30),store_country VARCHAR(30),store_manager VARCHAR(30),store_phone VARCHAR(30),store_fax VARCHAR(30),first_opened_date TIMESTAMP,last_remodel_date TIMESTAMP,store_sqft INT,grocery_sqft INT,frozen_sqft INT,meat_sqft INT,coffee_bar BOOLEAN,video_store BOOLEAN,salad_bar BOOLEAN,prepared_food BOOLEAN,florist BOOLEAN)
stored as orc
location '/apps/hive/warehouse/foodmart.db/store'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS store_ragged;
CREATE EXTERNAL TABLE store_ragged(store_id INT,store_type VARCHAR(30),region_id INT,store_name VARCHAR(30),store_number INT,store_street_address VARCHAR(30),store_city VARCHAR(30),store_state VARCHAR(30),store_postal_code VARCHAR(30),store_country VARCHAR(30),store_manager VARCHAR(30),store_phone VARCHAR(30),store_fax VARCHAR(30),first_opened_date TIMESTAMP,last_remodel_date TIMESTAMP,store_sqft INT,grocery_sqft INT,frozen_sqft INT,meat_sqft INT,coffee_bar BOOLEAN,video_store BOOLEAN,salad_bar BOOLEAN,prepared_food BOOLEAN,florist BOOLEAN)
stored as orc
location '/apps/hive/warehouse/foodmart.db/store_ragged'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS time_by_day;
CREATE EXTERNAL TABLE time_by_day(time_id INT,the_date TIMESTAMP,the_day VARCHAR(30),the_month VARCHAR(30),the_year SMALLINT,day_of_month SMALLINT,week_of_year INT,month_of_year SMALLINT,quarter VARCHAR(30),fiscal_period VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/time_by_day'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS warehouse;
CREATE EXTERNAL TABLE warehouse(warehouse_id INT,warehouse_class_id INT,stores_id INT,warehouse_name VARCHAR(60),wa_address1 VARCHAR(30),wa_address2 VARCHAR(30),wa_address3 VARCHAR(30),wa_address4 VARCHAR(30),warehouse_city VARCHAR(30),warehouse_state_province VARCHAR(30),warehouse_postal_code VARCHAR(30),warehouse_country VARCHAR(30),warehouse_owner_name VARCHAR(30),warehouse_phone VARCHAR(30),warehouse_fax VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/warehouse'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS warehouse_class;
CREATE EXTERNAL TABLE warehouse_class(warehouse_class_id INT,description VARCHAR(30))
stored as orc
location '/apps/hive/warehouse/foodmart.db/warehouse_class'
tblproperties ("orc.compress"="SNAPPY");
