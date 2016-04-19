#!/usr/bin/python

import datetime
import glob
import itertools
import json
import logging
import math
import os
import pprint
import re
import sys
from optparse import OptionParser

def main():
	if len(sys.argv) > 1:
		path = sys.argv[1]
	else:
		path = "."
	files = glob.glob("%s/*.sql*" % path)

	print "query\tvertex\testimate\tactual\tlog10ratio"
	for f in files:
		process_file(f)

def process_file(f):
	#print f
	with open(f) as fd:
		# Initialize.
		query_counters = {}

		# Read the ATS data and split it.
		text = fd.read()
		chunks = re.split("-- [A-Z][^\n]+", text, re.MULTILINE)
		plan_text = chunks[2]
		if plan_text.strip() == "ERROR":
			return
		plan = json.loads(chunks[2])
		stages = plan['STAGE PLANS']
		dependencies = plan['STAGE DEPENDENCIES']

		# We use the smallest number as the row output estimates.
		for stage in stages:
			if "Tez" in stages[stage]:
				vertices = stages[stage]['Tez']['Vertices:']
				for (k, v) in vertices.iteritems():
					vertex_string = str(v)

					# Limit to just the stuff after Reduce Output Operator.
					# This won't exist for CTAS queries.
					reduce_string = ""
					m = re.search("(Reduce Output Operator.+)", vertex_string)
					if m:
						reduce_string = m.group(0)

					i = re.finditer("Num rows: (\d+)", reduce_string)
					possibles = [ long(x.group(1)) for x in list(i) ]
					if len(possibles) > 0:
						min_rows = min(possibles)
						query_counters[k] = {}
						#print "Set", k, " = ", min_rows
						query_counters[k]['estimate'] = min_rows

		# Now the actual outputs.
		counters = chunks[3]
		counter_records = [ x.strip() for x in counters.split(",") ]
		for r in counter_records:
			if r.find("RECORDS_OUT_INTERMEDIATE") > -1:
				m = re.search("RECORDS_OUT_INTERMEDIATE_([^']+)': (\d+)", r)
				vertex = m.group(1).replace("_", " ")
				count = m.group(2)
				query_counters[vertex]['actual'] = count

		# Summarize.
		for (vertex, values) in query_counters.iteritems():
			if "actual" in values:
				ratio = math.log10(long(values['estimate']) * 1.0 / long(values['actual']))
				print "{0}\t{1}\t{2}\t{3}\t{4:.3f}".format(f, vertex, values['estimate'], values['actual'], ratio)

if __name__ == "__main__":
	main()
