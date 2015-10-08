#!/bin/sh

# See AMBARI-12780

SCRIPT=/usr/sbin/ambari-server.py
perl -0777 -i.orig -pe 's/(err = "Ambari Server is already running."\n    )raise FatalException\(1, err\)/\1args.exit_message = None\n    return/igs' $SCRIPT
