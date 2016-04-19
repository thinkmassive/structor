#!/bin/bash

function usage {
	echo "Usage: tpcds-setup.sh scale_factor [temp_directory]"
	exit 1
}

function runcommand {
	$1
}

if [ ! -f target/target/tpcds-gen-1.0-SNAPSHOT.jar ]; then
	echo "Please build the data generator with ./tpcds-build.sh first"
	exit 1
fi
which hive > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Script must be run where Hive is installed"
	exit 1
fi

# Get the parameters.
SCALE=$1
DIR=$2
if [ "X$BUCKET_DATA" != "X" ]; then
	BUCKETS=13
	RETURN_BUCKETS=13
else
	BUCKETS=1
	RETURN_BUCKETS=1
fi
if [ "X$DEBUG_SCRIPT" != "X" ]; then
	set -x
fi

# Sanity checking.
if [ X"$SCALE" = "X" ]; then
	usage
fi
if [ X"$DIR" = "X" ]; then
	DIR=/tmp/tpcds-generate
fi
if [ $SCALE -eq 1 ]; then
	echo "Scale factor must be greater than 1"
	exit 1
fi

# Create the partitioned and bucketed tables.
if [ "X$FORMAT" = "X" ]; then
	FORMAT=orc
fi

DATABASE=tpcds_real_bin_partitioned_${FORMAT}_${SCALE}
echo "Optimizing tables and computing stats"
COMMAND="hive -i settings/etlsettings.sql -f ddl/bin_partitioned/alltables.sql \
    -d DB=tpcds_real_bin_partitioned_${FORMAT}_${SCALE} \
    -d SOURCE=tpcds_real_text_${SCALE} -d BUCKETS=${BUCKETS} \
    -d RETURN_BUCKETS=${RETURN_BUCKETS} -d FILE=${FORMAT}"
runcommand "$COMMAND"
if [ $? -ne 0 ]; then
	exit 1
fi

echo "Data loaded into database ${DATABASE}."
