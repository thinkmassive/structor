SELECT `customer_demographics`.`cd_credit_rating` AS `cd_credit_rating`,
`customer_demographics`.`cd_gender` AS `cd_gender`
FROM `${DB}`.`customer_demographics` `customer_demographics`
GROUP BY `customer_demographics`.`cd_credit_rating`,
`customer_demographics`.`cd_gender`
ORDER BY `cd_credit_rating` ASC,
`cd_gender` ASC ;

