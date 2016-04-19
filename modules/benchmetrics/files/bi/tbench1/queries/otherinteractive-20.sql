SELECT `time_dim`.`t_hour` AS `t_hour`,
SUM(`store_sales`.`ss_net_paid`) AS `sum_ss_net_paid_ok`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
JOIN `${DB}`.`time_dim` `time_dim` ON (`store_sales`.`ss_sold_time_sk` = `time_dim`.`t_time_sk`)
GROUP BY `time_dim`.`t_hour` ;

