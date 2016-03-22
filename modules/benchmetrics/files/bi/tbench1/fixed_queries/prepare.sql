create database if not exists tpcds_bin_flat_10;
use tpcds_bin_flat_10;

drop table if exists call_center;
create table call_center(
      cc_call_center_sk         int
,     cc_call_center_id         string
,     cc_rec_start_date        string
,     cc_rec_end_date          string
,     cc_closed_date_sk         int
,     cc_open_date_sk           int
,     cc_name                   string
,     cc_class                  string
,     cc_employees              int
,     cc_sq_ft                  int
,     cc_hours                  string
,     cc_manager                string
,     cc_mkt_id                 int
,     cc_mkt_class              string
,     cc_mkt_desc               string
,     cc_market_manager         string
,     cc_division               int
,     cc_division_name          string
,     cc_company                int
,     cc_company_name           string
,     cc_street_number          string
,     cc_street_name            string
,     cc_street_type            string
,     cc_suite_number           string
,     cc_city                   string
,     cc_county                 string
,     cc_state                  string
,     cc_zip                    string
,     cc_country                string
,     cc_gmt_offset             float
,     cc_tax_percentage         float
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/call_center' INTO TABLE call_center;

drop table if exists customer_address;
create table customer_address
(
    ca_address_sk             int,
    ca_address_id             string,
    ca_street_number          string,
    ca_street_name            string,
    ca_street_type            string,
    ca_suite_number           string,
    ca_city                   string,
    ca_county                 string,
    ca_state                  string,
    ca_zip                    string,
    ca_country                string,
    ca_gmt_offset             float,
    ca_location_type          string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/customer_address' INTO TABLE customer_address;

drop table if exists customer_demographics;
create table customer_demographics
(
    cd_demo_sk                int,
    cd_gender                 string,
    cd_marital_status         string,
    cd_education_status       string,
    cd_purchase_estimate      int,
    cd_credit_rating          string,
    cd_dep_count              int,
    cd_dep_employed_count     int,
    cd_dep_college_count      int
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/customer_demographics' INTO TABLE customer_demographics;

drop table if exists customer;
create table customer
(
    c_customer_sk             int,
    c_customer_id             string,
    c_current_cdemo_sk        int,
    c_current_hdemo_sk        int,
    c_current_addr_sk         int,
    c_first_shipto_date_sk    int,
    c_first_sales_date_sk     int,
    c_salutation              string,
    c_first_name              string,
    c_last_name               string,
    c_preferred_cust_flag     string,
    c_birth_day               int,
    c_birth_month             int,
    c_birth_year              int,
    c_birth_country           string,
    c_login                   string,
    c_email_address           string,
    c_last_review_date        string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/customer' INTO TABLE customer;

drop table if exists date_dim;
create table date_dim
(
    d_date_sk                 int,
    d_date_id                 string,
    d_date                    string,
    d_month_seq               int,
    d_week_seq                int,
    d_quarter_seq             int,
    d_year                    int,
    d_dow                     int,
    d_moy                     int,
    d_dom                     int,
    d_qoy                     int,
    d_fy_year                 int,
    d_fy_quarter_seq          int,
    d_fy_week_seq             int,
    d_day_name                string,
    d_quarter_name            string,
    d_holiday                 string,
    d_weekend                 string,
    d_following_holiday       string,
    d_first_dom               int,
    d_last_dom                int,
    d_same_day_ly             int,
    d_same_day_lq             int,
    d_current_day             string,
    d_current_week            string,
    d_current_month           string,
    d_current_quarter         string,
    d_current_year            string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/date_dim' INTO TABLE date_dim;

drop table if exists date_dim_date;
create table date_dim_date
(
    d_date_sk                 int,
    d_date_id                 string,
    d_date                    date,
    d_month_seq               int,
    d_week_seq                int,
    d_quarter_seq             int,
    d_year                    int,
    d_dow                     int,
    d_moy                     int,
    d_dom                     int,
    d_qoy                     int,
    d_fy_year                 int,
    d_fy_quarter_seq          int,
    d_fy_week_seq             int,
    d_day_name                string,
    d_quarter_name            string,
    d_holiday                 string,
    d_weekend                 string,
    d_following_holiday       string,
    d_first_dom               int,
    d_last_dom                int,
    d_same_day_ly             int,
    d_same_day_lq             int,
    d_current_day             string,
    d_current_week            string,
    d_current_month           string,
    d_current_quarter         string,
    d_current_year            string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/date_dim_date' INTO TABLE date_dim_date;

drop table if exists household_demographics;
create table household_demographics
(
    hd_demo_sk                int,
    hd_income_band_sk         int,
    hd_buy_potential          string,
    hd_dep_count              int,
    hd_vehicle_count          int
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/household_demographics' INTO TABLE household_demographics;

drop table if exists income_band;
create table income_band(
      ib_income_band_sk         int
,     ib_lower_bound            int
,     ib_upper_bound            int
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/income_band' INTO TABLE income_band;

drop table if exists inventory;
create table inventory
(
    inv_date_sk			int,
    inv_item_sk			int,
    inv_warehouse_sk		int,
    inv_quantity_on_hand	int
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/inventory' INTO TABLE inventory;

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
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/item' INTO TABLE item;

drop table if exists promotion;
create table promotion
(
    p_promo_sk                int,
    p_promo_id                string,
    p_start_date_sk           int,
    p_end_date_sk             int,
    p_item_sk                 int,
    p_cost                    float,
    p_response_target         int,
    p_promo_name              string,
    p_channel_dmail           string,
    p_channel_email           string,
    p_channel_catalog         string,
    p_channel_tv              string,
    p_channel_radio           string,
    p_channel_press           string,
    p_channel_event           string,
    p_channel_demo            string,
    p_channel_details         string,
    p_purpose                 string,
    p_discount_active         string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/promotion' INTO TABLE promotion;

drop table if exists reason;
create table reason(
      r_reason_sk               int
,     r_reason_id               string
,     r_reason_desc             string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/reason' INTO TABLE reason;

drop table if exists store_returns;
create table store_returns
(
    sr_returned_date_sk       int,
    sr_return_time_sk         int,
    sr_item_sk                int,
    sr_customer_sk            int,
    sr_cdemo_sk               int,
    sr_hdemo_sk               int,
    sr_addr_sk                int,
    sr_store_sk               int,
    sr_reason_sk              int,
    sr_ticket_number          bigint,
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
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/store_returns' INTO TABLE store_returns;

drop table if exists store_sales;
create table store_sales
(
    ss_sold_date_sk           int,
    ss_sold_time_sk           int,
    ss_item_sk                int,
    ss_customer_sk            int,
    ss_cdemo_sk               int,
    ss_hdemo_sk               int,
    ss_addr_sk                int,
    ss_store_sk               int,
    ss_promo_sk               int,
    ss_ticket_number          bigint,
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
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/store_sales' INTO TABLE store_sales;

drop table if exists store;
create table store
(
    s_store_sk                int,
    s_store_id                string,
    s_rec_start_date          string,
    s_rec_end_date            string,
    s_closed_date_sk          int,
    s_store_name              string,
    s_number_employees        int,
    s_floor_space             int,
    s_hours                   string,
    s_manager                 string,
    s_market_id               int,
    s_geography_class         string,
    s_market_desc             string,
    s_market_manager          string,
    s_division_id             int,
    s_division_name           string,
    s_company_id              int,
    s_company_name            string,
    s_street_number           string,
    s_street_name             string,
    s_street_type             string,
    s_suite_number            string,
    s_city                    string,
    s_county                  string,
    s_state                   string,
    s_zip                     string,
    s_country                 string,
    s_gmt_offset              float,
    s_tax_precentage          float
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/store' INTO TABLE store;

drop table if exists time_dim;
create table time_dim
(
    t_time_sk                 int,
    t_time_id                 string,
    t_time                    int,
    t_hour                    int,
    t_minute                  int,
    t_second                  int,
    t_am_pm                   string,
    t_shift                   string,
    t_sub_shift               string,
    t_meal_time               string
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/time_dim' INTO TABLE time_dim;

drop table if exists warehouse;
create table warehouse(
      w_warehouse_sk            int
,     w_warehouse_id            string
,     w_warehouse_name          string
,     w_warehouse_sq_ft         int
,     w_street_number           string
,     w_street_name             string
,     w_street_type             string
,     w_suite_number            string
,     w_city                    string
,     w_county                  string
,     w_state                   string
,     w_zip                     string
,     w_country                 string
,     w_gmt_offset              float
) stored as orc;
LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/interactive/tbench1/data/tpcds_bin_flat_10.db/warehouse' INTO TABLE warehouse;

analyze table call_center compute statistics for columns;
analyze table customer compute statistics for columns;
analyze table customer_address compute statistics for columns;
analyze table customer_demographics compute statistics for columns;
analyze table date_dim compute statistics for columns;
analyze table date_dim_date compute statistics for columns;
analyze table household_demographics compute statistics for columns;
analyze table income_band compute statistics for columns;
analyze table inventory compute statistics for columns;
analyze table item compute statistics for columns;
analyze table promotion compute statistics for columns;
analyze table reason compute statistics for columns;
analyze table store compute statistics for columns;
analyze table store_returns compute statistics for columns;
analyze table store_sales compute statistics for columns;
analyze table time_dim compute statistics for columns;
analyze table warehouse compute statistics for columns;
