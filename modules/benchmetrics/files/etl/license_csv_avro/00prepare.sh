#!/bin/sh

sudo usermod -a -G hadoop vagrant

sudo service hive-server2 stop
hdfs dfs -rmr /user/vagrant/.Trash
sudo bash -c "rm -rf /var/lib/hadoop/yarn/node/usercache/vagrant/appcache/application_*"
hive -f /vagrant/modules/benchmetrics/files/etl/license_csv_avro/create_csv_table.sql
