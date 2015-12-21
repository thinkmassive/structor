#!/bin/sh

hive -f /vagrant/modules/benchmetrics/files/etl/all_types/drop_everything.sql
rm -f /tmp/all_types*
