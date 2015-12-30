#!/bin/sh

SUCCESS=/home/vagrant/sa_golden_stats_successful

if [ ! -e $SUCCESS ]; then
	( cd /vagrant/modules/sa_golden/files ; /vagrant/modules/sa_golden/files/load_schema_only.sh && touch $SUCCESS )
fi
