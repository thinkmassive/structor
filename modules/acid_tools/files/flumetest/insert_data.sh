#!/bin/sh

TARGET=/tmp/acid_source
PID=$$
RUNID=$1
SOURCE=$2
SLEEP_TIME=${3:-15}
GENERATION=1
CLEAN_MINS=3

if [ -z "$RUNID" -o -z "$SOURCE" ]; then
	echo "Usage: $0 runid data_file [sleep_time]"
	exit 1
fi

while [ 1 -gt 0 ]; do
	# Add in some new data.
	FILE=$TARGET/$GENERATION.$PID.csv
	echo "Adding data to $FILE"
	sed -e "s/$/,$RUNID,$GENERATION/" $SOURCE > temp.csv
	mv temp.csv $FILE
	GENERATION=`expr $GENERATION + 1`

	# Wait a while.
	echo Waiting
	sleep $SLEEP_TIME

	# Delete files more than CLEAN_MINS old.
	echo Cleaning
	rm -f $(find $TARGET -type f -mmin +$CLEAN_MINS)
done
