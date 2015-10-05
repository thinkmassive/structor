{
  "hdp_short_version": "2.3.0",

  "vm_mem": 4096,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": true,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "phoenix", "yarn" ],

  "nodes": [
    {"hostname": "n1", "ip": "240.0.0.11",
     "roles": ["client", "hbase-regionserver", "kdc", "nn", "slave", "yarn", "zk"]},
    {"hostname": "n2", "ip": "240.0.0.12",
     "roles": ["client", "hbase-master", "hbase-regionserver", "slave"]}
  ],

  "extras": [ "sample-phoenix-data" ]
}
