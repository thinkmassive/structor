#!/bin/sh

exist=$(ps axwl | grep -i cleanYarnLoop | grep -v grep | wc -l)
while [ 2 -ge $exist ]; do
	sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/vagrant/appcache -cmin +40 -delete"
	sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/hbase/appcache -cmin +40 -delete"
	sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/hive/appcache -cmin +40 -delete"
	sleep 600
done
