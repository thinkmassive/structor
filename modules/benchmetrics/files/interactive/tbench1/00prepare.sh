#!/bin/sh

# Ensure HS2 is started.
sudo service hive-server2 start

# Make room.
/vagrant/modules/benchmetrics/files/cleanYarn.sh

# Add data.
hive -f /vagrant/modules/benchmetrics/files/interactive/tbench1/fixed_queries/prepare.sql

# Install JMeter.
/vagrant/modules/benchmetrics/files/jmeter/install_jmeter.sh
