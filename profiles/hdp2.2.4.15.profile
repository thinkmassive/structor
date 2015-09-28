{
  "hdp_short_version": "2.2.4.15",
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 4096,
  "vm_cpus": 4,
  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,
  "clients" : [ "hdfs", "hive", "tez", "yarn" ],
  "nodes": [
    {"hostname": "ey", "ip": "240.0.0.11",
     "roles": ["client", "hive-db", "hive-meta", "nn", "slave", "yarn"]}
  ]
}
