#!/bin/sh

if [ X"$1" = "X" ]; then
	echo "Usage: $0 <update#> [ scale ]"
	exit 1
else
	UPDATEID=$1
fi

SCALE=2
if [ X"$2" != "X" ]; then
	SCALE=$2
fi

# Generate data.
DIR=/tmp/tpch.updates
rm -rf $DIR
mkdir -p $DIR
cd $DIR
cp /vagrant/modules/benchmetrics/files/tpc/tpch.acid/target/tpch_2_17_0/dbgen/dists.dss .
/vagrant/modules/benchmetrics/files/tpc/tpch.acid/target/tpch_2_17_0/dbgen/dbgen -s $SCALE -U $UPDATEID -S $UPDATEID

# Copy it in.
hdfs dfs -rmr $DIR
hdfs dfs -mkdir -p $DIR/lineitem_stage $DIR/orders_stage $DIR/delete_stage
hdfs dfs -copyFromLocal $DIR/lineitem* $DIR/lineitem_stage
hdfs dfs -copyFromLocal $DIR/orders*   $DIR/orders_stage
hdfs dfs -copyFromLocal $DIR/delete*   $DIR/delete_stage
hdfs dfs -du $DIR

# Load the data in Hive.
DB=tpch_bin_flat_acid_$SCALE
hive -d DB=$DB -f /vagrant/modules/benchmetrics/files/tpc/tpch.acid/update-tpch-data.sql
hdfs dfs -du /home/vagrant
hdfs dfs -du /apps/hive/warehouse
hdfs dfs -lsr /apps/hive/warehouse | grep -v '     0'
