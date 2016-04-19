SELECT (((YEAR(`date_dim_date`.`d_date`) * 10000) + (MONTH(`date_dim_date`.`d_date`) * 100)) + DAY(`date_dim_date`.`d_date`)) AS `md_d_date_ok`
FROM `${DB}`.`date_dim_date` `date_dim_date`
GROUP BY (((YEAR(`date_dim_date`.`d_date`) * 10000) + (MONTH(`date_dim_date`.`d_date`) * 100)) + DAY(`date_dim_date`.`d_date`)) ;

