#!/usr/bin/python

# This module is an add-on, you may need to install it if you are using Python 2.6.
from dateutil.parser import parse

import datetime
import json
import logging
import os
import pipes
import pprint
import urllib2 as url
import xml.etree.ElementTree as ET
from optparse import OptionParser

def main():
	parser = OptionParser()
	parser.add_option("-D", "--debug", help="debug", default=False, action='store_true')
	parser.add_option("-S", "--secure", help="Connect to secure cluster", default=False, action='store_true')
	parser.add_option("-a", "--ats", help="ATS endpoint (e.g. http://yarn.example.com:8188)")
	parser.add_option("-e", "--end", help="End time in epoch seconds")
	parser.add_option("-s", "--start", help="Start time in epoch seconds")
	parser.add_option("-u", "--user", help="User name to use")

	(options, args) = parser.parse_args()
	# Turn on debugging if requested.
	if options.debug:
		logger = logging.getLogger()
		logging.basicConfig(level=logging.DEBUG)
		logger.setLevel(logging.DEBUG)

	# Handle secure.
	if options.secure:
		import urllib2_kerberos as u2k

	# Get the ATS endpoint if it's not given.
	if options.ats == None:
		options.ats = getAtsEndpoint()

	# Handle time ranges.
	now       = datetime.datetime.now()
	yesterday = now - datetime.timedelta(days=1)

	if options.start != None:
		try:
			start = parse(options.start)
			options.start = start
		except:
			print "Unknown date/time string", options.start
			return 1
	else:
		# Default to yesterday.
		options.start = yesterday
	if options.end != None:
		try:
			end = parse(options.end)
			options.end = end
		except:
			print "Unknown date/time string", options.end
			return 1
	else:
		# Default to now.
		options.end = now

	# Mention the time range we are going after.
	print "Looking for queries between %s and %s" % (options.start, options.end)

	dags = getDags(options)
	print "Found %d queries" % len(dags)
	if len(dags) > 0:
		for d in dags:
			if "dagPlan" not in d["otherinfo"]:
				continue
			if "dagInfo" not in d["otherinfo"]["dagPlan"]:
				continue
			user = d['otherinfo']['user']
			hiveQuery = d["otherinfo"]["dagPlan"]["dagInfo"]
			parsed = json.loads(hiveQuery)
			hiveQuery = parsed['description']
			counters = extractCounters(d)
			applicationId = d['otherinfo']['applicationId']
			settings = getDagSettings(options, applicationId)

			if "dagContext" in d['otherinfo']['dagPlan']:
				hiveId = d['otherinfo']['dagPlan']['dagContext']['callerId']
			else:
				dag = d['otherinfo']['dagPlan']['dagName']
				hiveId = dag.split(":")[0]
			hiveExtras = getExtraHiveInfo(options, hiveId)
			if hiveExtras != None:
				if "QUERY" in hiveExtras['otherinfo']:
					queryDict = json.loads(hiveExtras['otherinfo']['QUERY'])
					queryPlan = queryDict['queryPlan']
				else:
					queryPlan = {}
			sqlName = "%s.%s.sql" % (hiveId, user)

			with open(sqlName, "w") as fd:
				pp = pprint.PrettyPrinter(indent=2, stream=fd)
				fd.write("-- Query Text\n")
				fd.write(hiveQuery)
				fd.write("\n-- Query Plan\n")
				if hiveExtras != None:
					fd.write(json.dumps(queryPlan))
				else:
					fd.write("ERROR")
				fd.write("\n-- Job Counters\n")
				pp.pprint(counters)
				fd.write("\n-- Job Settings\n")
				pp.pprint(settings)

def getExtraHiveInfo(options, id):
	atsUrl = "%s/ws/v1/timeline/HIVE_QUERY_ID/%s" % (options.ats, id)
	logger = logging.getLogger()
	logger.debug("Settings Hive url %s" % atsUrl)
	try:
		if options.secure:
			opener = url.build_opener(u2k.HTTPKerberosAuthHandler())
		else:
			opener = url.build_opener()
		opened = opener.open(atsUrl)
		response = opened.read()
		objects = json.loads(response)
		return objects
	except:
		return None

def getDagSettings(options, applicationId):
	applicationId.replace("application", "tez")
	logger = logging.getLogger()
	atsUrl = "%s/ws/v1/timeline/TEZ_APPLICATION/tez_%s" % (options.ats, applicationId)
	logger.debug("Settings url %s" % atsUrl)
	if options.secure:
		opener = url.build_opener(u2k.HTTPKerberosAuthHandler())
	else:
		opener = url.build_opener()
	opened = opener.open(atsUrl)
	response = opened.read()
	objects = json.loads(response)
	if "config" not in objects['otherinfo']:
		return {}
	return objects['otherinfo']['config']

def extractCounters(dag):
	allcounters = {}

	# This happens some times, not sure why.
	if "counters" not in dag["otherinfo"]:
		return allcounters
	if "counterGroups" not in dag["otherinfo"]["counters"]:
		return allcounters

	groups = dag["otherinfo"]["counters"]["counterGroups"]
	for g in groups:
		counters = g["counters"]
		for c in counters:
			counterName = c["counterName"]
			counterValue = c["counterValue"]
			allcounters[counterName] = counterValue

	return allcounters

def toMs(t):
	epoch = datetime.datetime.utcfromtimestamp(0)
	td = t - epoch
	retval = ((td.microseconds + (td.seconds + td.days * 24 * 3600) * 10**6) / 10**6) * 1000
	return retval

def getDags(options):
	windowSize = 100
	parameters = {}
	dags = []
	id = 0

	logger = logging.getLogger()
	start = toMs(options.start)
	end = toMs(options.end)
	retrieved = 100
	parameters["windowStart"] = start
	parameters["windowEnd"] = end
	while retrieved == 100:
		query = "&".join([
			x + "=" + str(parameters[x])
			for x in parameters.keys()
			if parameters[x] != None ])
		atsUrl = "%s/ws/v1/timeline/TEZ_DAG_ID?%s" % (options.ats, query)
		logger.debug("Request url %s" % atsUrl)
		if options.secure:
			opener = url.build_opener(u2k.HTTPKerberosAuthHandler())
		else:
			opener = url.build_opener()
		opened = opener.open(atsUrl)
		response = opened.read()
		objects = json.loads(response)
		newDags = objects["entities"]
		retrieved = len(newDags)
		if retrieved == 0:
			return dags
		lastTime = newDags[-1]["starttime"]
		parameters["windowEnd"] = lastTime
		dags.extend(newDags)
	return dags

def getAtsEndpoint():
	parameters = {}

	# Parse hive site to get database connection details.
	logger = logging.getLogger()
	logger.info("Getting ATS endpoint from configuration files")
	hive_site = "/etc/hadoop/conf/yarn-site.xml"
	if not os.path.isfile(hive_site):
		raise OSError("Cannot find yarn-site.xml")
	tree = ET.parse(hive_site)
	attributes = {}
	for property in tree.findall("property"):
		(name, value) = property.getchildren()[:2]
		attributes[name.text] = value.text

	endpoint = "http://" + attributes["yarn.timeline-service.webapp.address"]
	logger.info("ATS endpoint is %s" % endpoint)
	return endpoint

if __name__ == "__main__":
	main()
