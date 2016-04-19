#!/bin/sh

SCALE=2

/vagrant/modules/benchmetrics/files/cleanYarn.sh
sudo service hive-server2 stop
sudo usermod -a -G hadoop vagrant

# Don't do anything if the data is already loaded.
hdfs dfs -ls /apps/hive/warehouse/tpcds_bin_partitioned_orc_$SCALE.db >/dev/null

if [ $? -ne 0 ];  then
	# CentOS 7 doesn't have this one pre-installed.
	sudo yum install -y unzip

	# Build it.
	echo "Building the data generator"
	cd /vagrant/modules/benchmetrics/files/tpc/tpcds
	sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-build.sh

	# Generate and optimize the data.
	echo "Generate the data at scale $SCALE"
	sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-datagen.sh $SCALE
	sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-setup.sh $SCALE
fi
