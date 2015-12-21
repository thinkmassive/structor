#!/bin/sh

DATABASE=tpcds_bin_partitioned_orc_2
hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpcds/queries/all-queries-serial.sql
