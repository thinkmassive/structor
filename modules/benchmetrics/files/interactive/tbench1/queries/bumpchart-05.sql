SELECT `date_dim_date`.`d_day_name` AS `d_day_name`
FROM `${DB}`.`date_dim_date` `date_dim_date`
GROUP BY `date_dim_date`.`d_day_name`
ORDER BY `d_day_name` ASC ;

