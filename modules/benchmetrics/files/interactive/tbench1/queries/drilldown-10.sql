SELECT `customer_demographics`.`cd_marital_status` AS `cd_marital_status`
FROM `${DB}`.`customer_demographics` `customer_demographics`
GROUP BY `customer_demographics`.`cd_marital_status`
ORDER BY `cd_marital_status` ASC ;

