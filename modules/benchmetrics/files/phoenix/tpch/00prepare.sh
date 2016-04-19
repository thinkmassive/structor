#!/bin/sh

SCALE=2

sudo usermod -a -G hadoop vagrant
/vagrant/modules/benchmetrics/files/cleanYarn.sh

# Don't do anything if the data is already loaded.
count=`/usr/hdp/current/phoenix-client/bin/sqlline.py -e 'select * from SYSTEM.CATALOG' | grep LINEITEM | wc -l`

if [ $count -ne 17 ];  then
	# Some setup.
	sudo -u hdfs hdfs dfs -mkdir /user/hbase
	sudo -u hdfs hdfs dfs -chown hbase:hbase /user/hbase

	# Build it.
	echo "Building the data generator"
	cd /vagrant/modules/benchmetrics/files/phoenix/tpch
	sh /vagrant/modules/benchmetrics/files/phoenix/tpch/tpch-build.sh

	# Generate the data.
	echo "Generate the data at scale $SCALE"
	sh /vagrant/modules/benchmetrics/files/phoenix/tpch/tpch-generate.sh $SCALE

	# Load the data.
	echo "Load the data"
	sudo -u hbase /vagrant/modules/benchmetrics/files/phoenix/tpch/tpch-load.sh $SCALE
else
	echo "Data appears to be loaded, drop data manually to re-generate"
fi
