SELECT `store`.`s_state` AS `s_state`
FROM `${DB}`.`store` `store`
GROUP BY `store`.`s_state`
ORDER BY `s_state` ASC ;

