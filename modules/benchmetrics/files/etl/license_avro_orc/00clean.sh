#!/bin/sh

hive -f /vagrant/modules/benchmetrics/files/etl/license_avro_orc/drop_everything.sql
hdfs dfs -rmr /user/vagrant/.Trash
