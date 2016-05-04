{
  "hdp_short_version": "2.5.0",
  "java_version": "java-1.8.0-openjdk",
  "vm_mem": 8192,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hbase", "hdfs", "yarn", "zk"],
  "nodes": [
    {"hostname": "hdp250-hbase", "ip": "192.168.59.11",
     "roles": ["client", "hbase-master", "hbase-regionserver", "httpd", "kdc", "nn",
               "phoenix-query-server", "slave", "yarn", "zk"]}
  ]
}
