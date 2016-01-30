#!/usr/bin/python

from faker import Factory

import sys, math, random, time
import calendar
import os
import string

from collections import namedtuple
from datetime import datetime,timedelta
from getopt import getopt
from os.path import join as path_join
from zipf import zipf

os.environ['TZ']='UTC'

basedir = os.path.dirname(__file__)

faker = Factory.create()

def parse_into(f, ttype, separator='|'):
	return [ttype._make(l.strip().split(separator)) for l in open(f)]

def to_datetime(d):
	return datetime.strptime(d, "%Y-%m-%d")

def end_of_month(d):
        d = to_datetime(d)
        (w,m) = calendar.monthrange(d.year, d.month)
	return d + timedelta(days = m-d.day)

earliest_date = to_datetime('2014-01-01')
latest_date = to_datetime('2015-12-31')

def transaction(i, aid, edate, same_month=False):
	global faker, earliest_date, latest_date
	transaction_id = 1000000000 + i
	effective_date = faker.date_time_between(start_date=to_datetime(edate), end_date=end_of_month(edate)).strftime("%Y-%m-%d")
	entry_date = effective_date 
	post_date = effective_date
	tc = random.choice(transaction_types)
	transaction_code = tc.transaction_code
	transaction_type = tc.transaction_type
	amount = random.randint(0, 100000000)/100.0
	quantity = random.randint(0, 1000) / 100.0
	product_category = "%s%d" % (random.choice(string.ascii_lowercase),random.randint(0, 999))
	last_date = latest_date
	if same_month:
		last_date = end_of_month(effective_date)
	td = faker.date_time_between(start_date=to_datetime(effective_date), end_date=last_date)
	test_date = td.strftime("%Y-%m-%d")
	test_datetime = td.strftime("%a %d %b %Y %I:%M:%S %p %z")
	transaction_location = faker.zipcode()
	transaction_state = faker.state_abbr()
	sales_person_id = random.randint(0, 10000000)
	sales_person_name = faker.name()
	random_string = faker.paragraph()
	random_number = random.randint(0, 10000000) / 23.0
	original_ccy = faker.currency_code()
	reporting_ccy = faker.currency_code()
	account_id = aid 
	return [transaction_id, entry_date, post_date, transaction_code, transaction_type, amount, quantity, product_category, test_date, test_datetime, transaction_location, transaction_state, sales_person_id, sales_person_name, random_string, random_number, original_ccy, reporting_ccy, account_id, effective_date]

def account(i, edate, same_month=False):
	global faker, earliest_date, latest_date
	account_id = 1000000000 + i
	account_number = faker.ssn() 
	at = random.choice(account_types)
	account_code = at.account_code
	account_type = at.account_type
	account_subtype = at.account_subtype
	account_subtype2 = at.account_subtype2
	account_description = faker.paragraph()
	card_number = faker.credit_card_number()
	card_security_id = faker.credit_card_security_code()
	last_date = latest_date
	if same_month:
		last_date = end_of_month(edate)
	effective_date = faker.date_time_between(start_date=to_datetime(edate), end_date=last_date).strftime("%Y-%m-%d")
	return [account_id, account_number, account_code, account_type, account_subtype, account_subtype2, account_description, card_number, card_security_id, effective_date]

def customer_accounts(i, edate):
	global faker, earliest_date, latest_date
	customer_id = 1000000000 + i
	customer_type = random.choice(customer_types)
	ssn = faker.ssn()
	company = faker.company()
	customer_name_prefix = faker.prefix()
	customer_name_last = faker.last_name()
	customer_name_first = faker.first_name()
	customer_name_suffix = faker.suffix()
	addr_street_number = faker.building_number()
	addr_street_name = faker.street_name()
	addr_line_2 = faker.secondary_address()
	addr_city = faker.city()
	addr_state = faker.state_abbr()
	addr_postal_code = faker.zipcode_plus4()
	email = faker.email()
	phone_home = faker.phone_number()
	phone_cell = faker.phone_number()
	phone_work = faker.phone_number()
	phone_work_ext = faker.random_digit_not_null_or_empty()
	date_of_birth = faker.date_time_between(start_date='-50y', end_date='-20y').strftime("%Y-%m-%d")
	driver_lic = faker.ean13()
	sex = random.choice(['M', 'F'])
	# no randomization
	effective_date = edate
	return [customer_id, customer_type, ssn, company, customer_name_prefix, customer_name_last, customer_name_first, customer_name_suffix, 
	addr_street_number, addr_street_name, addr_line_2, addr_city, addr_state, addr_postal_code, email, phone_home, phone_cell, phone_work, phone_work_ext,
	date_of_birth, driver_lic, sex, effective_date]


def write_rows(f, rs):
	for r in rs:
		f.write('|'.join(map(str,r)) + "\n")

def fake_accounts(scale=1, child=0):
	global earliest_date

	account_type = namedtuple('AccountType', ['account_code', 'account_type', 'account_subtype', 'account_subtype2', 'effective_date'])
	transaction_type = namedtuple('TransactionType', ['transaction_code', 'transaction_type'])
	account_types = parse_into(path_join(basedir, "../data/account_types.dat"), account_type)
	transaction_types = parse_into(path_join(basedir, "../data/transaction_types.dat"), transaction_type) 
	customer_types = ["corporate", "individual"]

	start_rows = 0
	end_rows = 100
	child = 0
	scale = 1
	if (child >= scale):
		print "Argument mismatch: child cannot be greater than scale"
		return 1
	if (scale > 1):
		# the distribution below corresponds to approx 100kb per customer
		start_rows = child*1024*100
		end_rows = (child+1)*1024*100
	max_accounts = 13
	max_txns = 20
	reseed_split = 100
	z1 = None
	z2 = None
	total = 0

	fname = lambda t : "%s.dat.%d" % (t, child)

	tbl_customers = open(fname("customers"), "w")
	tbl_accounts = open(fname("accounts"), "w")
	tbl_c_accounts = open(fname("customer_accounts"), "w")
	tbl_txns = open(fname("transactions"), "w")
	totals = 0
	if child == 0:
		write_rows(open(fname("account_types"), "w"), map(list, account_types))
		write_rows(open(fname("transaction_types"), "w"), map(list, transaction_types))
	for i in xrange(start_rows, end_rows):
		# reseed every 100 rows so that we can split the gen
		if (i % reseed_split == 0):
			random.seed(i)
			faker.seed(i)
			z1 = zipf(max_accounts, 1)
			z2 = zipf(max_txns, 1.1)
		edate = faker.date_time_between(start_date=earliest_date).strftime("%Y-%m-%d")
		# Customer has > 1 account, account as > 1 txn
		c_s = customer_accounts(i, edate)
		# one account in the same month
		zv = z1.next();
		a_s = [account(max_accounts*i+j, edate, zv == 1) for (k,j) in enumerate(xrange(0,zv-1))]
		# customer_id + first col is account_id, last col is effective_date
		ac_s = [[c_s[0], a[0], a[-1]] for a in a_s]
		# one txn in the same month
		zv = z2.next();
		t_s = [transaction(max_accounts*i+max_txns*j+k, a[1], a[-1], zv == 1) for (j,a) in enumerate(ac_s) for k in xrange(0, zv-1)]
		totals += len(t_s) 
		write_rows(tbl_customers, [c_s])
		write_rows(tbl_accounts, a_s)
		write_rows(tbl_c_accounts, ac_s)
		write_rows(tbl_txns, t_s)
		#print "Written %d transactions for %d customers" % (totals, i-start_rows)
	return 0

def fake_phoenix_timeseries(scale=1, child=0):
	num_days = 7 * 8
	record_interval_seconds = 15
	records_per_hour = 3600 / record_interval_seconds
	records_per_file = 24 * records_per_hour * num_days
	num_devices = scale
	total_records = records_per_hour * num_days * 24 * num_devices
	total_files = total_records / records_per_file
	one_block  = records_per_hour * num_devices
	start_rows =  child    * records_per_file
	end_rows   = (child+1) * records_per_file

	if (child >= total_files):
		print "Argument mismatch: child too large for scale"
		return 1

	table = open("timeseries.%06d.txt" % child, "w")
	tsmin = datetime(2016, 1, 1, 0, 0)
	start_timestamp = time.mktime(tsmin.timetuple())

	possible_tags = [ 'AAA', 'BBB', 'CCC', 'DDD', 'EEE' ]

	random.seed(start_rows)
	faker.seed(start_rows)
	num_tags_generator = zipf(4, 5)

	# For random walks.
	walk_values = [ random.random() for i in xrange(start_rows, end_rows) ]
	base_hr = 70
	hr = base_hr
	stock = 100

	for i in xrange(start_rows, end_rows):
		record = []
		hours_in = i / one_block
		block_offset = i - hours_in * one_block
		device_id = block_offset / records_per_hour
		device_offset = block_offset - device_id * records_per_hour
		this_time = start_timestamp + ( hours_in * 60 * 60 ) + device_offset * record_interval_seconds

		record.append(device_id)
		record.append(str(this_time))

		# Move the heart rate, but not too far.
		hr_delta = int( ((walk_values[i-start_rows] - 0.5) / 0.25) ** 3 )
		distance = base_hr - hr
		if abs(distance) > 10:
			hr_delta += distance / abs(distance)
		hr += hr_delta
		record.append("%d" % hr)

		# Temperature random around 20 plus a component for time of day.
		temp = random.normalvariate(20, 0.1)
		offset = random.normalvariate( math.sin(((this_time % 86400) / 86400) * math.pi) * 5, 0.1 )
		record.append("%0.2f" % (temp + offset))

		# Load average (float, between 0 and 10, gamma distribution)
		record.append("%0.2f" % random.gammavariate(9, 0.3))

		# Stock ticker price (float, random walk > 1, step 0.01)
		stock_delta = int( ((walk_values[i-start_rows] - 0.5) / 0.1) ** 3 )
		stock += 0.01 * stock_delta
		if stock < 1:
			stock = 1
		record.append("%0.2f" % stock)

		record.append(faker.boolean())
		tags = []
		num_tags = num_tags_generator.next() - 2
		for j in range(0, num_tags):
			tags.append(random.choice(possible_tags))
		record.append(",".join(tags))
		write_rows(table, [record])

def fake_phoenix(scale=1, child=0):
	start_rows = 0
	end_rows = 100
	if (child >= scale):
		print "Argument mismatch: child cannot be greater than scale"
		return 1
	if (scale > 1):
		start_rows = child*1024*100
		end_rows = (child+1)*1024*100

	tbl_alltypes = open("phoenix.%d.txt" % child, "w")
	reseed_split = 100

	for i in xrange(start_rows, end_rows):
		if (i % reseed_split == 0):
			random.seed(i)
			faker.seed(i)
		# PK, integerx8, doublex2, decimalx2, stringx2, booleanx2.
		record = []
		record.append(i)
		record.append(random.randint(-2147483648, 2147483647))
		record.append(random.randint(-147483648, 147483647))
		record.append(random.randint(-47483648, 47483647))
		record.append(random.randint(-7483648, 7483647))
		record.append(random.randint(-483648, 483647))
		record.append(random.randint(-83648, 83647))
		record.append(random.randint(-3648, 3647))
		record.append(random.randint(-648, 647))
		record.append("%0.8f" % random.uniform(-100000, 100000))
		record.append("%0.8f" % random.uniform(-100000, 100000))
		record.append("%0.4f" % random.gammavariate(5, 50))
		record.append("%0.4f" % random.gammavariate(5, 50))
		record.append(faker.paragraph(nb_sentences = random.randint(1, 3)))
		record.append(faker.name())
		record.append(faker.boolean())
		record.append(faker.boolean())
		write_rows(tbl_alltypes, [record])

def fake_allTypes(scale=1, child=0):
	start_rows = 0
	end_rows = 100
	if (child >= scale):
		print "Argument mismatch: child cannot be greater than scale"
		return 1
	if (scale > 1):
		start_rows = child*1024*100
		end_rows = (child+1)*1024*100

	tbl_alltypes = open("all_types.%d.txt" % child, "w")
	reseed_split = 100

	for i in xrange(start_rows, end_rows):
		if (i % reseed_split == 0):
			random.seed(i)
			faker.seed(i)
		random_tinyint = random.randint(-128, 127)
		random_smallint = random.randint(-32768, 32767)
		random_int = random.randint(-2147483648, 2147483647)
		random_bigint = random.randint(-9223372036854775808, 9223372036854775807)
		random_float = "%0.4f" % random.uniform(-1000, 1000)
		random_double = "%0.8f" % random.uniform(-100000, 100000)
		random_decimal_18_2 = "%0.2f" % random.gammavariate(5, 50)
		random_decimal_36_6 = "%0.6f" % random.gammavariate(3, 30)
		random_string = faker.paragraph(nb_sentences = random.randint(1, 7))
		random_varchar_5 = faker.zipcode()
		random_varchar_80 = faker.name()
		random_char_2 = faker.state_abbr()
		random_char_11 = faker.ssn()
		random_boolean = faker.boolean()
		random_date = faker.date_time_between(start_date=earliest_date, end_date=latest_date).strftime("%Y-%m-%d")
		random_timestamp = random_date + " 00:00:00"
		record = [ random_tinyint, random_smallint, random_int, random_bigint,
		    random_float, random_double, random_decimal_18_2, random_decimal_36_6,
		    random_string, random_varchar_5, random_varchar_80, random_char_2,
		    random_char_11, random_boolean, random_date, random_timestamp ]
		write_rows(tbl_alltypes, [record])

if __name__ == "__main__":
	workload = None
	opts, args = getopt(sys.argv[1:], "c:s:w:", ['child=', 'scale=', 'workload='])
	scale = 1
	child = 0
	for (k,v) in opts:
		if k in ['-s', '-scale']:
			scale = int(v)
		elif k in ['-c','-child']:
			child = int(v)
		elif k in ['-w','-workload']:
			workload = v

	if workload == None:
		generators = " | ".join([ x[5:] for x in locals().keys() if x.startswith("fake_") ])
		assert False, "Need -w [{0}]".format(generators)

	workload = "fake_" + workload
	function = locals()[workload]
	ret = function(scale, child)
	sys.exit(ret)
