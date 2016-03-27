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
which hive > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Script must be run where Hive is installed"
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

# Create ORC tables.
DATABASE=tpch_bin_flat_acid_${SCALE}
echo "Optimizing tables and computing stats"
COMMAND="hive -i settings/etlsettings.sql -f ddl/bin_flat/alltables.sql \
    -d DB=${DATABASE} \
    -d SOURCE=tpch_text_${SCALE} -d BUCKETS=${BUCKETS} \
    -d RETURN_BUCKETS=${RETURN_BUCKETS} -d FILE=${FORMAT}"
runcommand "$COMMAND"
if [ $? -ne 0 ]; then
	exit 1
fi

echo "Data loaded into database ${DATABASE}."
