#!/bin/bash

set -e -x;

hive -v -f /vagrant/modules/sample_airline_data/files/ddl/text.sql;
