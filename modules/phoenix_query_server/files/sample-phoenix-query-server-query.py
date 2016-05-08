#!/usr/bin/python

import json
import pprint
import random
import socket
import sys
import urllib2 as url

# To get this example on secure:
#  Be on CentOS 7. Ubuntu 14 might work too.
#  Switch PQS to JSON mode.
#  sudo yum install -y epel-release
#  sudo yum install -y python-pip krb5-devel python-devel
#  sudo pip install urllib2_kerberos
#  sudo pip install kerberos
#  Change secure to True below

secure = False
if secure:
    import urllib2_kerberos as u2k

# Sample query counts the number of items in the system catalog.
pqsUrl = "http://{0}:8765/".format(socket.gethostname())
pp = pprint.PrettyPrinter(indent=2, stream=sys.stdout)

def make_request(pqsUrl, request):
	print "Sending : "
	pp.pprint(request)
	request_json = json.dumps(request)
	if secure:
		opener = url.build_opener(u2k.HTTPKerberosAuthHandler())
	else:
		opener = url.build_opener()
	opened = opener.open(pqsUrl, request_json)
	response_json = opened.read()
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
print "Opening connection to {0}".format(pqsUrl)
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
