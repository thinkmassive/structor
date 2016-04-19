{
  "os": "centos7",
  "hdp_short_version": "2.3.4",
  "vm_mem": 8192,
  "vm_cpus": 4,

  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "clients" : [ "hdfs", "hive", "tez", "yarn", "zk" ],
  "nodes": [
    {"hostname": "acid", "ip": "192.168.59.20",
     "roles": ["client", "flume-server", "hive-db", "hive-meta", "hive-server2", "kafka", "nn", "slave", "yarn", "zk"]}
  ],

  "hive_options" : "acid"
}
