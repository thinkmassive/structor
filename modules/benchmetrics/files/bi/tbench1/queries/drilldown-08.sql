SELECT `customer_address`.`ca_zip` AS `ca_zip`,
SUM(`store_sales`.`ss_net_paid`) AS `sum_ss_net_paid_ok`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`date_dim` `date_dim` ON (`store_sales`.`ss_sold_date_sk` = `date_dim`.`d_date_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
WHERE ((((`customer`.`c_first_sales_date_sk` > 2452300) AND true) OR ((NOT (`customer`.`c_first_sales_date_sk` > 2452300)) AND false)) AND (`date_dim`.`d_date` = '2000-01-03' OR `date_dim`.`d_date` = '2000-01-04' OR `date_dim`.`d_date` = '2000-01-05' OR `date_dim`.`d_date` = '2000-01-06' OR `date_dim`.`d_date` = '2000-01-07' OR `date_dim`.`d_date` = '2000-01-08' OR `date_dim`.`d_date` = '2000-01-09' OR `date_dim`.`d_date` = '2000-01-10' OR `date_dim`.`d_date` = '2000-01-11' OR `date_dim`.`d_date` = '2000-01-12' OR `date_dim`.`d_date` = '2000-01-13' OR `date_dim`.`d_date` = '2000-01-14' OR `date_dim`.`d_date` = '2000-01-15' OR `date_dim`.`d_date` = '2000-01-16'))
GROUP BY `customer_address`.`ca_zip` ;

