SELECT YEAR(`date_dim_date`.`d_date`) AS `yr_d_date_ok`
FROM `${DB}`.`date_dim_date` `date_dim_date`
GROUP BY YEAR(`date_dim_date`.`d_date`) ;

