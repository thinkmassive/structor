#!/bin/sh

# Make room.
/vagrant/modules/benchmetrics/files/cleanYarn.sh
hive -f /vagrant/modules/benchmetrics/files/bi/tpcdsload/drop_large_dbs.sql
hdfs dfs -rmr /user/vagrant/.Trash

SCALE=2

sudo service hive-server2 stop
sudo usermod -a -G hadoop vagrant

# Don't do anything if the data is already loaded.
hdfs dfs -ls /apps/hive/warehouse/tpcds_bin_partitioned_orc_$SCALE.db >/dev/null

if [ $? -ne 0 ];  then
        # Build it.
        echo "Building the data generator"
        cd /vagrant/modules/benchmetrics/files/tpc/tpcds
        sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-build.sh
fi
