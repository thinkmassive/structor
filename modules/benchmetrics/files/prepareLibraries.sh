#!/bin/sh

sudo yum -y install epel-release
sudo yum -y install python-pip
sudo pip install importlib fake-factory kafka-python
