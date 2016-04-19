{
  "hdp_short_version": "2.5.0",
  "java_version": "java-1.8.0-openjdk",
  "vm_mem": 9216,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "hive2", "odbc", "slider", "tez", "yarn", "zk" ],
  "nodes": [
    {"hostname": "hdp250", "ip": "192.168.59.11",
     "roles": ["client", "hive-db", "hive-meta",
               "hive2", "hive2-server2",
               "httpd", "nn", "slave", "tez-ui",
               "yarn", "yarn-timelineserver", "zk"]}
  ],

  "hive_options" : "interactive",

  "extras": [ "sample-hive-data" ]
}
