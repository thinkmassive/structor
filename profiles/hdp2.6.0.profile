{
  "hdp_short_version": "2.6.0",
  "java_version": "java-1.8.0-openjdk",
  "vm_mem": 8192,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "tez", "yarn", "yarnlocaltop" ],
  "nodes": [
    {"hostname": "hdp2.6.0", "ip": "192.168.59.11",
     "roles": ["client", "hive-db", "hive-meta", "hive-server2", "nn", "slave", "yarn", "yarn-timelineserver"]}
  ],

  "hive_options" : "interactive",

  "extras": [ "sample-hive-data" ]
}
