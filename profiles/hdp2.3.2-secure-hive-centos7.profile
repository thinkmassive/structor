{
  "hdp_short_version": "2.3.2",
  "os": "centos7",
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": true,
  "vm_mem": 4096,
  "vm_cpus": 4,
  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,
  "clients" : [ "hdfs", "hive", "tez", "yarn", "zk" ],
  "nodes": [
    {"hostname": "hdp232-secure", "ip": "240.0.0.11",
     "roles": ["client", "kdc", "hive-db", "hive-meta", "hive-server2", "nn", "slave", "yarn", "zk"]}
  ]
}
