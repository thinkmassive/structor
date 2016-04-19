#!/bin/bash

function usage {
	echo "Usage: tpch-setup.sh scale_factor [temp_directory]"
	exit 1
}

function runcommand {
	$1
}

if [ ! -f target/target/tpch-gen-1.0-SNAPSHOT.jar ]; then
	echo "Please build the data generator with ./tpch-build.sh first"
	exit 1
fi
if [ ! -f /usr/hdp/current/phoenix-client/phoenix-client.jar ]; then
	echo "Script must be run where Phoenix is installed"
	exit 1
fi

# Get the parameters.
SCALE=$1
if [ "X$DEBUG_SCRIPT" != "X" ]; then
	set -x
fi

# Sanity checking.
if [ X"$SCALE" = "X" ]; then
	usage
fi
if [ $SCALE -eq 1 ]; then
	echo "Scale factor must be greater than 1"
	exit 1
fi

# Create the tables.
/usr/hdp/current/phoenix-client/bin/sqlline.py -f /vagrant/modules/benchmetrics/files/phoenix/tpch/create_tables.sql

# Do the actual data load.
DIR=/tmp/tpch-generate/$SCALE

# Need PHOENIX-1973 (Phoenix 4.7+ for this to work in vagrant images)
#for table in customer lineitem nation orders part partsupp region supplier; do
#    /vagrant/modules/benchmetrics/files/cleanYarn.sh
#    yarn jar /usr/hdp/current/phoenix-client/phoenix-client.jar \
#	org.apache.phoenix.mapreduce.CsvBulkLoadTool \
#	-Dmapreduce.reduce.memory.mb=2048 \
#	-Dmapred.reduce.child.java.opts=-Xmx1800m \
#	--table $table \
#	--input $DIR/$table \
#	-d '|'
#done

# Online loader workaround. Warning: Slow!
# Get rid of this when we have PHOENIX-1973
TEMPFILE=/tmp/temp.csv
for table in customer lineitem nation orders part partsupp region supplier; do
	phoenix_table=$(echo $table | tr '[:lower:]' '[:upper:]')
	files=$(hdfs dfs -ls $DIR/$table | grep tpc | awk '{print $8}')
	for f in $files; do
		hdfs dfs -cat $f | openssl zlib -d > $TEMPFILE
		/usr/hdp/current/phoenix-client/bin/psql.py -d '|' -t $phoenix_table localhost $TEMPFILE
		rm $TEMPFILE
	done
done

echo "Data loaded"
