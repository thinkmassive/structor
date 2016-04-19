drop table if exists query44_avg_net_profit;
create table query44_avg_net_profit as
select avg(ss_net_profit) rank_col
  from store_sales
  where ss_store_sk = 47
  and ss_hdemo_sk is null
  group by ss_store_sk;

select  asceding.rnk, i1.i_product_name best_performing, i2.i_product_name worst_performing
from(select *
     from (select item_sk,rank() over (order by rank_col asc) rnk
           from (select ss_item_sk item_sk,avg(ss_net_profit) rank_col 
                 from store_sales ss1, query44_avg_net_profit
                 where ss_store_sk = 47
                 group by ss_item_sk
                 having avg(ss_net_profit) > 0.9 * rank_col) V1 ) V11
     where rnk  < 11) asceding,
    (select *
     from (select item_sk,rank() over (order by rank_col desc) rnk
           from (select ss_item_sk item_sk,avg(ss_net_profit) rank_col
                 from store_sales ss1, query44_avg_net_profit
                 where ss_store_sk = 47
                 group by ss_item_sk
                 having avg(ss_net_profit) > 0.9 * rank_col) V2 ) V22
     where rnk  < 11) descending,
item i1,
item i2
where asceding.rnk = descending.rnk 
  and i1.i_item_sk=asceding.item_sk
  and i2.i_item_sk=descending.item_sk
order by asceding.rnk
limit 100;
