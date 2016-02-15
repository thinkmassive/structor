#!/bin/sh

SCALE=2
if [ X"$1" != "X" ]; then
	SCALE=$1
fi
DB=tpch_bin_flat_acid_$SCALE
hive -d DB=$DB -f /vagrant/modules/benchmetrics/files/tpc/tpch.acid/compact-tpch-tables.sql
