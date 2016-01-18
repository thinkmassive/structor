#!/bin/sh

# Drop the table.
/usr/hdp/current/phoenix-client/bin/sqlline.py -f /vagrant/modules/benchmetrics/files/phoenix/timeseries/drop_table.sql

# Remove data.
# hdfs dfs -rmr /tmp/phoenix_timeseries
rm -f /tmp/phoenix_timeseries/*.txt
