#!/bin/sh

sudo service hive-server2 stop
hive -f /vagrant/modules/benchmetrics/files/etl/license_csv_avro/create_csv_table.sql
