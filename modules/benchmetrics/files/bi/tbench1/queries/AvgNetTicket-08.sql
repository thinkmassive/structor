SELECT `store_sales`.`ss_ticket_number` AS `ss_ticket_number`
FROM `${DB}`.`store_sales` `store_sales`
GROUP BY `store_sales`.`ss_ticket_number` ;

