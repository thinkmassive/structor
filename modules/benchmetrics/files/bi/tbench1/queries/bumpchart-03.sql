SELECT `item`.`i_category` AS `i_category`
FROM `${DB}`.`item` `item`
GROUP BY `item`.`i_category`
ORDER BY `i_category` ASC ;

