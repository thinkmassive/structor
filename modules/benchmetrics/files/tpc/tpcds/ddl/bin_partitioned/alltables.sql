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
(
    cr_returned_time_sk       int,
    cr_item_sk                int,
    cr_refunded_customer_sk   int,
    cr_refunded_cdemo_sk      int,
    cr_refunded_hdemo_sk      int,
    cr_refunded_addr_sk       int,
    cr_returning_customer_sk  int,
    cr_returning_cdemo_sk     int,
    cr_returning_hdemo_sk     int,
    cr_returning_addr_sk      int,
    cr_call_center_sk         int,
    cr_catalog_page_sk        int,
    cr_ship_mode_sk           int,
    cr_warehouse_sk           int,
    cr_reason_sk              int,
    cr_order_number           int,
    cr_return_quantity        int,
    cr_return_amount          float,
    cr_return_tax             float,
    cr_return_amt_inc_tax     float,
    cr_fee                    float,
    cr_return_ship_cost       float,
    cr_refunded_cash          float,
    cr_reversed_charge        float,
    cr_store_credit           float,
    cr_net_loss               float
)
partitioned by (cr_returned_date_sk int)
stored as ${FILE};

insert overwrite table catalog_returns partition (cr_returned_date_sk) 
select
        cr.cr_returned_time_sk,
        cr.cr_item_sk,
        cr.cr_refunded_customer_sk,
        cr.cr_refunded_cdemo_sk,
        cr.cr_refunded_hdemo_sk,
        cr.cr_refunded_addr_sk,
        cr.cr_returning_customer_sk,
        cr.cr_returning_cdemo_sk,
        cr.cr_returning_hdemo_sk,
        cr.cr_returning_addr_sk,
        cr.cr_call_center_sk,
        cr.cr_catalog_page_sk,
        cr.cr_ship_mode_sk,
        cr.cr_warehouse_sk,
        cr.cr_reason_sk,
        cr.cr_order_number,
        cr.cr_return_quantity,
        cr.cr_return_amount,
        cr.cr_return_tax,
        cr.cr_return_amt_inc_tax,
        cr.cr_fee,
        cr.cr_return_ship_cost,
        cr.cr_refunded_cash,
        cr.cr_reversed_charge,
        cr.cr_store_credit,
        cr.cr_net_loss,
		cr.cr_returned_date_sk
      from ${SOURCE}.catalog_returns cr;

drop table if exists catalog_sales;
create table catalog_sales
(
    cs_sold_time_sk           int,
    cs_ship_date_sk           int,
    cs_bill_customer_sk       int,
    cs_bill_cdemo_sk          int,
    cs_bill_hdemo_sk          int,
    cs_bill_addr_sk           int,
    cs_ship_customer_sk       int,
    cs_ship_cdemo_sk          int,
    cs_ship_hdemo_sk          int,
    cs_ship_addr_sk           int,
    cs_call_center_sk         int,
    cs_catalog_page_sk        int,
    cs_ship_mode_sk           int,
    cs_warehouse_sk           int,
    cs_item_sk                int,
    cs_promo_sk               int,
    cs_order_number           int,
    cs_quantity               int,
    cs_wholesale_cost         float,
    cs_list_price             float,
    cs_sales_price            float,
    cs_ext_discount_amt       float,
    cs_ext_sales_price        float,
    cs_ext_wholesale_cost     float,
    cs_ext_list_price         float,
    cs_ext_tax                float,
    cs_coupon_amt             float,
    cs_ext_ship_cost          float,
    cs_net_paid               float,
    cs_net_paid_inc_tax       float,
    cs_net_paid_inc_ship      float,
    cs_net_paid_inc_ship_tax  float,
    cs_net_profit             float
)
partitioned by (cs_sold_date_sk int)
stored as ${FILE};

insert overwrite table catalog_sales partition (cs_sold_date_sk) 
select
        cs.cs_sold_time_sk,
        cs.cs_ship_date_sk,
        cs.cs_bill_customer_sk,
        cs.cs_bill_cdemo_sk,
        cs.cs_bill_hdemo_sk,
        cs.cs_bill_addr_sk,
        cs.cs_ship_customer_sk,
        cs.cs_ship_cdemo_sk,
        cs.cs_ship_hdemo_sk,
        cs.cs_ship_addr_sk,
        cs.cs_call_center_sk,
        cs.cs_catalog_page_sk,
        cs.cs_ship_mode_sk,
        cs.cs_warehouse_sk,
        cs.cs_item_sk,
        cs.cs_promo_sk,
        cs.cs_order_number,
        cs.cs_quantity,
        cs.cs_wholesale_cost,
        cs.cs_list_price,
        cs.cs_sales_price,
        cs.cs_ext_discount_amt,
        cs.cs_ext_sales_price,
        cs.cs_ext_wholesale_cost,
        cs.cs_ext_list_price,
        cs.cs_ext_tax,
        cs.cs_coupon_amt,
        cs.cs_ext_ship_cost,
        cs.cs_net_paid,
        cs.cs_net_paid_inc_tax,
        cs.cs_net_paid_inc_ship,
        cs.cs_net_paid_inc_ship_tax,
        cs.cs_net_profit,
        cs.cs_sold_date_sk
      from ${SOURCE}.catalog_sales cs;

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
(
    inv_date_sk         int,
    inv_item_sk          int,
    inv_warehouse_sk		int,
    inv_quantity_on_hand	int
)
partitioned by (inv_date string)
stored as ${FILE};

insert overwrite table inventory partition (inv_date)
select
	i.inv_date_sk,
	i.inv_item_sk,
	i.inv_warehouse_sk,
	i.inv_quantity_on_hand,
	d.d_date as inv_date
  from ${SOURCE}.inventory i
  join ${SOURCE}.date_dim d
  on (d.d_date_sk = i.inv_date_sk);

drop table if exists item;
create table item
(
    i_item_sk                 int,
    i_item_id                 string,
    i_rec_start_date          string,
    i_rec_end_date            string,
    i_item_desc               string,
    i_current_price           float,
    i_wholesale_cost          float,
    i_brand_id                int,
    i_brand                   string,
    i_class_id                int,
    i_class                   string,
    i_category_id             int,
    i_category                string,
    i_manufact_id             int,
    i_manufact                string,
    i_size                    string,
    i_formulation             string,
    i_color                   string,
    i_units                   string,
    i_container               string,
    i_manager_id              int,
    i_product_name            string
)
stored as ${FILE};

insert overwrite table item
select * from ${SOURCE}.item;

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
(
    sr_return_time_sk         int,
    sr_item_sk                int,
    sr_customer_sk            int,
    sr_cdemo_sk               int,
    sr_hdemo_sk               int,
    sr_addr_sk                int,
    sr_store_sk               int,
    sr_reason_sk              int,
    sr_ticket_number          int,
    sr_return_quantity        int,
    sr_return_amt             float,
    sr_return_tax             float,
    sr_return_amt_inc_tax     float,
    sr_fee                    float,
    sr_return_ship_cost       float,
    sr_refunded_cash          float,
    sr_reversed_charge        float,
    sr_store_credit           float,
    sr_net_loss               float
)
partitioned by (sr_returned_date_sk int)
stored as ${FILE};

insert overwrite table store_returns partition (sr_returned_date_sk) 
select
        sr.sr_return_time_sk,
        sr.sr_item_sk,
        sr.sr_customer_sk,
        sr.sr_cdemo_sk,
        sr.sr_hdemo_sk,
        sr.sr_addr_sk,
        sr.sr_store_sk,
        sr.sr_reason_sk,
        sr.sr_ticket_number,
        sr.sr_return_quantity,
        sr.sr_return_amt,
        sr.sr_return_tax,
        sr.sr_return_amt_inc_tax,
        sr.sr_fee,
        sr.sr_return_ship_cost,
        sr.sr_refunded_cash,
        sr.sr_reversed_charge,
        sr.sr_store_credit,
        sr.sr_net_loss,
        sr.sr_returned_date_sk
      from ${SOURCE}.store_returns sr;

drop table if exists store_sales;
create table store_sales
(
    ss_sold_time_sk           int,
    ss_item_sk                int,
    ss_customer_sk            int,
    ss_cdemo_sk               int,
    ss_hdemo_sk               int,
    ss_addr_sk                int,
    ss_store_sk               int,
    ss_promo_sk               int,
    ss_ticket_number          int,
    ss_quantity               int,
    ss_wholesale_cost         float,
    ss_list_price             float,
    ss_sales_price            float,
    ss_ext_discount_amt       float,
    ss_ext_sales_price        float,
    ss_ext_wholesale_cost     float,
    ss_ext_list_price         float,
    ss_ext_tax                float,
    ss_coupon_amt             float,
    ss_net_paid               float,
    ss_net_paid_inc_tax       float,
    ss_net_profit             float
)
partitioned by (ss_sold_date_sk int)
stored as ${FILE};

insert overwrite table store_sales partition (ss_sold_date_sk) 
select
        ss.ss_sold_time_sk,
        ss.ss_item_sk,
        ss.ss_customer_sk,
        ss.ss_cdemo_sk,
        ss.ss_hdemo_sk,
        ss.ss_addr_sk,
        ss.ss_store_sk,
        ss.ss_promo_sk,
        ss.ss_ticket_number,
        ss.ss_quantity,
        ss.ss_wholesale_cost,
        ss.ss_list_price,
        ss.ss_sales_price,
        ss.ss_ext_discount_amt,
        ss.ss_ext_sales_price,
        ss.ss_ext_wholesale_cost,
        ss.ss_ext_list_price,
        ss.ss_ext_tax,
        ss.ss_coupon_amt,
        ss.ss_net_paid,
        ss.ss_net_paid_inc_tax,
        ss.ss_net_profit,
        ss.ss_sold_date_sk
      from ${SOURCE}.store_sales ss;

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
(
    wr_returned_time_sk       int,
    wr_item_sk                int,
    wr_refunded_customer_sk   int,
    wr_refunded_cdemo_sk      int,
    wr_refunded_hdemo_sk      int,
    wr_refunded_addr_sk       int,
    wr_returning_customer_sk  int,
    wr_returning_cdemo_sk     int,
    wr_returning_hdemo_sk     int,
    wr_returning_addr_sk      int,
    wr_web_page_sk            int,
    wr_reason_sk              int,
    wr_order_number           int,
    wr_return_quantity        int,
    wr_return_amt             float,
    wr_return_tax             float,
    wr_return_amt_inc_tax     float,
    wr_fee                    float,
    wr_return_ship_cost       float,
    wr_refunded_cash          float,
    wr_reversed_charge        float,
    wr_account_credit         float,
    wr_net_loss               float
)
partitioned by (wr_returned_date_sk       int)
stored as ${FILE};

insert overwrite table web_returns partition (wr_returned_date_sk)
select
        wr.wr_returned_time_sk,
        wr.wr_item_sk,
        wr.wr_refunded_customer_sk,
        wr.wr_refunded_cdemo_sk,
        wr.wr_refunded_hdemo_sk,
        wr.wr_refunded_addr_sk,
        wr.wr_returning_customer_sk,
        wr.wr_returning_cdemo_sk,
        wr.wr_returning_hdemo_sk,
        wr.wr_returning_addr_sk,
        wr.wr_web_page_sk,
        wr.wr_reason_sk,
        wr.wr_order_number,
        wr.wr_return_quantity,
        wr.wr_return_amt,
        wr.wr_return_tax,
        wr.wr_return_amt_inc_tax,
        wr.wr_fee,
        wr.wr_return_ship_cost,
        wr.wr_refunded_cash,
        wr.wr_reversed_charge,
        wr.wr_account_credit,
        wr.wr_net_loss,
		wr.wr_returned_date_sk
      from ${SOURCE}.web_returns wr;

drop table if exists web_sales;
create table web_sales
(
    ws_sold_time_sk           int,
    ws_ship_date_sk           int,
    ws_item_sk                int,
    ws_bill_customer_sk       int,
    ws_bill_cdemo_sk          int,
    ws_bill_hdemo_sk          int,
    ws_bill_addr_sk           int,
    ws_ship_customer_sk       int,
    ws_ship_cdemo_sk          int,
    ws_ship_hdemo_sk          int,
    ws_ship_addr_sk           int,
    ws_web_page_sk            int,
    ws_web_site_sk            int,
    ws_ship_mode_sk           int,
    ws_warehouse_sk           int,
    ws_promo_sk               int,
    ws_order_number           int,
    ws_quantity               int,
    ws_wholesale_cost         float,
    ws_list_price             float,
    ws_sales_price            float,
    ws_ext_discount_amt       float,
    ws_ext_sales_price        float,
    ws_ext_wholesale_cost     float,
    ws_ext_list_price         float,
    ws_ext_tax                float,
    ws_coupon_amt             float,
    ws_ext_ship_cost          float,
    ws_net_paid               float,
    ws_net_paid_inc_tax       float,
    ws_net_paid_inc_ship      float,
    ws_net_paid_inc_ship_tax  float,
    ws_net_profit             float
)
partitioned by (ws_sold_date_sk           int)
stored as ${FILE};

insert overwrite table web_sales partition (ws_sold_date_sk) 
select
        ws.ws_sold_time_sk,
        ws.ws_ship_date_sk,
        ws.ws_item_sk,
        ws.ws_bill_customer_sk,
        ws.ws_bill_cdemo_sk,
        ws.ws_bill_hdemo_sk,
        ws.ws_bill_addr_sk,
        ws.ws_ship_customer_sk,
        ws.ws_ship_cdemo_sk,
        ws.ws_ship_hdemo_sk,
        ws.ws_ship_addr_sk,
        ws.ws_web_page_sk,
        ws.ws_web_site_sk,
        ws.ws_ship_mode_sk,
        ws.ws_warehouse_sk,
        ws.ws_promo_sk,
        ws.ws_order_number,
        ws.ws_quantity,
        ws.ws_wholesale_cost,
        ws.ws_list_price,
        ws.ws_sales_price,
        ws.ws_ext_discount_amt,
        ws.ws_ext_sales_price,
        ws.ws_ext_wholesale_cost,
        ws.ws_ext_list_price,
        ws.ws_ext_tax,
        ws.ws_coupon_amt,
        ws.ws_ext_ship_cost,
        ws.ws_net_paid,
        ws.ws_net_paid_inc_tax,
        ws.ws_net_paid_inc_ship,
        ws.ws_net_paid_inc_ship_tax,
        ws.ws_net_profit,
        ws.ws_sold_date_sk
      from ${SOURCE}.web_sales ws;

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
