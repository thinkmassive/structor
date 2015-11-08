#!/usr/bin/python

import os
import xml.etree.ElementTree as ET
from urlparse import urlparse

import HiveParser

def main():
	details = HiveParser.getConnectionDetails()
	command = HiveParser.getConnectCommand(details)
	if details["type"] == "mysql":
		os.execv("/bin/sh", ["sh", "-c", command])

if __name__ == "__main__":
	main()
