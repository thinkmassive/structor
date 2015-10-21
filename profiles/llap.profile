{
  "hdp_short_version": "2.3.2",
  "java_version": "java-1.8.0-openjdk",
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 8192,
  "vm_cpus": 4,
  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,
  "clients" : [ "hdfs", "hive", "tez", "yarn", "odbc", "zk" ],
  "nodes": [
    {"hostname": "llap", "ip": "240.0.0.11",
     "roles": ["client", "hive-db", "hive-meta", "hive-server2", "hive-llap",
               "nn", "postgres", "slave", "yarn", "zk"]}
  ],

  "extras": [ "sample-hive-data" ]
}
