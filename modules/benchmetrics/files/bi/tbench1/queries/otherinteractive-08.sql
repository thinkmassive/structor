SELECT MONTH(`date_dim_date`.`d_date`) AS `mn_d_date_ok`,
`store_sales`.`ss_ticket_number` AS `ss_ticket_number`,
YEAR(`date_dim_date`.`d_date`) AS `yr_d_date_ok`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`date_dim_date` `date_dim_date` ON (`store_sales`.`ss_sold_date_sk` = `date_dim_date`.`d_date_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
GROUP BY MONTH(`date_dim_date`.`d_date`),
`store_sales`.`ss_ticket_number`,
YEAR(`date_dim_date`.`d_date`) ;

