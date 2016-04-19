#!/bin/sh

curl -X POST 'http://localhost:8082/druid/v2/?pretty' -H 'content-type: application/json' -d@/home/vagrant/TimeBoundaryQuery.json
curl -X POST 'http://localhost:8082/druid/v2/?pretty' -H 'content-type: application/json' -d@/home/vagrant/TimeSeriesQuery.json

