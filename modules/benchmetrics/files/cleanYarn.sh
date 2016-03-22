#!/bin/sh

sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/vagrant/appcache -cmin +5 -delete"
sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/hbase/appcache -cmin +5 -delete"
sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/hive/appcache -cmin +10 -delete"
true
