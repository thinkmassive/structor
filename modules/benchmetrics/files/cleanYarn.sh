#!/bin/sh

sudo bash -c "find /var/lib/hadoop/yarn/node/usercache/vagrant/appcache -cmin +5 -delete"
true
