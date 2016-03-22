#!/bin/sh

cd /vagrant/modules/benchmetrics/files/tpc/tpch/queries
DATABASE=tpch_bin_flat_orc_2
hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpch/queries/skip-q19-serial.sql
