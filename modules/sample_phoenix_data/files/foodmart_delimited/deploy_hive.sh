#!/bin/sh

hadoop fs -mkdir /apps/hive/warehouse
hadoop fs -copyFromLocal . /apps/hive/warehouse
hive -d DB=foodmart -d LOCATION=/apps/hive/warehouse/foodmart -f foodmart_hive.ddl
