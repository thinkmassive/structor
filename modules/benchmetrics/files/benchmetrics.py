#!/usr/bin/python

from optparse import OptionParser

import csv
import json
import os
import subprocess
import sys
import time

DRYRUN = False

def main():
	global DRYRUN

	# Parse options.
	example = "harness.py -e hdp2.2.8.0.profile -c hive"
	parser = OptionParser(epilog=example)
	parser.add_option("-c", "--component")
	parser.add_option("-d", "--dryrun", action="store_true")
	parser.add_option("-e", "--environment")
	parser.add_option("-p", "--package")
	parser.add_option("-s", "--skipprepare", action="store_true")
	parser.add_option("-t", "--test")
	(options, args) = parser.parse_args()
	if options.environment == None and not options.skipprepare:
		print "Error: Must specify environment (-e) or -s"
		parser.print_help()
		sys.exit(1)

	# Debug and dry run.
	DRYRUN = options.dryrun

	# Load the test definitions.
	tests = loadTestDefinitions()

	# Prepare environment.
	setDirectory()
	prepareEnvironment(options)

	# Run specified tests.
	components = packages = mytests = None
	if options.component:
		components = { x:1 for x in options.component.split(",") }
	if options.package:
		packages = { x:1 for x in options.package.split(",") }
	if options.test:
		mytests = { x:1 for x in options.test.split(",") }
	runTests(tests, components, packages, mytests)

def prepareEnvironment(options):
	environment = options.environment
	if options.skipprepare:
		with open("current.profile") as fd:
			profile = json.load(fd)
			version = profile['hdp_short_version']
		print "Using existing environment", version
	else:
		print "Preparing environment", environment
		environmentFile = "profiles/" + environment + ".profile"
		os.unlink("current.profile")
		os.symlink(environmentFile, "current.profile")
		command = "vagrant up"
		(text, ret) = runCommand(command)
		if ret != 0:
			assert False, "Prepare environment failed, exiting"
		if text.find("Machine already provisioned") > -1:
			print "Machine already provisioned, waiting 90 seconds for machine to settle."
			time.sleep(90)

def getHostname():
	with open("current.profile") as fd:
		profile = json.load(fd)
		return profile['nodes'][0]['hostname']

def setDirectory():
	basedir = os.path.dirname(os.path.realpath(__file__)) + "/../../.."
	print "Changing to", basedir
	os.chdir(basedir)

def runTests(tests, components, packages, mytests):
	host = getHostname()
	for test in tests:
		# See if we are to run this test.
		(component, package, test, description) = test
		if components and component not in components:
			continue
		if packages and package not in packages:
			continue
		if mytests and test not in mytests:
			continue

		print "Running:", description, "(%s/%s)" % (package, test)
		runTest(host, package, test)

def runTest(host, package, test):
	basePath = "/vagrant/modules/benchmetrics/files"
	thisTest = "%s/%s/%s/" % (basePath, package, test)
	preparePath = "%s/00prepare.sh" % thisTest
	runPath     = "%s/00run.sh" % thisTest
	cleanPath   = "%s/00clean.sh" % thisTest

	# Prepare the test's environment.
	runScript(host, preparePath)

	# Run the test.
	startTime = time.time()
	print "START EXECUTE %s %s %s" % (package, test, startTime)
	runScript(host, runPath)
	endTime = time.time()
	print "FINISH EXECUTE %s %s %s" % (package, test, endTime)
	print "EXECUTION TIME %s %s %0.3f" % (package, test, endTime - startTime)

	# Clean up.
	runScript(host, cleanPath)

def runScript(host, path):
	command = "vagrant ssh %s -c %s" % (host, path)
	(text, ret) = runCommand(command)
	if ret != 0:
		"Script failed:", text
	else:
		print text

def runCommand(command):
	global DRYRUN

	if DRYRUN:
		print command
		return 0
	else:
		print command
		p = subprocess.Popen(["bash", "-c", command], stdout=subprocess.PIPE)
		output = p.communicate()
		returnText = output[0]
		exitCode = p.wait()
		return (returnText, exitCode)

def loadTestDefinitions():
	tests = []
	with open("tests.csv") as fd:
		cfd = csv.reader(fd)
		for line in cfd:
			tests.append(line)
	return tests

if __name__ == "__main__":
	main()
