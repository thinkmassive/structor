SELECT `t1`.`c_customer_id` AS `c_customer_id`,
`t3`.`x_measure__1` AS `min_calculation_270497503524864011_ok`,
`t1`.`ss_ticket_number` AS `ss_ticket_number`,
`t1`.`sum_calculation_270497503538720781_ok` AS `sum_calculation_270497503538720781_ok`
FROM (
SELECT `customer`.`c_customer_id` AS `c_customer_id`,
`store_sales`.`ss_ticket_number` AS `ss_ticket_number`,
SUM((CASE WHEN 30 = 0 THEN NULL ELSE CAST((`date_dim_date`.`d_date` - `t0`.`x_measure__2`) AS DOUBLE) / 30 END)) AS `sum_calculation_270497503538720781_ok`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`date_dim_date` `date_dim_date` ON (`store_sales`.`ss_sold_date_sk` = `date_dim_date`.`d_date_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
JOIN (
SELECT MIN(`date_dim_date`.`d_date`) AS `x_measure__2`,
`customer`.`c_customer_id` AS `c_customer_id`,
`date_dim_date`.`d_date_sk` AS `d_date_sk`,
`store_sales`.`ss_ticket_number` AS `ss_ticket_number`
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
) `t0` ON ((`customer`.`c_customer_id` = `t0`.`c_customer_id`) AND (`store_sales`.`ss_ticket_number` = `t0`.`ss_ticket_number`) AND (`date_dim_date`.`d_date_sk` = `t0`.`d_date_sk`))
WHERE ((((YEAR(`date_dim_date`.`d_date`) * 10000) + (MONTH(`date_dim_date`.`d_date`) * 100)) + DAY(`date_dim_date`.`d_date`)) = 19990109)
GROUP BY `customer`.`c_customer_id`,
`store_sales`.`ss_ticket_number`
) `t1`
JOIN (
SELECT MIN(`t2`.`x_measure__0`) AS `x_measure__1`,
`t2`.`c_customer_id` AS `c_customer_id`,
`t2`.`ss_ticket_number` AS `ss_ticket_number`
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
) `t2`
GROUP BY `t2`.`c_customer_id`,
`t2`.`ss_ticket_number`
) `t3` ON ((`t1`.`c_customer_id` = `t3`.`c_customer_id`) AND (`t1`.`ss_ticket_number` = `t3`.`ss_ticket_number`)) ;

