{
  "hdp_short_version": "2.3.2",

  "vm_mem": 4096,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": true,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "tez", "yarn", "odbc" ],

  "nodes": [
    {"hostname": "odbc1", "ip": "240.0.0.11",
     "roles": ["client", "kdc", "hive-db", "hive-meta", "hive-server2", "nn", "slave", "yarn", "zk"]},
    {"hostname": "odbc2", "ip": "240.0.0.12",
     "roles": ["client", "hive-server2", "slave"]}
  ],

  "extras": [ "sample-hive-data" ]
}
