#!/usr/bin/python

import glob
import re

printedHeadings = False
scale = "3"
runid = "3"
nodes = "8"
files = glob.glob("raw*.xml")
for f in files:
	output = f + ".csv"
	m = re.search("x(\d+)", f)
	users = 0
	if m:
		users = m.group(1)
	ifd = open(f)
	ofd = open(output, "w")
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
			stuff.append(scale)
			stuff.append(runid)
			stuff.append(nodes)
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
					ofd.write(headingText)
					ofd.write("\n")
					print headingText
					printedHeadings = True
			output = ",".join(stuff)
			if len(output) > 30:
				# Computed fields.
				m = re.search('hive-([^"]+)', label)
				if m:
					query = m.group(1)
					stuff.append(query)
				theEnd = str(int(theStart) + int(theTime))
				stuff.append(theEnd)
				stuff.append(str(int(theTime) * 1.0 / 1000))
				output = ",".join(stuff)

				ofd.write(output)
				ofd.write("\n")
				print output
