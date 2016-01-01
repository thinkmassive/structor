#!/bin/sh

sudo usermod -a -G hadoop vagrant

hdfs dfs -rmr /tmp/phoenix_data
hdfs dfs -rmr /user/vagrant/.Trash
sudo bash -c "rm -rf /var/lib/hadoop/yarn/node/usercache/hbase/appcache/application_*"
sudo yum -y install epel-release
sudo yum -y install python-pip
sudo pip install importlib

# Generate data.
echo "Generating Data"
mkdir -p /tmp/phoenix_data
cd /tmp/phoenix_data
for i in 0 1; do
	for j in 0 1 2 3 4 5 6 7 8 9; do
		k=`expr $i \* 10 + $j`
		python /vagrant/modules/benchmetrics/files/generator/generate.py -w phoenix -s 100 -c $k &
	done
	wait
done

# Copy into HDFS and remove.
hdfs dfs -copyFromLocal /tmp/phoenix_data /tmp/phoenix_data
rm -f /tmp/phoenix_data/*.txt

# Create the table.
/usr/hdp/2.3.4.0-3485/phoenix/bin/sqlline.py -f /vagrant/modules/benchmetrics/files/phoenix/phoenix_bulkload/create_table.sql

# Allow sudo access for HBase so we can track YARN disk usage.
sudo cp /vagrant/modules/benchmetrics/files/phoenix/phoenix_bulkload/493_hbase /etc/sudoers.d
