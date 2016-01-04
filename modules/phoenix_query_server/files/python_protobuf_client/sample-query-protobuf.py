#!/usr/bin/python

import random
import sys
import urllib2

# Protobuf bindings.
import common_pb2
import requests_pb2
import responses_pb2

# Sample query counts the number of items in the system catalog.
pqsUrl = "http://localhost:8765/"

def make_request(pqsUrl, request, response):
	print "Sending : "
	print request
	wire_message = common_pb2.WireMessage()
	wire_message.name = "org.apache.calcite.avatica.proto.Requests$" + request.DESCRIPTOR.name
	wire_message.wrapped_message = request.SerializeToString()
	request_ser = wire_message.SerializeToString()
	handler = urllib2.urlopen(pqsUrl, request_ser)
	response_ser = handler.read()
	wire_message = common_pb2.WireMessage()
	wire_message.ParseFromString(response_ser)
	response.ParseFromString(wire_message.wrapped_message)
	print "Response : "
	print response
	return response

def random_string(len):
	hex_characters = "0123456789abcdef"
	return ''.join(random.choice(hex_characters) for _ in range(len))

lengths = [ 8, 4, 4, 4, 12 ]
connection_id = "-".join([random_string(x) for x in lengths])

# Open a connection.
print "Opening connection."
request = requests_pb2.OpenConnectionRequest()
request.connection_id = connection_id
request.info["user"] = "none"
request.info["password"] = "none"
response = responses_pb2.OpenConnectionResponse()
make_request(pqsUrl, request, response)

print "\nSyncing connection."
request = requests_pb2.ConnectionSyncRequest()
request.connection_id = connection_id
request.conn_props.auto_commit = True
request.conn_props.read_only = False
request.conn_props.transaction_isolation = 0
request.conn_props.catalog = ""
request.conn_props.schema = ""
request.conn_props.is_dirty = True
response = responses_pb2.ConnectionSyncResponse()
make_request(pqsUrl, request, response)

print "\nCreating statement."
request = requests_pb2.CreateStatementRequest()
request.connection_id = connection_id
response = responses_pb2.CreateStatementResponse()
response = make_request(pqsUrl, request, response)
statement_id = response.statement_id

print "\nRunning query."
request = requests_pb2.PrepareAndExecuteRequest()
request.connection_id = connection_id
request.statement_id = statement_id
request.sql = "select count(*) from system.catalog"
request.max_row_count = 100
response = responses_pb2.ExecuteResponse()
response = make_request(pqsUrl, request, response)
count = response.results[0].first_frame.rows[0].value[0].value[0].number_value
print "QUERY RESULT = ", count

print "\nClosing statement."
request = requests_pb2.CloseStatementRequest()
request.connection_id = connection_id
request.statement_id = statement_id
response = responses_pb2.CloseStatementResponse()
response = make_request(pqsUrl, request, response)

print "\nClosing connection."
request = requests_pb2.CloseConnectionRequest()
request.connection_id = connection_id
response = responses_pb2.CloseConnectionResponse()
response = make_request(pqsUrl, request, response)
