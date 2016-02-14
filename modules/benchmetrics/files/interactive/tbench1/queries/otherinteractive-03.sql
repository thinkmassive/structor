SELECT `date_dim_date`.`d_date` AS `d_date`
FROM `${DB}`.`date_dim_date` `date_dim_date`
GROUP BY `date_dim_date`.`d_date`
ORDER BY `d_date` ASC ;

