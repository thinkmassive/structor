#!/bin/sh

sudo usermod -a -G hadoop vagrant

sudo service hive-server2 stop
hdfs dfs -rmr /user/vagrant/.Trash
sudo bash -c "rm -rf /var/lib/hadoop/yarn/node/usercache/vagrant/appcache/application_*"
sudo pip install importlib

# Generate data.
echo "Generating Data"
cd /tmp
for i in 0 1 2 3 4 5 6 7 8 9; do
	python /vagrant/modules/benchmetrics/files/generator/generate.py -w allTypes -s 10 -c $i &
done
wait

hive -f /vagrant/modules/benchmetrics/files/etl/all_types/load_all_types_csv.sql
rm -f /tmp/all_types*
