#!/bin/sh

/usr/hdp/current/phoenix-client/bin/sqlline.py -f /vagrant/modules/benchmetrics/files/phoenix/tpch/queries/all-queries-serial.sql
