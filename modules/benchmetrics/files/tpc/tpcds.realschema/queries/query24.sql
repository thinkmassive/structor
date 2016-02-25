use ${DB};

-- Note: Waiting on ticket 1624

drop table if exists query24_temp;
create temporary table query24_temp as
with ssales as
(select c_last_name,c_first_name,s_store_name
      ,ca_state,s_state ,i_color,i_current_price
      ,i_manager_id ,i_units,i_size
      ,sum(ss_sales_price) netpaid
from store_sales,store_returns
    ,store,item,customer
    ,customer_address
where ss_ticket_number = sr_ticket_number
  and ss_item_sk = sr_item_sk
  and ss_customer_sk = c_customer_sk
  and ss_item_sk = i_item_sk
  and ss_store_sk = s_store_sk
  and c_birth_country = upper(ca_country)
  and s_zip = ca_zip
and s_market_id=5
group by c_last_name,c_first_name,s_store_name
        ,ca_state,s_state,i_color,i_current_price
        ,i_manager_id,i_units,i_size)
select 0.05*avg(netpaid) from ssales;

with ssales as
(select c_last_name,c_first_name,s_store_name
      ,ca_state,s_state ,i_color,i_current_price
      ,i_manager_id ,i_units,i_size
      ,sum(ss_sales_price) netpaid
from store_sales,store_returns
    ,store,item,customer
    ,customer_address
where ss_ticket_number = sr_ticket_number
  and ss_item_sk = sr_item_sk
  and ss_customer_sk = c_customer_sk
  and ss_item_sk = i_item_sk
  and ss_store_sk = s_store_sk
  and c_birth_country = upper(ca_country)
  and s_zip = ca_zip
and s_market_id=5
group by c_last_name,c_first_name,s_store_name
        ,ca_state,s_state,i_color,i_current_price
        ,i_manager_id,i_units,i_size)
select c_last_name,c_first_name,s_store_name, sum(netpaid) paid, query24_temp.`_c0`
from ssales, query24_temp
where i_color = 'orchid'
group by c_last_name,c_first_name,s_store_name, query24_temp.`_c0`
having sum(netpaid) > query24_temp.`_c0`;
