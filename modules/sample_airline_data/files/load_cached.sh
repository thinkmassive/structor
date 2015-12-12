#!/bin/bash

hdfs dfs -copyFromLocal /vagrant/modules/sample_airline_data/files/airline_ontime.db /apps/hive/warehouse
hive -f /vagrant/modules/sample_airline_data/files/ddl/orc_load_cached.sql
