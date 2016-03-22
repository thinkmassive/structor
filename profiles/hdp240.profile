{
  "hdp_short_version": "2.4.0",
  "vm_mem": 9216,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "odbc", "tez", "yarn" ],
  "nodes": [
    {"hostname": "hdp240", "ip": "192.168.59.11",
     "roles": ["client", "hive-db", "hive-meta", "hive-server2",
               "httpd", "nn", "slave", "tez-ui",
               "yarn", "yarn-timelineserver"]}
  ],

  "hive_options" : "interactive",

  "extras": [ "sample-hive-data" ]
}
