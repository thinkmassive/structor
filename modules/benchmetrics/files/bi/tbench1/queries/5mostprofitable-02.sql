SELECT CAST((MONTH(`date_dim_date`.`d_date`) - 1) / 3 + 1 AS BIGINT) AS `qr_d_date_ok`
FROM `${DB}`.`date_dim_date` `date_dim_date`
GROUP BY CAST((MONTH(`date_dim_date`.`d_date`) - 1) / 3 + 1 AS BIGINT) ;

