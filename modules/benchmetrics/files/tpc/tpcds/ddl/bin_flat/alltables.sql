create database if not exists ${DB};
use ${DB};

!echo START EXECUTE etl tpcds convert;
!date +%s.%N;

drop table if exists call_center;
create table call_center
stored as ${FILE}
as select * from ${SOURCE}.call_center;

drop table if exists catalog_page;
create table catalog_page
stored as ${FILE}
as select * from ${SOURCE}.catalog_page;

drop table if exists catalog_returns;
create table catalog_returns
stored as ${FILE}
as select * from ${SOURCE}.catalog_returns;

drop table if exists catalog_sales;
create table catalog_sales
stored as ${FILE}
as select * from ${SOURCE}.catalog_sales;

drop table if exists customer;
create table customer
stored as ${FILE}
as select * from ${SOURCE}.customer;

drop table if exists customer_address;
create table customer_address
stored as ${FILE}
as select * from ${SOURCE}.customer_address;

drop table if exists customer_demographics;
create table customer_demographics
stored as ${FILE}
as select * from ${SOURCE}.customer_demographics;

drop table if exists date_dim;
create table date_dim
stored as ${FILE}
as select * from ${SOURCE}.date_dim;

drop table if exists household_demographics;
create table household_demographics
stored as ${FILE}
as select * from ${SOURCE}.household_demographics;

drop table if exists income_band;
create table income_band
stored as ${FILE}
as select * from ${SOURCE}.income_band;

drop table if exists inventory;
create table inventory
stored as ${FILE}
as select * from ${SOURCE}.inventory;

drop table if exists item;
create table item
stored as ${FILE}
as select * from ${SOURCE}.item;

drop table if exists promotion;
create table promotion
stored as ${FILE}
as select * from ${SOURCE}.promotion;

drop table if exists reason;
create table reason
stored as ${FILE}
as select * from ${SOURCE}.reason;

drop table if exists ship_mode;
create table ship_mode
stored as ${FILE}
as select * from ${SOURCE}.ship_mode;

drop table if exists store;
create table store
stored as ${FILE}
as select * from ${SOURCE}.store;

drop table if exists store_returns;
create table store_returns
stored as ${FILE}
as select * from ${SOURCE}.store_returns;

drop table if exists store_sales;
create table store_sales
stored as ${FILE}
as select * from ${SOURCE}.store_sales;

drop table if exists time_dim;
create table time_dim
stored as ${FILE}
as select * from ${SOURCE}.time_dim;

drop table if exists warehouse;
create table warehouse
stored as ${FILE}
as select * from ${SOURCE}.warehouse;

drop table if exists web_page;
create table web_page
stored as ${FILE}
as select * from ${SOURCE}.web_page;

drop table if exists web_returns;
create table web_returns
stored as ${FILE}
as select * from ${SOURCE}.web_returns;

drop table if exists web_sales;
create table web_sales
stored as ${FILE}
as select * from ${SOURCE}.web_sales;

drop table if exists web_site;
create table web_site
stored as ${FILE}
as select * from ${SOURCE}.web_site;

!echo FINISH EXECUTE etl tpcds convert;
!date +%s.%N;

!echo START EXECUTE etl tpcds stats;
!date +%s.%N;

analyze table call_center compute statistics for columns;
analyze table catalog_page compute statistics for columns;
analyze table catalog_returns compute statistics for columns;
analyze table catalog_sales compute statistics for columns;
analyze table customer compute statistics for columns;
analyze table customer_address compute statistics for columns;
analyze table customer_demographics compute statistics for columns;
analyze table date_dim compute statistics for columns;
analyze table household_demographics compute statistics for columns;
analyze table income_band compute statistics for columns;
analyze table inventory compute statistics for columns;
analyze table item compute statistics for columns;
analyze table promotion compute statistics for columns;
analyze table reason compute statistics for columns;
analyze table ship_mode compute statistics for columns;
analyze table store compute statistics for columns;
analyze table store_returns compute statistics for columns;
analyze table store_sales compute statistics for columns;
analyze table time_dim compute statistics for columns;
analyze table warehouse compute statistics for columns;
analyze table web_page compute statistics for columns;
analyze table web_returns compute statistics for columns;
analyze table web_sales compute statistics for columns;
analyze table web_site compute statistics for columns;

!echo FINISH EXECUTE etl tpcds stats;
!date +%s.%N;
