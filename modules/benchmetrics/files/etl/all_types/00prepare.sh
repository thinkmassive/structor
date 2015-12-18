#!/bin/sh

sudo service hive-server2 stop
sudo pip install importlib

# Generate data.
echo "Generating Data"
cd /tmp
for i in 0 1 2 3 4 5 6 7 8 9; do
	python /vagrant/modules/benchmetrics/files/generator/generate.py -w allTypes -s 10 -c $i &
done
wait

hive -f /vagrant/modules/benchmetrics/files/etl/all_types/load_all_types_csv.sql
