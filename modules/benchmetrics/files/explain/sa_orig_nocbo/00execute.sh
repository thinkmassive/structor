#!/bin/sh

cd /vagrant/modules/sa_golden/files/sa
hive --hiveconf hive.cbo.enable=false -f /vagrant/modules/sa_golden/files/sa/saexplain.sql > /dev/null 2>&1
