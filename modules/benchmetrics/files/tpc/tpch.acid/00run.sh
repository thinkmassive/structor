#!/bin/sh

# Run 10 updates.
i=1
while [ $i -le 10 ] ; do
	echo "Update $i"
	date
	/vagrant/modules/benchmetrics/files/tpc/tpch.acid/update-tpch-data.sh $i
	i=`expr $i + 1`
done

# Compact and query.
echo "Queue compactions"
/vagrant/modules/benchmetrics/files/tpc/tpch.acid/compact-tpch-tables.sh

echo "Run Query 1"
hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpch.acid/queries/tpch_query1.sql

# Run another 10 updates.
i=11
while [ $i -le 20 ] ; do
	echo "Update $i"
	date
	/vagrant/modules/benchmetrics/files/tpc/tpch.acid/update-tpch-data.sh $i
	i=`expr $i + 1`
done

# Query again.
echo "Run Query 1 Again"
hive -d DB=${DATABASE} -f /vagrant/modules/benchmetrics/files/tpc/tpch.acid/queries/tpch_query1.sql
