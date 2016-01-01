#!/bin/sh

# Drop the table.
# /usr/hdp/2.3.4.0-3485/phoenix/bin/sqlline.py -f /vagrant/modules/benchmetrics/files/phoenix/phoenix_bulkload/drop_table.sql

# Remove data.
hdfs dfs -rmr /tmp/phoenix_data
