{
  "hdp_short_version": "2.5.0",
  "os": "centos7",
  "java_version": "java-1.8.0-openjdk",
  "vm_mem": 6144,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": true,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hbase", "hdfs", "odbc-phoenix", "yarn", "zk"],
  "nodes": [
    {"hostname": "hdp250-hbase-secure", "ip": "192.168.59.11",
     "roles": ["client", "hbase-master", "hbase-regionserver", "httpd", "kdc", "nn",
               "phoenix-query-server", "slave", "yarn", "zk"]}
  ]
}
