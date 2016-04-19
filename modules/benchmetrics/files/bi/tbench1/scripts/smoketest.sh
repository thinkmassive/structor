#!/bin/sh

set -x
hive -d DB=tpcds_bin_flat_10 -f /vagrant/modules/benchmetrics/files/interactive/tbench1/justone.sql
