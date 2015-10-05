#!/bin/sh

CLIENT=/usr/hdp/current/phoenix-client/phoenix-client.jar
export HADOOP_CLASSPATH=/etc/hbase/conf

bulk_load()
{
	echo "Loading $1"
	yarn jar ${CLIENT} \
		org.apache.phoenix.mapreduce.CsvBulkLoadTool \
		--table $1 \
		--input $2 \
		-d '	'
}

TABLES=${1:-"account agg_c_10_sales_fact_1997 agg_c_14_sales_fact_1997 agg_c_special_sales_fact_1997 agg_g_ms_pcat_sales_fact_1997 agg_l_03_sales_fact_1997 agg_l_04_sales_fact_1997 agg_l_05_sales_fact_1997 agg_lc_06_sales_fact_1997 agg_lc_100_sales_fact_1997 agg_ll_01_sales_fact_1997 agg_pl_01_sales_fact_1997 category currency customer days department employee employee_closure expense_fact inventory_fact_1997 inventory_fact_1998 position product product_class promotion region reserve_employee salary sales_fact_1997 sales_fact_1998 sales_fact_dec_1998 store store_ragged time_by_day warehouse warehouse_class"}

for table in $TABLES; do
	DATA_PATH="/tmp/foodmart_delimited/$table"
	TABLE="foodmart.$table"
	bulk_load $TABLE $DATA_PATH
done
