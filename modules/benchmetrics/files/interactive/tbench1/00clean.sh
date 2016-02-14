#!/bin/sh

# Drop database.
hive -f /vagrant/modules/benchmetrics/files/interactive/tbench1/fixed_queries/clean.sql
hdfs dfs -rmr /user/vagrant/.Trash
