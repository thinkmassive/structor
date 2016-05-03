{
  "os": "centos6",
  "ambari_version": "2.2.1.1",
  "hdp_short_version": "2.4.0",

  "vm_mem": 3072,
  "vm_cpus": 2,

  "am_mem": 512,
  "server_mem": 768,
  "client_mem": 1024,

  "security": true,
  "domain": "support.com",
  "realm": "SUPPORT.COM",

  "clients" : [],
  "nodes": [
    {"hostname": "ambari-slave1", "ip": "192.168.59.12", "roles": ["ambari-agent"] },
    {"hostname": "ambari-slave2", "ip": "192.168.59.13", "roles": ["ambari-agent"] },
    {"hostname": "ambari-server", "ip": "192.168.59.11", "roles": ["ambari-server", "ambari-agent", "kdc", "blueprint"] }
    
  ]
}
