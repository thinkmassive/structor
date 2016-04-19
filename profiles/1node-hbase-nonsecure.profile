{
  "hdp_short_version": "2.3.4",
  "vm_mem": 8192,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "clients" : [ "hbase", "hdfs", "yarn", "zk"],
  "nodes": [
    {"hostname": "hbase", "ip": "240.0.0.11",
     "roles": ["client", "hbase-master", "hbase-regionserver", "nn", "phoenix-query-server", "slave", "yarn", "zk"]}
  ]
}
