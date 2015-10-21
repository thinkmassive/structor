{
  "vm_mem": 6144,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "pig", "tez", "yarn" ],
  "nodes": [
    {"hostname": "ambari", "ip": "240.0.0.11",
     "roles": ["ambari-server", "ambari-views", "client", "hive-db", "hive-meta",
               "hive-server2", "nn", "slave", "yarn", "yarn-timelineserver"]}
  ],

  "hive_options" : "interactive",

  "extras": [ "sample-hive-data" ]
}
