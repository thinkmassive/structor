from flask import Flask, flash, redirect, render_template, request, session, abort
import csv
import json
import itertools
import os
import re
import urllib2
 
tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
app = Flask(__name__, template_folder=tmpl_dir)

def get_number(s):
	return ''.join(re.findall('\d+', s))

def get_tbench1_data(version):
	records = []

	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../runs/cooked', "{0}_tbench1.csv".format(version))
	with open(path) as fd:
		reader = csv.reader(fd)
		reader.next()
		for row in reader:
			(name, status, time) = ( row[4], row[6], row[17] )
			records.append([name, get_number(name), status, time])

	return records

def get_bi_timings(old_version, new_version):
	# BI queries.
	tbench1_data_v1 = get_tbench1_data(old_version)
	tbench1_data_v2 = get_tbench1_data(new_version)

	# Merge the results together.
	tbench1_data = [ [ x[0][0], x[0][1], x[0][3], x[1][3] ] for x in zip(tbench1_data_v1, tbench1_data_v2) ]

	# Split out "other interactive" and the rest.
	other_interactive = [ x for x in tbench1_data if x[0].startswith("hive-otherinteractive") ]
	faster_queries    = [ x for x in tbench1_data if not x[0].startswith("hive-otherinteractive") ]
	return (other_interactive, faster_queries)

def get_csv_data(version):
	records = []

	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../runs/cooked', "{0}.csv".format(version))
	with open(path) as fd:
		reader = csv.reader(fd)
		reader.next()
		for row in reader:
			records.append(row)
	return records

def get_etl_comparisons(old_version, new_version):
	csv_old = get_csv_data(old_version)
	csv_new = get_csv_data(new_version)
	old = [ x for x in csv_old if x[0].startswith("etl") or x[0].startswith("tpcds") ]
	new = [ x for x in csv_new if x[0].startswith("etl") or x[0].startswith("tpcds") ]
	data = [ [ x[0][0], x[0][1], x[0][3], x[1][3] ] for x in zip(old, new) ]
	return data

def extract_data(old_version, new_version, tag):
	csv_old = get_csv_data(old_version)
	csv_new = get_csv_data(new_version)
	old = [ x for x in csv_old if x[0].startswith(tag) ]
	new = [ x for x in csv_new if x[0].startswith(tag) ]
	data = [ [ x[0][0], x[0][1], x[0][3], x[1][3] ] for x in zip(old, new) ]
	return data
 
def get_explain_timings(old_version, new_version):
	return extract_data(old_version, new_version, "explain")
 
def get_tpch_times(old_version, new_version):
	tpch_times = extract_data(old_version, new_version, "tpch")
	tpch_times = [ [ get_number(x[1]), x[1], x[2], x[3] ] for x in tpch_times ]
	return tpch_times
 
def get_interactive_features(old_version, new_version):
	return extract_data(old_version, new_version, "interactive")
 
@app.route("/")
def dashboard():
	old_version = "hdp234"
	new_version = "hdp234"

	# Stats for the dashboard.
	etl_comparisons = get_etl_comparisons(old_version, new_version)
	explain_timings = get_explain_timings(old_version, new_version)
	tpch_times      = get_tpch_times(old_version, new_version)
	interactive     = get_interactive_features(old_version, new_version)
	(other_interactive, faster_queries) = get_bi_timings(old_version, new_version)

	# Render the charts.
	return render_template('dashboard.html', **locals())
 
if __name__ == "__main__":
	app.run()
