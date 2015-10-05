create database if not exists foodmart;
use foodmart;

DROP TABLE IF EXISTS sales_fact_1997;
CREATE TABLE sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.sales_fact_1997;

DROP TABLE IF EXISTS sales_fact_1998;
CREATE TABLE sales_fact_1998
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.sales_fact_1998;

DROP TABLE IF EXISTS sales_fact_dec_1998;
CREATE TABLE sales_fact_dec_1998
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.sales_fact_dec_1998;

DROP TABLE IF EXISTS inventory_fact_1997;
CREATE TABLE inventory_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.inventory_fact_1997;

DROP TABLE IF EXISTS inventory_fact_1998;
CREATE TABLE inventory_fact_1998
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.inventory_fact_1998;

DROP TABLE IF EXISTS agg_pl_01_sales_fact_1997;
CREATE TABLE agg_pl_01_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_pl_01_sales_fact_1997;

DROP TABLE IF EXISTS agg_ll_01_sales_fact_1997;
CREATE TABLE agg_ll_01_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_ll_01_sales_fact_1997;

DROP TABLE IF EXISTS agg_l_03_sales_fact_1997;
CREATE TABLE agg_l_03_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_l_03_sales_fact_1997;

DROP TABLE IF EXISTS agg_l_04_sales_fact_1997;
CREATE TABLE agg_l_04_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_l_04_sales_fact_1997;

DROP TABLE IF EXISTS agg_l_05_sales_fact_1997;
CREATE TABLE agg_l_05_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_l_05_sales_fact_1997;

DROP TABLE IF EXISTS agg_c_10_sales_fact_1997;
CREATE TABLE agg_c_10_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_c_10_sales_fact_1997;

DROP TABLE IF EXISTS agg_c_14_sales_fact_1997;
CREATE TABLE agg_c_14_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_c_14_sales_fact_1997;

DROP TABLE IF EXISTS agg_lc_100_sales_fact_1997;
CREATE TABLE agg_lc_100_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_lc_100_sales_fact_1997;

DROP TABLE IF EXISTS agg_c_special_sales_fact_1997;
CREATE TABLE agg_c_special_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_c_special_sales_fact_1997;

DROP TABLE IF EXISTS agg_g_ms_pcat_sales_fact_1997;
CREATE TABLE agg_g_ms_pcat_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_g_ms_pcat_sales_fact_1997;

DROP TABLE IF EXISTS agg_lc_06_sales_fact_1997;
CREATE TABLE agg_lc_06_sales_fact_1997
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.agg_lc_06_sales_fact_1997;

DROP TABLE IF EXISTS currency;
CREATE TABLE currency
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.currency;

DROP TABLE IF EXISTS account;
CREATE TABLE account
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.account;

DROP TABLE IF EXISTS category;
CREATE TABLE category
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.category;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.customer;

DROP TABLE IF EXISTS days;
CREATE TABLE days
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.days;

DROP TABLE IF EXISTS department;
CREATE TABLE department
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.department;

DROP TABLE IF EXISTS employee;
CREATE TABLE employee
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.employee;

DROP TABLE IF EXISTS employee_closure;
CREATE TABLE employee_closure
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.employee_closure;

DROP TABLE IF EXISTS expense_fact;
CREATE TABLE expense_fact
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.expense_fact;

DROP TABLE IF EXISTS position;
CREATE TABLE position
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.position;

DROP TABLE IF EXISTS product;
CREATE TABLE product
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.product;

DROP TABLE IF EXISTS product_class;
CREATE TABLE product_class
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.product_class;

DROP TABLE IF EXISTS promotion;
CREATE TABLE promotion
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.promotion;

DROP TABLE IF EXISTS region;
CREATE TABLE region
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.region;

DROP TABLE IF EXISTS reserve_employee;
CREATE TABLE reserve_employee
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.reserve_employee;

DROP TABLE IF EXISTS salary;
CREATE TABLE salary
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.salary;

DROP TABLE IF EXISTS store;
CREATE TABLE store
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.store;

DROP TABLE IF EXISTS store_ragged;
CREATE TABLE store_ragged
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.store_ragged;

DROP TABLE IF EXISTS time_by_day;
CREATE TABLE time_by_day
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.time_by_day;

DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.warehouse;

DROP TABLE IF EXISTS warehouse_class;
CREATE TABLE warehouse_class
stored as orc tblproperties ("orc.compress"="SNAPPY")
as select * from foodmart_stage.warehouse_class;

