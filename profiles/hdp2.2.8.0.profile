{
  "hdp_short_version": "2.2.8.0",

  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "security": false,

  "vm_mem": 3072,
  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "clients" : [ "hdfs", "hive", "pig", "tez", "yarn", "zk" ],
  "nodes": [
    {"hostname": "hdp228", "ip": "240.0.0.11",
     "roles": ["client", "hive-db", "hive-meta", "nn", "slave", "yarn", "zk"]}
  ]
}
