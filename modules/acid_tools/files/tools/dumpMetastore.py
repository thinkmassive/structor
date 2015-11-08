#!/usr/bin/python

import os
import xml.etree.ElementTree as ET
from urlparse import urlparse

import HiveParser

def main():
	details = HiveParser.getConnectionDetails()
	command = HiveParser.getDumpCommand(details)
	os.system(command)

if __name__ == "__main__":
	main()
