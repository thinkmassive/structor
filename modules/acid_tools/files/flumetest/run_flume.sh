#!/bin/sh

echo Setting up Flume.
export HIVE_HOME=/usr/hdp/current/hive-client
export FLUME_JAVA_OPTS=-Xmx256m
sudo cp flume.conf /usr/hdp/current/flume-server/conf
sudo mkdir -p /tmp/acid_source
sudo chmod 777 /tmp/acid_source
echo "Use insert_data.sh to insert data"
/usr/hdp/current/flume-server/bin/flume-ng agent -n flume-hive-ingest -f /usr/hdp/current/flume-server/conf/flume.conf -C /usr/hdp/current/hive-webhcat/share/hcatalog/hive-hcatalog-streaming.jar
