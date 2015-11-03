{
  "hdp_short_version": "2.3.2",
  "os": "ubuntu14",
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": true,
  "vm_mem": 4096,
  "vm_cpus": 4,
  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,
  "clients" : [ "hbase", "hdfs", "zk" ],
  "nodes": [
    {"hostname": "ubuntu", "ip": "240.0.0.11",
     "roles": ["client", "hbase-master", "hbase-regionserver", "kdc", "nn", "slave", "zk"]}
  ]
}
