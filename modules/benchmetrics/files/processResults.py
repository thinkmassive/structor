#!/usr/bin/python

import sys
from optparse import OptionParser

def main():
	# Parse options.
	example = "processResults.py -f runs/hdp2.3.4.txt"
	parser = OptionParser(epilog=example)
	parser.add_option("-f", "--file")
	(options, args) = parser.parse_args()
	if options.file == None:
		print "Error: Must specify file (-f)"
		parser.print_help()
		sys.exit(1)

	extractStats(options.file)

def extractStats(file):
	with open(file) as fd:
		print "file,package,test,prepare_time,execution_time"
		prepare_time = -1
		for line in fd:
			if line.startswith("PREPARE TIME"):
				(a1, a2, package, test, prepare_time) = line.split()
			elif line.startswith("EXECUTION TIME"):
				(a1, a2, package, test, execution_time) = line.split()
				print "{0},{1},{2},{3}".format(package, test, prepare_time, execution_time)

if __name__ == "__main__":
	main()
