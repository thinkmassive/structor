#!/bin/sh

cd /vagrant/modules/benchmetrics/files/tpc/tpch/queries
DATABASE=tpch_bin_flat_orc_2

hive --version | grep '^Hive 2'
if [ $? -eq 0 ]; then
	hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpch/queries/skip-q11-serial.sql
else
	hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpch/queries/skip-q19-serial.sql
fi
