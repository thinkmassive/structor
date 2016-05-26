import gssapi, httplib, base64
import json
import random
import socket

# To get this example on secure:
#  Be on CentOS 7. Ubuntu 14 might work too.
#  Switch PQS to JSON mode.
#  sudo yum install -y epel-release
#  sudo yum install -y python-pip krb5-devel python-devel libffi-devel
#  sudo pip install python-gssapi

HOSTNAME=socket.gethostname()
PORT=8765
URL="/"
SHOW_TOKENS = False
SHOW_HEADERS = False

# Create a Name identifying the target service
service_name = gssapi.Name('HTTP@%s' % HOSTNAME, gssapi.C_NT_HOSTBASED_SERVICE)
#service_name = gssapi.Name('HTTP@%s' % HOSTNAME)

# Create an InitContext targeting the demo service
ctx = gssapi.InitContext(service_name, mech_type=gssapi.oids.OID.mech_from_string("1.3.6.1.5.5.2"))

# Create the connection
conn = httplib.HTTPConnection("%s:%d" % (HOSTNAME, PORT))

def random_string(len):
		hex_characters = "0123456789abcdef"
		return ''.join(random.choice(hex_characters) for _ in range(len))

lengths = [ 8, 4, 4, 4, 12 ]
connection_id = "-".join([random_string(x) for x in lengths])
request = {
		"request" : "openConnection",
		"connectionId" : connection_id,
		"info" : {"password":"none","user":"none"}
}
request_json = json.dumps(request)
headers = {"Content-type": "application/octet-stream"}

# Make the first request
conn.request("POST", URL, request_json, headers)
r1 = conn.getresponse()
r1.read()

# Loop sending tokens to, and receiving tokens from, the server
# until the context is established
in_token = None
status = r1.status
while status == 401:
	print "Status 401, authenticating"
	out_token = ctx.step(in_token)
	if out_token:
		out_token = base64.b64encode(out_token)
		conn.request("POST", URL, request_json, headers={"Authorization": "Negotiate %s" % out_token})
		if SHOW_TOKENS:
			print "SENT TOKEN: %s" % out_token

	r1 = conn.getresponse()
	status = r1.status
	print "Got status", status
	if status == 500:
		assert False, "Internal server error, is PQS running in JSON mode?"
	if status == 200:
		break

	in_token = r1.getheader("www-authenticate")[10:]

	if SHOW_TOKENS:
		print "RECV TOKEN %s" % in_token

	if not in_token:
		raise Exception("No response from server.")
	in_token = base64.b64decode(in_token)

if SHOW_HEADERS:
	for header in r1.getheaders():
		print header
print r1.read()
