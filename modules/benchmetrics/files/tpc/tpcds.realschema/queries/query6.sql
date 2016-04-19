drop table if exists query6_d_month_seq;
create table query6_d_month_seq as
select distinct (d_month_seq)
  from date_dim
    where d_year = 2000
    and d_moy = 2;

select state, count(*) cnt from (
 select
   a.ca_state state,
   i_current_price,
   avg(i_current_price) over (partition by i_category) avg_cat_price
 from customer_address a
     ,customer c
     ,store_sales s
     ,date_dim d
     ,item i
     ,query6_d_month_seq
 where       a.ca_address_sk = c.c_current_addr_sk
 	and c.c_customer_sk = s.ss_customer_sk
 	and s.ss_sold_date_sk = d.d_date_sk
 	and s.ss_item_sk = i.i_item_sk
 	and d.d_month_seq = query6_d_month_seq.d_month_seq
 group by a.ca_state, i_category, i_current_price
 ) sub
 where i_current_price > 1.2 * avg_cat_price
 group by state
 having count(*) >= 10
 order by cnt 
 limit 100;
