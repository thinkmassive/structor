#!/bin/sh

sudo usermod -a -G hadoop vagrant

hdfs dfs -rmr /tmp/phoenix_timeseries
hdfs dfs -rmr /user/vagrant/.Trash
sudo bash -c "rm -rf /var/lib/hadoop/yarn/node/usercache/hbase/appcache/application_*"
sudo yum -y install epel-release python-pip
sudo pip install importlib

# Generate data.
echo "Generating Data"
mkdir -p /tmp/phoenix_timeseries
cd /tmp/phoenix_timeseries
for i in 0; do
	for j in 0 1 2 3 4 ; do
		k=`expr $i \* 10 + $j`
		python /vagrant/modules/benchmetrics/files/generator/generate.py -w phoenix_timeseries -s 20 -c $k &
	done
	wait
done

# Copy into HDFS and remove.
hdfs dfs -copyFromLocal /tmp/phoenix_timeseries /tmp/phoenix_timeseries
rm -f /tmp/phoenix_timeseries/*.txt

# Create the table.
/usr/hdp/current/phoenix-client/bin/sqlline.py -f /vagrant/modules/benchmetrics/files/phoenix/timeseries/create_table.sql

# Allow sudo access for HBase so we can track YARN disk usage.
sudo cp /vagrant/modules/benchmetrics/files/phoenix/timeseries/493_hbase /etc/sudoers.d
