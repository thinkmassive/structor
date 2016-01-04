#!/usr/bin/python

import json
import pprint
import random
import sys
import urllib2

# Sample query counts the number of items in the system catalog.
pqsUrl = "http://localhost:8765/"
pp = pprint.PrettyPrinter(indent=2, stream=sys.stdout)

def make_request(pqsUrl, request):
	print "Sending : "
	pp.pprint(request)
	request_json = json.dumps(request)
	handler = urllib2.urlopen(pqsUrl, request_json)
	response_json = handler.read()
	response = json.loads(response_json)
	print "Response : "
	pp.pprint(response)
	return response

def random_string(len):
	hex_characters = "0123456789abcdef"
	return ''.join(random.choice(hex_characters) for _ in range(len))

# We generate our own random connection ID.
lengths = [ 8, 4, 4, 4, 12 ]
connection_id = "-".join([random_string(x) for x in lengths])

# Open a connection.
print "Opening connection."
request = {
	"request" : "openConnection",
	"connectionId" : connection_id,
	"info" : {"password":"none","user":"none"}
}
make_request(pqsUrl, request)

print "\nSyncing connection."
request = {
	"request" : "connectionSync",
	"connectionId" : connection_id,
	"connProps" :
		{
			"connProps" : "connPropsImpl",
			"autoCommit" : True,
			"readOnly" : None,
			"transactionIsolation" : None,
			"catalog" : None,
			"schema" : None,
			"dirty" : True
		}
}
make_request(pqsUrl, request)

print "\nCreating statement."
request = {
	"request" : "createStatement",
	"connectionId" : connection_id
}
response = make_request(pqsUrl, request)
statement_id = response["statementId"]

print "\nRunning query."
request = {
	"request" : "prepareAndExecute",
	"connectionId" : connection_id,
	"statementId" : statement_id,
	"sql" : "select count(*) from system.catalog",
	"maxRowCount" : -1
}
response = make_request(pqsUrl, request)
result = response["results"][0]["firstFrame"]['rows'][0]
print "\nQuery results:", result

print "\nClosing statement."
request = {
	"request" : "closeStatement",
	"connectionId" : connection_id,
	"statementId" : statement_id
}
make_request(pqsUrl, request)

print "\nClosing connection."
request = {
	"request" : "closeConnection",
	"connectionId" : connection_id
}
make_request(pqsUrl, request)
