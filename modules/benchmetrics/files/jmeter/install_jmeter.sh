#!/bin/sh

# Add JMeter to this VM.
JMETER_VERSION="2.13"
JMETER_BASE="apache-jmeter-$JMETER_VERSION"
JMETER_BIN="$JMETER_BASE.tgz"
JMETER_DIST="http://mirrors.ibiblio.org/apache/jmeter/binaries/$JMETER_BIN"

if [ ! -e "/usr/local/share/$JMETER_BASE" ]; then
	# Download.
	cd /tmp
	curl -C - -O $JMETER_DIST

	# Install.
	sudo tar -C /usr/local/share -xvf $JMETER_BIN

	# Link and make accessible.
	sudo ln -s /usr/local/share/$JMETER_BASE /usr/local/share/jmeter
	sudo cp /vagrant/modules/benchmetrics/files/jmeter/jmeter.sh /etc/profile.d/jmeter.sh

	rm /tmp/$JMETER_BIN
fi
