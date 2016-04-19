SELECT `store`.`s_store_id` AS `s_store_id`
FROM `${DB}`.`store` `store`
GROUP BY `store`.`s_store_id`
ORDER BY `s_store_id` ASC ;

