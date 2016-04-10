#!/bin/sh

pip list | grep fake

if [ $? -ne 0 ]; then
	sudo yum install -y epel-release
	sudo yum install -y python-pip
	sudo pip install fake-factory
fi
