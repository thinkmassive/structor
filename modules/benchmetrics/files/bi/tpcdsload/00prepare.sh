#!/bin/sh

# Make room.
/vagrant/modules/benchmetrics/files/cleanYarn.sh
hive -f /vagrant/modules/benchmetrics/files/bi/tpcdsload/drop_large_dbs.sql
hdfs dfs -rmr /user/vagrant/.Trash

SCALE=2

sudo service hive-server2 stop
sudo usermod -a -G hadoop vagrant

# Build the data generator, generate the data and load the external table.
echo "Building the data generator"
cd /vagrant/modules/benchmetrics/files/tpc/tpcds
sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-build.sh

echo "Generating TPC-DS data at scale $SCALE"
sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-datagen.sh $SCALE
