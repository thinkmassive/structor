select
  ca_state, cd_gender, cd_marital_status, cd_dep_count,
  count(*) cnt1,
  avg(cd_dep_count), max(cd_dep_count), sum(cd_dep_count), cd_dep_employed_count,
  count(*) cnt2,
  avg(cd_dep_employed_count), max(cd_dep_employed_count), sum(cd_dep_employed_count), cd_dep_college_count,
  count(*) cnt3,
  avg(cd_dep_college_count), max(cd_dep_college_count), sum(cd_dep_college_count)
 from
  customer c,customer_address ca,customer_demographics
  left join (
          select distinct ss_customer_sk from store_sales,date_dim
          where ss_sold_date_sk = d_date_sk and
                d_year = 1999 and
                d_qoy < 4) sub1 on c_customer_sk = ss_customer_sk
  left join (
          select distinct ws_bill_customer_sk from web_sales,date_dim
          where ws_sold_date_sk = d_date_sk and
                d_year = 1999 and
                d_qoy < 4) sub2 on c_customer_sk = ws_bill_customer_sk
  left join (
          select distinct cs_ship_customer_sk from catalog_sales,date_dim
            where cs_sold_date_sk = d_date_sk and
                  d_year = 1999 and
                  d_qoy < 4) sub3 on c_customer_sk = cs_ship_customer_sk
 where
  cd_demo_sk = c.c_current_cdemo_sk
  and c.c_current_addr_sk = ca.ca_address_sk
  and ss_customer_sk is not null
  and ( ws_bill_customer_sk is not null or cs_ship_customer_sk is not null )
 group by ca_state, cd_gender, cd_marital_status, cd_dep_count, cd_dep_employed_count, cd_dep_college_count
 order by ca_state, cd_gender, cd_marital_status, cd_dep_count, cd_dep_employed_count, cd_dep_college_count
 limit 100;
