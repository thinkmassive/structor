#!/bin/sh

# Base packages from repo.
sudo yum upgrade -y nss
sudo yum install -y gcc-c++ git make

# Install Node.
cd /home/vagrant
if [ ! -f /usr/bin/node ]; then
	echo "Installing Node"
	curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -
	sudo yum install -y nodejs
fi
if [ ! -f /usr/bin/gulp ]; then
	sudo npm install -g gulp
fi
if [ ! -d /home/vagrant/node_modules/gulp ]; then
	npm install gulp
fi

# Install jq.
if [ ! -f /usr/bin/jq ]; then
	echo "Installing jq"
	pushd /usr/bin
	sudo wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
	sudo chmod 755 jq
	popd
fi

# Install sbt.
if [ ! -f /usr/bin/sbt ]; then
	echo "Installing sbt"
	curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
	sudo yum install -y sbt
fi

# Start the actual build.
echo "Starting Build"
cd /home/vagrant
export TMP_DIR=/home/vagrant/tmp/implydata/tmp
export STAGING_DIR=/home/vagrant/tmp/implydata/staging
rm -rf $TMP_DIR
rm -rf $STAGING_DIR
mkdir -p $TMP_DIR
mkdir -p $STAGING_DIR

# Build the whole thing.
VERSION=1.1.1
rm -rf imply
mkdir -p imply
pushd imply
git clone https://github.com/implydata/distribution
pushd distribution
git checkout v$VERSION

# Copy in my modified build scripts.
cp /vagrant/modules/druid_base/files/build-imply build
pushd src/build
cp /vagrant/modules/druid_base/files/build-druid druid
popd

# Perform the build.
sh build

# Package up the results.
#cd $STAGING_DIR
#tar -czf imply-$VERSION-hdp.tar.gz imply-$VERSION

# Deploy the results.
cd $STAGING_DIR
sudo mv imply-$VERSION /usr/local/share
sudo ln -s /usr/local/share/imply-$VERSION /usr/local/share/druid
sudo chown -R druid:druid /usr/local/share/imply-$VERSION
