#!/bin/sh

hive -f /vagrant/modules/benchmetrics/files/etl/airline_convert/drop_everything.sql
hdfs dfs -rmr /user/vagrant/.Trash
