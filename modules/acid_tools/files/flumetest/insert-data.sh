#!/bin/sh

TARGET=/tmp/acid_source
PID=$$
ID=1
SLEEP_TIME=${1:-15}
CLEAN_MINS=5

while [ 1 -gt 0 ]; do
	# Add in some new data.
	FILE=$TARGET/$ID.$PID.csv
	echo "Copy sample.csv to $FILE"
	cp sample.csv $TARGET/$ID.$PID.csv
	ID=`expr $ID + 1`

	# Wait a while.
	echo Waiting
	sleep $SLEEP_TIME

	# Delete files more than CLEAN_MINS old.
	echo Cleaning
	rm -f $(find $TARGET -type f -mmin +$CLEAN_MINS)
done
