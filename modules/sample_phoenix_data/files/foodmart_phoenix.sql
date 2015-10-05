DROP TABLE IF EXISTS foodmart.sales_fact_1997;
CREATE TABLE foodmart.sales_fact_1997(product_id INTEGER not null,time_id INTEGER not null,customer_id INTEGER not null,promotion_id INTEGER,store_id INTEGER,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),
constraint sales_fact_1997_con primary key (product_id, time_id, customer_id));

DROP TABLE IF EXISTS foodmart.sales_fact_1998;
CREATE TABLE foodmart.sales_fact_1998(product_id INTEGER not null,time_id INTEGER not null,customer_id INTEGER not null,promotion_id INTEGER,store_id INTEGER,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),
constraint sales_fact_1998_con primary key (product_id, time_id, customer_id));

DROP TABLE IF EXISTS foodmart.sales_fact_dec_1998;
CREATE TABLE foodmart.sales_fact_dec_1998(product_id INTEGER not null,time_id INTEGER not null,customer_id INTEGER not null,promotion_id INTEGER,store_id INTEGER,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),
constraint sales_fact_dec_1998_con primary key (product_id, time_id, customer_id));

DROP TABLE IF EXISTS foodmart.inventory_fact_1997;
CREATE TABLE foodmart.inventory_fact_1997(product_id INTEGER not null,time_id INTEGER not null,warehouse_id INTEGER not null,store_id INTEGER not null,units_ordered INTEGER,units_shipped INTEGER,warehouse_sales DECIMAL(10,4),warehouse_cost DECIMAL(10,4),supply_time SMALLINT,store_invoice DECIMAL(10,4),
constraint inventory_fact_1997_con primary key (product_id, time_id, warehouse_id, store_id));

DROP TABLE IF EXISTS foodmart.inventory_fact_1998;
CREATE TABLE foodmart.inventory_fact_1998(product_id INTEGER not null,time_id INTEGER not null,warehouse_id INTEGER not null,store_id INTEGER not null,units_ordered INTEGER,units_shipped INTEGER,warehouse_sales DECIMAL(10,4),warehouse_cost DECIMAL(10,4),supply_time SMALLINT,store_invoice DECIMAL(10,4),
constraint inventory_fact_1998_con primary key (product_id, time_id, warehouse_id, store_id));

DROP TABLE IF EXISTS foodmart.agg_pl_01_sales_fact_1997;
CREATE TABLE foodmart.agg_pl_01_sales_fact_1997(product_id INTEGER not null,time_id INTEGER not null,customer_id INTEGER not null,store_sales_sum DECIMAL(10,4),store_cost_sum DECIMAL(10,4),unit_sales_sum DECIMAL(10,4),fact_count INTEGER,
constraint agg_pl_01_sales_fact_1997_con primary key (product_id, time_id, customer_id));

DROP TABLE IF EXISTS foodmart.agg_ll_01_sales_fact_1997;
CREATE TABLE foodmart.agg_ll_01_sales_fact_1997(product_id INTEGER not null,time_id INTEGER not null,customer_id INTEGER not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INTEGER,
constraint agg_ll_01_sales_fact_1997_con primary key (product_id, time_id, customer_id));

DROP TABLE IF EXISTS foodmart.agg_l_03_sales_fact_1997;
CREATE TABLE foodmart.agg_l_03_sales_fact_1997(time_id INTEGER not null,customer_id INTEGER not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INTEGER,
constraint agg_l_03_sales_fact_1997_con primary key (time_id, customer_id));

DROP TABLE IF EXISTS foodmart.agg_l_04_sales_fact_1997;
CREATE TABLE foodmart.agg_l_04_sales_fact_1997(time_id INTEGER not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),customer_count INTEGER,fact_count INTEGER not null,
constraint agg_l_04_sales_fact_1997_con primary key (time_id, fact_count));

DROP TABLE IF EXISTS foodmart.agg_l_05_sales_fact_1997;
CREATE TABLE foodmart.agg_l_05_sales_fact_1997(product_id INTEGER not null,customer_id INTEGER not null,promotion_id INTEGER not null,store_id INTEGER not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INTEGER,
constraint agg_l_05_sales_fact_1997_con primary key (product_id, customer_id, promotion_id, store_id));

DROP TABLE IF EXISTS foodmart.agg_c_10_sales_fact_1997;
CREATE TABLE foodmart.agg_c_10_sales_fact_1997(month_of_year SMALLINT not null,quarter VARCHAR(30) not null,the_year SMALLINT not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),customer_count INTEGER,fact_count INTEGER,
constraint agg_c_10_sales_fact_1997_con primary key (month_of_year, quarter, the_year));

DROP TABLE IF EXISTS foodmart.agg_c_14_sales_fact_1997;
CREATE TABLE foodmart.agg_c_14_sales_fact_1997(product_id INTEGER not null,customer_id INTEGER not null,store_id INTEGER not null,promotion_id INTEGER not null,month_of_year SMALLINT not null,quarter VARCHAR(30),the_year SMALLINT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INTEGER,
constraint agg_c_14_sales_fact_1997_con primary key (product_id, customer_id, store_id, promotion_id, month_of_year));

DROP TABLE IF EXISTS foodmart.agg_lc_100_sales_fact_1997;
CREATE TABLE foodmart.agg_lc_100_sales_fact_1997(product_id INTEGER not null,customer_id INTEGER not null,quarter VARCHAR(30) not null,the_year SMALLINT not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INTEGER,
constraint agg_lc_100_sales_fact_1997_con primary key (product_id, customer_id, quarter, the_year));

DROP TABLE IF EXISTS foodmart.agg_c_special_sales_fact_1997;
CREATE TABLE foodmart.agg_c_special_sales_fact_1997(product_id INTEGER not null,promotion_id INTEGER not null,customer_id INTEGER not null,store_id INTEGER not null,time_month SMALLINT not null,time_quarter VARCHAR(30) not null,time_year SMALLINT not null,store_sales_sum DECIMAL(10,4),store_cost_sum DECIMAL(10,4),unit_sales_sum DECIMAL(10,4),fact_count INTEGER,
constraint agg_c_special_sales_fact_1997_con primary key (product_id, promotion_id, customer_id, store_id, time_month, time_quarter, time_year));

DROP TABLE IF EXISTS foodmart.agg_g_ms_pcat_sales_fact_1997;
CREATE TABLE foodmart.agg_g_ms_pcat_sales_fact_1997(gender VARCHAR(30) not null,marital_status VARCHAR(30) not null,product_family VARCHAR(30) not null,product_department VARCHAR(30) not null,product_category VARCHAR(30) not null,month_of_year SMALLINT not null,quarter VARCHAR(30) not null,the_year SMALLINT not null,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),customer_count INTEGER not null,fact_count INTEGER not null,
constraint agg_g_ms_pcat_sales_fact_1997_con primary key (gender, marital_status, product_family, product_department, product_category, month_of_year, quarter, the_year, customer_count, fact_count));

DROP TABLE IF EXISTS foodmart.agg_lc_06_sales_fact_1997;
CREATE TABLE foodmart.agg_lc_06_sales_fact_1997(time_id INTEGER not null,city VARCHAR(30) not null,state_province VARCHAR(30),country VARCHAR(30),store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4),fact_count INTEGER,
constraint agg_lc_06_sales_fact_1997_con primary key (time_id, city));

DROP TABLE IF EXISTS foodmart.currency;
CREATE TABLE foodmart.currency(currency_id INTEGER not null,date DATE not null,currency VARCHAR(30),conversion_ratio DECIMAL(10,4),
constraint currency_con primary key (currency_id, date));

DROP TABLE IF EXISTS foodmart.account;
CREATE TABLE foodmart.account(account_id INTEGER not null,account_parent INTEGER,account_description VARCHAR(30),account_type VARCHAR(30),account_rollup VARCHAR(30),Custom_Members VARCHAR(255),
constraint account_con primary key (account_id));

DROP TABLE IF EXISTS foodmart.category;
CREATE TABLE foodmart.category(category_id VARCHAR(30) not null,category_parent VARCHAR(30),category_description VARCHAR(30),category_rollup VARCHAR(30),
constraint category_con primary key (category_id));

DROP TABLE IF EXISTS foodmart.customer;
CREATE TABLE foodmart.customer(customer_id INTEGER not null,account_num BIGINT,lname VARCHAR(30),fname VARCHAR(30),mi VARCHAR(30),address1 VARCHAR(30),address2 VARCHAR(30),address3 VARCHAR(30),address4 VARCHAR(30),city VARCHAR(30),state_province VARCHAR(30),postal_code VARCHAR(30),country VARCHAR(30),customer_region_id INTEGER,phone1 VARCHAR(30),phone2 VARCHAR(30),birthdate DATE,marital_status VARCHAR(30),yearly_income VARCHAR(30),gender VARCHAR(30),total_children SMALLINT,num_children_at_home SMALLINT,education VARCHAR(30),date_accnt_opened DATE,member_card VARCHAR(30),occupation VARCHAR(30),houseowner VARCHAR(30),num_cars_owned INTEGER,fullname VARCHAR(60),
constraint customer_con primary key (customer_id));

DROP TABLE IF EXISTS foodmart.days;
CREATE TABLE foodmart.days(day INTEGER not null,week_day VARCHAR(30),
constraint days_con primary key (day));

DROP TABLE IF EXISTS foodmart.department;
CREATE TABLE foodmart.department(department_id INTEGER not null,department_description VARCHAR(30),
constraint department_con primary key (department_id));

DROP TABLE IF EXISTS foodmart.employee;
CREATE TABLE foodmart.employee(employee_id INTEGER not null,full_name VARCHAR(30),first_name VARCHAR(30),last_name VARCHAR(30),position_id INTEGER,position_title VARCHAR(30),store_id INTEGER,department_id INTEGER,birth_date DATE,hire_date TIMESTAMP,end_date TIMESTAMP,salary DECIMAL(10,4),supervisor_id INTEGER,education_level VARCHAR(30),marital_status VARCHAR(30),gender VARCHAR(30),management_role VARCHAR(30),
constraint employee_con primary key (employee_id));

DROP TABLE IF EXISTS foodmart.employee_closure;
CREATE TABLE foodmart.employee_closure(employee_id INTEGER not null,supervisor_id INTEGER,distance INTEGER,
constraint employee_closure_con primary key (employee_id));

DROP TABLE IF EXISTS foodmart.expense_fact;
CREATE TABLE foodmart.expense_fact(store_id INTEGER not null,account_id INTEGER,exp_date TIMESTAMP,time_id INTEGER not null,category_id VARCHAR(30),currency_id INTEGER,amount DECIMAL(10,4),
constraint expense_fact_con primary key (store_id, time_id));

DROP TABLE IF EXISTS foodmart.position;
CREATE TABLE foodmart.position(position_id INTEGER,position_title VARCHAR(30),pay_type VARCHAR(30),min_scale DECIMAL(10,4),max_scale DECIMAL(10,4),management_role VARCHAR(30),
constraint position_con primary key (position_id));

DROP TABLE IF EXISTS foodmart.product;
CREATE TABLE foodmart.product(product_class_id INTEGER,product_id INTEGER,brand_name VARCHAR(60),product_name VARCHAR(60),SKU BIGINT,SRP DECIMAL(10,4),gross_weight DOUBLE,net_weight DOUBLE,recyclable_package BOOLEAN,low_fat BOOLEAN,units_per_case SMALLINT,cases_per_pallet SMALLINT,shelf_width DOUBLE,shelf_height DOUBLE,shelf_depth DOUBLE,
constraint product_con primary key (product_id));

DROP TABLE IF EXISTS foodmart.product_class;
CREATE TABLE foodmart.product_class(product_class_id INTEGER,product_subcategory VARCHAR(30),product_category VARCHAR(30),product_department VARCHAR(30),product_family VARCHAR(30),
constraint product_class_con primary key (product_class_id));

DROP TABLE IF EXISTS foodmart.promotion;
CREATE TABLE foodmart.promotion(promotion_id INTEGER,promotion_district_id INTEGER,promotion_name VARCHAR(30),media_type VARCHAR(30),cost DECIMAL(10,4),start_date TIMESTAMP,end_date TIMESTAMP,
constraint promotion_con primary key (promotion_id));

DROP TABLE IF EXISTS foodmart.region;
CREATE TABLE foodmart.region(region_id INTEGER,sales_city VARCHAR(30),sales_state_province VARCHAR(30),sales_district VARCHAR(30),sales_region VARCHAR(30),sales_country VARCHAR(30),sales_district_id INTEGER,
constraint region_con primary key (region_id));

DROP TABLE IF EXISTS foodmart.reserve_employee;
CREATE TABLE foodmart.reserve_employee(employee_id INTEGER,full_name VARCHAR(30),first_name VARCHAR(30),last_name VARCHAR(30),position_id INTEGER,position_title VARCHAR(30),store_id INTEGER,department_id INTEGER,birth_date TIMESTAMP,hire_date TIMESTAMP,end_date TIMESTAMP,salary DECIMAL(10,4),supervisor_id INTEGER,education_level VARCHAR(30),marital_status VARCHAR(30),gender VARCHAR(30),
constraint reserve_employee_con primary key (employee_id));

DROP TABLE IF EXISTS foodmart.salary;
CREATE TABLE foodmart.salary(pay_date TIMESTAMP not null,employee_id INTEGER not null,department_id INTEGER,currency_id INTEGER,salary_paid DECIMAL(10,4),overtime_paid DECIMAL(10,4),vacation_accrued DOUBLE,vacation_used DOUBLE,
constraint salary_con primary key (pay_date, employee_id));

DROP TABLE IF EXISTS foodmart.store;
CREATE TABLE foodmart.store(store_id INTEGER,store_type VARCHAR(30),region_id INTEGER,store_name VARCHAR(30),store_number INTEGER,store_street_address VARCHAR(30),store_city VARCHAR(30),store_state VARCHAR(30),store_postal_code VARCHAR(30),store_country VARCHAR(30),store_manager VARCHAR(30),store_phone VARCHAR(30),store_fax VARCHAR(30),first_opened_date TIMESTAMP,last_remodel_date TIMESTAMP,store_sqft INTEGER,grocery_sqft INTEGER,frozen_sqft INTEGER,meat_sqft INTEGER,coffee_bar BOOLEAN,video_store BOOLEAN,salad_bar BOOLEAN,prepared_food BOOLEAN,florist BOOLEAN,
constraint store_con primary key (store_id));

DROP TABLE IF EXISTS foodmart.store_ragged;
CREATE TABLE foodmart.store_ragged(store_id INTEGER,store_type VARCHAR(30),region_id INTEGER,store_name VARCHAR(30),store_number INTEGER,store_street_address VARCHAR(30),store_city VARCHAR(30),store_state VARCHAR(30),store_postal_code VARCHAR(30),store_country VARCHAR(30),store_manager VARCHAR(30),store_phone VARCHAR(30),store_fax VARCHAR(30),first_opened_date TIMESTAMP,last_remodel_date TIMESTAMP,store_sqft INTEGER,grocery_sqft INTEGER,frozen_sqft INTEGER,meat_sqft INTEGER,coffee_bar BOOLEAN,video_store BOOLEAN,salad_bar BOOLEAN,prepared_food BOOLEAN,florist BOOLEAN,
constraint store_ragged_con primary key (store_id));

DROP TABLE IF EXISTS foodmart.time_by_day;
CREATE TABLE foodmart.time_by_day(time_id INTEGER,the_date TIMESTAMP,the_day VARCHAR(30),the_month VARCHAR(30),the_year SMALLINT,day_of_month SMALLINT,week_of_year INTEGER,month_of_year SMALLINT,quarter VARCHAR(30),fiscal_period VARCHAR(30),
constraint time_by_day_con primary key (time_id));

DROP TABLE IF EXISTS foodmart.warehouse;
CREATE TABLE foodmart.warehouse(warehouse_id INTEGER,warehouse_class_id INTEGER,stores_id INTEGER,warehouse_name VARCHAR(60),wa_address1 VARCHAR(30),wa_address2 VARCHAR(30),wa_address3 VARCHAR(30),wa_address4 VARCHAR(30),warehouse_city VARCHAR(30),warehouse_state_province VARCHAR(30),warehouse_postal_code VARCHAR(30),warehouse_country VARCHAR(30),warehouse_owner_name VARCHAR(30),warehouse_phone VARCHAR(30),warehouse_fax VARCHAR(30),
constraint warehouse_con primary key (warehouse_id));

DROP TABLE IF EXISTS foodmart.warehouse_class;
CREATE TABLE foodmart.warehouse_class(warehouse_class_id INTEGER,description VARCHAR(30),
constraint warehouse_class_con primary key (warehouse_class_id));
