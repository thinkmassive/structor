#!/bin/sh

echo "Removing bad JAR"
sudo rm -f /usr/hdp/2.2.6.11-6/hadoop-hdfs/hadoop-hdfs-defective-2.6.0.jar
sudo rm -f /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-hdfs-defective-2.6.0.jar
sudo rm -f /usr/hdp/2.2.6.11-6/hadoop/hadoop-common-defective-2.6.0.jar
sudo rm -f /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-common-defective-2.6.0.jar

echo "Replacing old JARs"
sudo cp /root/oldjars/hadoop-hdfs-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop-hdfs/ 2>/dev/null
sudo cp /root/oldjars/hadoop-hdfs-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop/client/ 2>/dev/null
sudo cp /root/oldjars/hadoop-common-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop/ 2>/dev/null
sudo cp /root/oldjars/hadoop-common-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop/client/ 2>/dev/null

sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop-hdfs/hadoop-hdfs-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop-hdfs/hadoop-hdfs.jar
sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-hdfs-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop/clienthadoop-hdfs.jar
sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop/hadoop-common-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop/hadoop-common.jar
sudo ln -sf /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-common-2.6.0.2.2.6.11-6.jar /usr/hdp/2.2.6.11-6/hadoop/client/hadoop-common.jar

echo "Restarting services"
sudo service hadoop-hdfs-datanode restart
sudo service hive-metastore restart
