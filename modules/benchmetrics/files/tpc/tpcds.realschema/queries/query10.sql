select
  cd_gender, cd_marital_status, cd_education_status,
  count(*) cnt1, cd_purchase_estimate,
  count(*) cnt2, cd_credit_rating,
  count(*) cnt3, cd_dep_count,
  count(*) cnt4, cd_dep_employed_count,
  count(*) cnt5, cd_dep_college_count,
  count(*) cnt6
 from
  customer c,customer_address ca,customer_demographics
  left join (select distinct ss_customer_sk from store_sales, date_dim
                where ss_sold_date_sk = d_date_sk and
                d_year = 2002 and
                d_moy between 4 and 4+3) sub1 on c_customer_sk = sub1.ss_customer_sk
  left join (select distinct ws_bill_customer_sk from web_sales, date_dim
                where ws_sold_date_sk = d_date_sk and
                d_year = 2002 and
                d_moy between 4 and 4+3) sub2 on c_customer_sk = sub2.ws_bill_customer_sk
  left join (select distinct cs_ship_customer_sk from catalog_sales, date_dim
                where cs_sold_date_sk = d_date_sk and
                d_year = 2002 and
                d_moy between 4 and 4+3) sub3 on c_customer_sk = sub3.cs_ship_customer_sk
 where
  sub1.ss_customer_sk is not null
  and ( sub2.ws_bill_customer_sk is not null or sub3.cs_ship_customer_sk is not null )
  and c.c_current_addr_sk = ca.ca_address_sk and
  ca_county in ('Walker County','Richland County','Gaines County','Douglas County','Dona Ana County') and
  cd_demo_sk = c.c_current_cdemo_sk
 group by cd_gender, cd_marital_status, cd_education_status, cd_purchase_estimate, cd_credit_rating,
          cd_dep_count, cd_dep_employed_count, cd_dep_college_count
 order by cd_gender, cd_marital_status, cd_education_status, cd_purchase_estimate, cd_credit_rating,
          cd_dep_count, cd_dep_employed_count, cd_dep_college_count
limit 100;
