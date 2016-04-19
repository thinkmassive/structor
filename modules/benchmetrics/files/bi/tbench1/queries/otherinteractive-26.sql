SELECT (1 + PMOD(DATEDIFF(TO_DATE(`date_dim_date`.`d_date`), '1995-01-01 00:00:00'), 7)) AS `wd_d_date_ok`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
JOIN `${DB}`.`date_dim_date` `date_dim_date` ON (`store_sales`.`ss_sold_date_sk` = `date_dim_date`.`d_date_sk`)
JOIN `${DB}`.`store_returns` `store_returns` ON (`date_dim_date`.`d_date_sk` = `store_returns`.`sr_returned_date_sk`)
GROUP BY (1 + PMOD(DATEDIFF(TO_DATE(`date_dim_date`.`d_date`), '1995-01-01 00:00:00'), 7)) ;

