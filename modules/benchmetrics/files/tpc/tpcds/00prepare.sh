#!/bin/sh

SCALE=2

sudo servie hive-server2 stop
sudo usermod -a -G hadoop vagrant

# Don't do anything if the data is already loaded.
hdfs dfs -ls /apps/hive/warehouse/tpcds_bin_partitioned_orc_$SCALE.db >/dev/null

if [ $? -ne 0 ];  then
	# Build it.
	echo "Building the data generator"
	cd /vagrant/modules/benchmetrics/files/tpc/tpcds
	sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-build.sh

	# Generate and optimize the data.
	echo "Generate the data at scale $SCALE"
	sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-setup.sh $SCALE
fi
