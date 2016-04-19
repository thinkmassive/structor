drop table if exists query9_temp;
create table query9_temp as
select
  case when ss_quantity         between  1 and  20 then 1                   else 0 end as ss_quantity_1_20,
  case when ss_ext_sales_price  between  1 and  20 then ss_ext_sales_price  else 0 end as ss_tot_ext_1_20,
  case when ss_net_paid_inc_tax between  1 and  20 then ss_net_paid_inc_tax else 0 end as ss_tot_net_1_20,
  case when ss_quantity         between 21 and  40 then 1                   else 0 end as ss_quantity_21_40,
  case when ss_ext_sales_price  between 21 and  40 then ss_ext_sales_price  else 0 end as ss_tot_ext_21_40,
  case when ss_net_paid_inc_tax between 21 and  40 then ss_net_paid_inc_tax else 0 end as ss_tot_net_21_40,
  case when ss_quantity         between 41 and  60 then 1                   else 0 end as ss_quantity_41_60,
  case when ss_ext_sales_price  between 41 and  60 then ss_ext_sales_price  else 0 end as ss_tot_ext_41_60,
  case when ss_net_paid_inc_tax between 41 and  60 then ss_net_paid_inc_tax else 0 end as ss_tot_net_41_60,
  case when ss_quantity         between 61 and  80 then 1                   else 0 end as ss_quantity_61_80,
  case when ss_ext_sales_price  between 61 and  80 then ss_ext_sales_price  else 0 end as ss_tot_ext_61_80,
  case when ss_net_paid_inc_tax between 61 and  80 then ss_net_paid_inc_tax else 0 end as ss_tot_net_61_80,
  case when ss_quantity         between 81 and 100 then 1                   else 0 end as ss_quantity_81_100,
  case when ss_ext_sales_price  between 81 and 100 then ss_ext_sales_price  else 0 end as ss_tot_ext_81_100,
  case when ss_net_paid_inc_tax between 81 and 100 then ss_net_paid_inc_tax else 0 end as ss_tot_net_81_100
from store_sales;

select
       case when ss_quantity_1_20   > 30538 then ss_tot_ext_1_20   else ss_tot_net_1_20   end bucket1,
       case when ss_quantity_21_40  > 84287 then ss_tot_ext_21_40  else ss_tot_net_21_40  end bucket2,
       case when ss_quantity_41_60  > 56581 then ss_tot_ext_41_60  else ss_tot_net_41_60  end bucket3,
       case when ss_quantity_61_80  > 10098 then ss_tot_ext_61_80  else ss_tot_net_61_80  end bucket4,
       case when ss_quantity_81_100 > 77817 then ss_tot_ext_81_100 else ss_tot_net_81_100 end bucket5
from query9_temp;
