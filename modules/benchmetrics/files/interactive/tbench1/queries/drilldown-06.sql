SELECT `date_dim`.`d_date` AS `d_date`
FROM `${DB}`.`date_dim` `date_dim`
GROUP BY `date_dim`.`d_date`
LIMIT 28 ;

