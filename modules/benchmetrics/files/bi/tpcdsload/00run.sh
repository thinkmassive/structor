#!/bin/sh

SCALE=2

/vagrant/modules/benchmetrics/files/cleanYarn.sh
sudo service hive-server2 stop
sudo usermod -a -G hadoop vagrant

# Generate and optimize the data.
echo "Generate the data at scale $SCALE"
cd /vagrant/modules/benchmetrics/files/tpc/tpcds
sh /vagrant/modules/benchmetrics/files/tpc/tpcds/tpcds-setup.sh $SCALE
