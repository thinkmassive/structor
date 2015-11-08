#!/bin/sh

echo "Removing old JARs"
sudo mkdir -p /root/oldjars
sudo mv /usr/hdp/2.2.6.11-6/hadoop/hadoop-common-2.6.0.2.2.6.11-6.jar /root/oldjars 2>/dev/null
sudo mv /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-common-2.6.0.2.2.6.11-6.jar /root/oldjars 2>/dev/null
sudo mv /usr/hdp/2.2.6.11-6/hadoop-hdfs/hadoop-hdfs-2.6.0.2.2.6.11-6.jar /root/oldjars 2>/dev/null
sudo mv /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-hdfs-2.6.0.2.2.6.11-6.jar /root/oldjars 2>/dev/null

echo "Deploying bad JAR"
sudo cp hadoop-hdfs-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop-hdfs
sudo cp hadoop-hdfs-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop/client
sudo cp hadoop-common-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop
sudo cp hadoop-common-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop/client

sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop-hdfs/hadoop-hdfs-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop-hdfs/hadoop-hdfs.jar
sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-hdfs-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop/clienthadoop-hdfs.jar
sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop/hadoop-common-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop/hadoop-common.jar
sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-common-defective-2.6.0.jar /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-common.jar

echo "Restarting services"
sudo service hadoop-hdfs-datanode restart
sudo service hive-metastore restart
