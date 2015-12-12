{
  "hdp_short_version": "2.2.8.0",
  "vm_mem": 6144,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "odbc", "tez", "yarn", "yarnlocaltop" ],
  "nodes": [
    {"hostname": "hdp2.2.8", "ip": "192.168.59.11",
     "roles": ["client", "hive-db", "hive-meta", "hive-server2", "nn", "slave", "yarn", "yarn-timelineserver"]}
  ],

  "hive_options" : "interactive",

  "extras": [ "sample-hive-data" ]
}
