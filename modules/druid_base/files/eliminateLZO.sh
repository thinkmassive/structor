#!/bin/sh

CONF=/usr/local/share/druid/conf/druid/_common

# Eliminate classpath references.
sudo perl -i.orig -pe 's/:[^:]+lzo[^:]+.jar//gi' $CONF/mapred-site.xml $CONF/yarn-site.xml

# Eliminate codec options.
sudo perl -i.orig -pe 's/,[^,]+lzo[^,]+//gi' $CONF/core-site.xml
