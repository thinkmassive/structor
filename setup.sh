#!/bin/sh

# Hive DDL.
echo Creating Hive table.
hive -f create_table.sql

echo Setting up Flume.
export HIVE_HOME=/usr/hdp/current/hive-client
export FLUME_JAVA_OPTS=-Xmx256m
sudo cp flume.conf /usr/hdp/current/flume-server/conf
sudo mkdir -p /tmp/acid_source
sudo chmod 777 /tmp/acid_source
/usr/hdp/current/flume-server/bin/flume-ng agent -n flume-hive-ingest -f /usr/hdp/current/flume-server/conf/flume.conf -C /usr/hdp/2.2.*/hive-hcatalog/share/hcatalog/hive-hcatalog-streaming.jar

echo "Use insert-data.sh to insert data"
