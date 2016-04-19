SELECT MIN(`t0`.`sum_ss_net_paid_qk`) AS `temp_sum_ss_net_paid_qk_lower__290714814__0_`,
MAX(`t0`.`sum_ss_net_paid_qk`) AS `temp_sum_ss_net_paid_qk_upper__290714814__0_`
FROM (
SELECT `item`.`i_brand` AS `none_i_brand_nk`,
`store`.`s_state` AS `none_s_state_nk`,
SUM(`store_sales`.`ss_net_paid`) AS `sum_ss_net_paid_qk`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`date_dim_date` `date_dim_date` ON (`store_sales`.`ss_sold_date_sk` = `date_dim_date`.`d_date_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
GROUP BY `item`.`i_brand`,
`store`.`s_state`
) `t0`
GROUP BY 1
HAVING (COUNT(1) > 0) ;

