select count(*) from (
    ( select distinct c_last_name, c_first_name, d_date
    from store_sales, date_dim, customer
          where store_sales.ss_sold_date_sk = date_dim.d_date_sk
      and store_sales.ss_customer_sk = customer.c_customer_sk
      and d_month_seq between 1212 and 1212 + 11 ) x
  left join
    ( select distinct c_last_name, c_first_name, d_date
    from catalog_sales, date_dim, customer
          where catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
      and catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
      and d_month_seq between 1212 and 1212 + 11 ) y
  on x.c_last_name = y.c_last_name and x.c_first_name = y.c_first_name and x.d_date = y.d_date
  left join
    ( select distinct c_last_name, c_first_name, d_date
    from web_sales, date_dim, customer
          where web_sales.ws_sold_date_sk = date_dim.d_date_sk
      and web_sales.ws_bill_customer_sk = customer.c_customer_sk
      and d_month_seq between 1212 and 1212 + 11 ) z
  on y.c_last_name = z.c_last_name and y.c_first_name = z.c_first_name and y.d_date = z.d_date
)
where
  x.c_last_name is null or
  y.c_last_name is null or
  x.c_last_name = y.c_last_name or
  y.c_last_name = z.c_last_name
limit 100;
