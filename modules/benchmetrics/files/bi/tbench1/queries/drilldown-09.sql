SELECT `customer_demographics`.`cd_gender` AS `cd_gender`
FROM `${DB}`.`customer_demographics` `customer_demographics`
GROUP BY `customer_demographics`.`cd_gender`
ORDER BY `cd_gender` ASC ;

