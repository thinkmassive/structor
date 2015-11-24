#!/bin/sh

# Sample query counts the number of items in the system catalog.

read -r -d '' QUERY <<'EOF'
request: {
  "request" : "prepareAndExecute",
  "connectionId" : "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "sql" : "select count(*) from SYSTEM.CATALOG",
  "maxRowCount" : -1
}
EOF
QUERY=$(echo $QUERY | tr -d "\r")

curl -XPOST -H "$QUERY" http://localhost:8765/
