SELECT MONTH(`date_dim_date`.`d_date`) AS `mn_d_date_ok`
FROM `${DB}`.`date_dim_date` `date_dim_date`
GROUP BY MONTH(`date_dim_date`.`d_date`) ;

