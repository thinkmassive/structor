select  
    sum(ss_net_profit)/sum(ss_ext_sales_price) as gross_margin
   ,i_category
   ,i_class
   ,GROUPING__ID as lochierarchy
   ,rank() over (
 	partition by GROUPING__ID,
 	case when cast(GROUPING__ID as int) & 2 = 0 then i_category end 
 	order by sum(ss_net_profit)/sum(ss_ext_sales_price) asc) as rank_within_parent
 from
    store_sales,date_dim d1,item,store
 where
    d1.d_year = 1999 
 and d1.d_date_sk = ss_sold_date_sk
 and i_item_sk  = ss_item_sk 
 and s_store_sk  = ss_store_sk
 and s_state in ('SD','TN','AL','SD','SD','SD','AL','SD')
 group by i_category, i_class with rollup
 order by
   lochierarchy desc
  ,case when lochierarchy = 0 then i_category end
  ,rank_within_parent
  limit 100;
