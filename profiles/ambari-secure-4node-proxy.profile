{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": true,
  "vm_mem": 3072,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ "hdfs", "pig", "tez", "yarn", "zk" ],
  "nodes": [
    { "hostname": "gw", "ip": "240.0.0.10", "roles": [ "ambari-server", "ambari-agent", "kdc", "proxy-server" ] },
    { "hostname": "nn", "ip": "240.0.0.11", "roles": [ "ambari-agent", "proxy-client" ] },
    { "hostname": "slave1", "ip": "240.0.0.12", "roles": [ "ambari-agent", "proxy-client" ] },
    { "hostname": "slave2", "ip": "240.0.0.13", "roles": [ "ambari-agent", "proxy-client" ] }
  ]
}
