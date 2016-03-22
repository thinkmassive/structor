#!/bin/sh

hive -f /vagrant/modules/benchmetrics/files/bi/tpcdsload/add_date_time_date.sql
hdfs dfs -rmr -skipTrash /tmp/tpcds-generate
