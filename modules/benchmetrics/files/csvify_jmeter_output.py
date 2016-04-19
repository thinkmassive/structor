#!/usr/bin/python

from optparse import OptionParser

import csv
import glob
import re
import sys

def main():
	example = "csvify_jmeter_output.py -f raw_something.xml -n 8 -r 1 -s 200"
	parser = OptionParser(epilog=example)
	parser.add_option("-f", "--file")
	parser.add_option("-n", "--nodes")
	parser.add_option("-r", "--runid")
	parser.add_option("-s", "--scale")
	(options, args) = parser.parse_args()
	if options.file == None:
		print "Error: Must specify file (-f)"
		parser.print_help()
		sys.exit(1)
	if options.nodes == None:
		print "Error: Must specify node count (-n)"
		parser.print_help()
		sys.exit(1)
	if options.runid == None:
		print "Error: Must specify runid (-r)"
		parser.print_help()
		sys.exit(1)
	if options.scale == None:
		print "Error: Must specify scale (-s)"
		parser.print_help()
		sys.exit(1)
	process(options)

def process(options):
	printedHeadings = False
	files = [ options.file ]
	record_writer = csv.writer(sys.stdout)

	for f in files:
		# output = f + ".csv"
		m = re.search("x(\d+)", f)
		users = 0
		if m:
			users = m.group(1)
		ifd = open(f)
		# ofd = open(output, "w")
		for line in ifd:
			m = re.finditer('(\S+)="([^"]+)"', line)
			if m:
				stuff = []
				headings = []
				for x in m:
					key = x.group(1)
					val = x.group(2)
					headings.append(key)
					stuff.append(val)
					if key == "t":
						theTime = val
					if key == "ts":
						theStart = val
					if key == "lb":
						label = val
				stuff.append(users)
				stuff.append(options.scale)
				stuff.append(options.runid)
				stuff.append(options.nodes)
				headings.append("nuser")
				headings.append("scale")
				headings.append("runid")
				headings.append("nodes")
				headings.append("query")
				headings.append("end")
				headings.append("time")
				if not printedHeadings:
					headingText = ",".join(headings)
					if len(headings) > 15:
						print headingText
						printedHeadings = True
				output = ",".join(stuff)
				if len(output) > 30:
					# Computed fields.
					m = re.search('jpmc-(\d+)', label)
					if m:
						query = m.group(1)
						stuff.append(query)
					theEnd = str(int(theStart) + int(theTime))
					stuff.append(theEnd)
					stuff.append(str(int(theTime) * 1.0 / 1000))
					record_writer.writerow(stuff)

if __name__ == "__main__":
	main()
