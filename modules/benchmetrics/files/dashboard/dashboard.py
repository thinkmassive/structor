from flask import Flask, flash, redirect, render_template, request, session, abort
import csv
import glob
import json
import itertools
import os
import re
import urllib2
 
tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
app = Flask(__name__, template_folder=tmpl_dir)

def get_number(s):
	return ''.join(re.findall('\d+', s))

def get_csv_data(version):
	records = {}
	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'benchmark_data', "{0}.csv".format(version))
	with open(path) as fd:
		reader = csv.reader(fd)
		reader.next()
		for row in reader:
			(package, test, prepare_time, execution_time) = row
			if package not in records:
				records[package] = {}
			if test not in records[package]:
				records[package][test] = { version: {} }
			records[package][test][version] = execution_time
	return records

def get_tbench1_data(version):
	records = {}
	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'benchmark_data', "{0}_tbench1.csv".format(version))
	try:
		with open(path) as fd:
			reader = csv.reader(fd)
			reader.next()
			for row in reader:
				(name, status, time) = ( row[4], row[6], row[17] )
				records[name] = time
	except:
		pass
	return records

def get_bi_timings(old_version, new_version):
	# BI queries.
	tbench1_data_v1 = get_tbench1_data(old_version)
	tbench1_data_v2 = get_tbench1_data(new_version)

	# Merge the results together.
	tbench_data= {}
	keys = tbench1_data_v1.keys()
	keys.extend(tbench1_data_v2.keys())
	for k in keys:
		old_value = tbench1_data_v1.get(k) or "0"
		new_value = tbench1_data_v2.get(k) or "0"
		tbench_data[k] = (old_value, new_value)

	# Split out "other interactive" and the rest.
	other_interactive = { get_number(k) : v for k, v in tbench_data.items() if k.startswith("hive-otherinteractive") }
	faster_queries = { get_number(k) : v for k, v in tbench_data.items() if not k.startswith("hive-otherinteractive") }
	return (other_interactive, faster_queries)

def get_tpch_times(csv_data, old_version, new_version):
	tpch_times = {}
	tpch_dict = csv_data["tpch"]
	for (k, v) in tpch_dict.iteritems():
		if k.startswith("tpch_query"):
			old_value = v.get(old_version) or "0"
			new_value = v.get(new_version) or "0"
			tpch_times[get_number(k)] = (old_value, new_value)
	return tpch_times

# Normalize any statically defined tests.
def normalize_data(csv_data, old_version, new_version):
	d = {}
	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../tests.csv')
	with open(path) as fd:
		reader = csv.reader(fd)
		reader.next()
		for l in reader:
			(component, package, test, subtest, description, enabled, cleaner, version) = l
			old_value = "0"
			new_value = "0"
			if test in csv_data[package] and old_version in csv_data[package][test]:
				old_value = csv_data[package][test][old_version]
			if test in csv_data[package] and new_version in csv_data[package][test]:
				new_value = csv_data[package][test][new_version]
			d[test] = ( old_value, new_value )
	return d

def merge_csv_data(old_data, new_data):
	csv_data = old_data
	for package in new_data.keys():
		if package not in csv_data:
			csv_data[package] = {}
		for test in new_data[package].keys():
			if test in csv_data[package]:
				csv_data[package][test].update(new_data[package][test])
			else:
				csv_data[package][test] = new_data[package][test]
	return csv_data

def get_all_versions():
	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'benchmark_data', "hdp???.csv")
	candidates = glob.glob(path)
	candidates = [ os.path.basename(x) for x in candidates ]
	versions = [ x[0:6] for x in candidates ]
	return { v : {} for v in versions }

def get_sql_coverage():
	coverage = {}
	raw = {}
	path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'benchmark_data', "sql_coverage.csv")
	with open(path) as fd:
		reader = csv.reader(fd)
		for l in reader:
			(version, score) = l
			raw[version] = float(score)

	for k in raw.keys():
		coverage[k] = (raw[k] / raw["total"]) * 100
	return coverage
 
@app.route("/")
def dashboard():
	old_version = request.args.get('old') or "hdp234"
	new_version = request.args.get('new') or "hdp250"
	all_versions = get_all_versions()
	all_versions[old_version]["old"] = True
	all_versions[new_version]["new"] = True

	old_data = get_csv_data(old_version)
	new_data = get_csv_data(new_version)
	csv_data = merge_csv_data(old_data, new_data)

	# SQL coverage data.
	coverage = get_sql_coverage()

	# Normalize most data.
	d = normalize_data(csv_data, old_version, new_version)

	# Larger sets.
	tpch = get_tpch_times(csv_data, old_version, new_version)
	(other_interactive, faster_queries) = get_bi_timings(old_version, new_version)

	# Render the charts.
	return render_template('dashboard.html', **locals())
 
if __name__ == "__main__":
	app.debug = True
	app.run()
