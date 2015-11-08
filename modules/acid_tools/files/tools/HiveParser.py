#!/usr/bin/python

import commands
import os
import xml.etree.ElementTree as ET
from urlparse import urlparse

def main():
	details = getConnectionDetails()
	print details

def runSql(details, sql, type="mysql"):
	if type == "mysql":
		command = "mysql -h %s -P %s -u %s -p%s -D %s -e '%s'" % (
		    details["host"], details["port"], details["username"],
		    details["password"], details["database"], sql)
		print "--"
		os.system(command)
		print "--"
		print
	else:
		raise Exception("Unknown database type " + type)

def getDumpCommand(details, type="mysql"):
	if type == "mysql":
		command = "mysqldump -h %s -P %s -u %s -p%s %s" % (
		    details["host"], details["port"], details["username"],
		    details["password"], details["database"])
		return command
	else:
		raise Exception("Unknown database type " + type)

# Get the connection details. Currently only MySQL is supported.
def getConnectionDetails(type="mysql"):
	parameters = {}

	# Parse hive site to get database connection details.
	hive_site = "/etc/hive/conf/hive-site.xml"
	if not os.path.isfile(hive_site):
		raise OSError("Cannot find hive-site.xml")
	tree = ET.parse(hive_site)
	attributes = {}
	for property in tree.findall("property"):
		(name, value) = property.getchildren()[:2]
		attributes[name.text] = value.text

	mappings = [
		("javax.jdo.option.ConnectionUserName", "username"),
		("javax.jdo.option.ConnectionPassword", "password"),
	]
	if type == "mysql":
		if "javax.jdo.option.ConnectionURL" not in attributes:
			raise Exception("Could not determine connection URL")
		else:
			url = attributes["javax.jdo.option.ConnectionURL"][5:]
			parsed = urlparse(url)
			location = parsed.netloc.split(":")
			parameters["host"] = location[0]
			parameters["port"] = location[1] if len(location) > 1 else "3306"
			parameters["database"] = parsed.path[1:]
		for (key, value) in mappings:
			if key not in attributes:
				raise Exception("Could not determine " + value)
			else:
				parameters[value] = attributes[key]
	else:
		raise Exception("Unknown database type " + type)

	return parameters

if __name__ == "__main__":
	main()
