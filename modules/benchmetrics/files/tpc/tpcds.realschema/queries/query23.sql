drop table if exists query23_frequent_ss_items;
drop table if exists query23_best_ss_customer;
drop table if exists query23_temp;
create table query23_temp as
select max(csales) tpcds_cmax
  from (select c_customer_sk,sum(ss_quantity*ss_sales_price) csales
        from store_sales
            ,customer
            ,date_dim
        where ss_customer_sk = c_customer_sk
         and ss_sold_date_sk = d_date_sk
         and d_year in (1999,1999+1,1999+2,1999+3)
        group by c_customer_sk) x;

create table
query23_frequent_ss_items as
 select substr(i_item_desc,1,30) itemdesc,i_item_sk item_sk,d_date solddate,count(*) cnt
  from store_sales
      ,date_dim 
      ,item
  where ss_sold_date_sk = d_date_sk
    and ss_item_sk = i_item_sk 
    and d_year in (1999,1999+1,1999+2,1999+3)
  group by substr(i_item_desc,1,30),i_item_sk,d_date
  having count(*) >4;

create table
query23_best_ss_customer as
 select c_customer_sk,sum(ss_quantity*ss_sales_price) ssales
  from store_sales, customer, query23_temp
  where ss_customer_sk = c_customer_sk
  group by c_customer_sk, tpcds_cmax
  having sum(ss_quantity*ss_sales_price) > (95/100.0) * tpcds_cmax;

select sum(sales)
 from (select cs_quantity*cs_list_price sales
       from catalog_sales, date_dim, query23_frequent_ss_items, query23_best_ss_customer
       where d_year = 1999 
         and d_moy = 1 
         and cs_sold_date_sk = d_date_sk 
         and cs_item_sk = query23_frequent_ss_items.item_sk
         and cs_bill_customer_sk = query23_best_ss_customer.c_customer_sk
      union all
      select ws_quantity*ws_list_price sales
       from web_sales, date_dim, query23_frequent_ss_items, query23_best_ss_customer
       where d_year = 1999 
         and d_moy = 1 
         and ws_sold_date_sk = d_date_sk 
         and ws_item_sk = query23_frequent_ss_items.item_sk
         and ws_bill_customer_sk = query23_best_ss_customer.c_customer_sk) x
 limit 100;

select  c_last_name,c_first_name,sales
 from (select c_last_name,c_first_name,sum(cs_quantity*cs_list_price) sales
        from catalog_sales, customer, date_dim, query23_frequent_ss_items, query23_best_ss_customer
        where d_year = 1999 
         and d_moy = 1 
         and cs_sold_date_sk = d_date_sk 
         and cs_item_sk = query23_frequent_ss_items.item_sk
         and cs_bill_customer_sk = query23_best_ss_customer.c_customer_sk
         and cs_bill_customer_sk = customer.c_customer_sk 
       group by c_last_name,c_first_name
      union all
      select c_last_name,c_first_name,sum(ws_quantity*ws_list_price) sales
       from web_sales, customer, date_dim, query23_frequent_ss_items, query23_best_ss_customer
       where d_year = 1999 
         and d_moy = 1 
         and ws_sold_date_sk = d_date_sk 
         and ws_item_sk = query23_frequent_ss_items.item_sk
         and ws_bill_customer_sk = query23_best_ss_customer.c_customer_sk
         and ws_bill_customer_sk = customer.c_customer_sk
       group by c_last_name,c_first_name) y
     order by c_last_name,c_first_name,sales
limit 100;
