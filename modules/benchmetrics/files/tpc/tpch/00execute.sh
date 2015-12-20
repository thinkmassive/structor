#!/bin/sh

DATABASE=tpch_bin_flat_orc_2
hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpch/queries/all-queries-serial.sql
