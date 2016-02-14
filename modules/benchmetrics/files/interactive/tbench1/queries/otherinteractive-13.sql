SELECT `t0`.`c_customer_id` AS `c_customer_id`,
MIN(`t0`.`x_measure__0`) AS `min_calculation_270497503524864011_ok`,
`t0`.`ss_ticket_number` AS `ss_ticket_number`
FROM (
SELECT `customer`.`c_customer_id` AS `c_customer_id`,
`store_sales`.`ss_ticket_number` AS `ss_ticket_number`,
`date_dim_date`.`d_date_sk` AS `d_date_sk`,
MIN(`date_dim_date`.`d_date`) AS `x_measure__0`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`date_dim_date` `date_dim_date` ON (`store_sales`.`ss_sold_date_sk` = `date_dim_date`.`d_date_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
WHERE ((((YEAR(`date_dim_date`.`d_date`) * 10000) + (MONTH(`date_dim_date`.`d_date`) * 100)) + DAY(`date_dim_date`.`d_date`)) = 19990109)
GROUP BY `customer`.`c_customer_id`,
`store_sales`.`ss_ticket_number`,
`date_dim_date`.`d_date_sk`
) `t0`
GROUP BY `t0`.`c_customer_id`,
`t0`.`ss_ticket_number` ;

