{
  "os": "centos7",
  "hdp_short_version": "2.3.4",
  "vm_mem": 9216,
  "vm_cpus": 4,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": false,
  "domain": "example.com",
  "realm": "EXAMPLE.COM",

  "clients" : [ "hdfs", "hive", "maven", "tez", "yarn", "zk" ],
  "nodes": [
    {"hostname": "druid2", "ip": "192.168.59.31",
     "roles": ["client",
               "druid-broker", "druid-coordinator", "druid-historical",
               "druid-middlemanager", "druid-overlord", "druid-pivot",
               "hive-db", "hive-meta", "hive-server2", "httpd",
               "kafka", "nn", "slave", "yarn", "yarn-timelineserver", "zk"]}
  ],

  "hive_options" : "interactive",

  "extras": [ "sample-hive-data" ]
}
