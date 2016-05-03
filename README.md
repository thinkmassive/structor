# "Structor 2" -- Structor + lots of extensions
=======

Structor creates Hadoops.

## Get started really fast.

```
# Install VirtualBox 5 or later.
# Install Vagrant 1.8.1 or later.
git clone https://github.com/thinkmassive/structor
cd structor
ln -s profiles/support-lab.profile current.profile
vagrant up
# When that finishes, open http://192.168.59.11/ or vagrant ssh ambari-server
```

## HDP 2.4 temporary branch, hardly tested

The currently supported OSes and the providers:
* CentOS 7

The currently supported projects:
* Ambari

## Modify the cluster

Structor supports profiles that control the configuration of the
virtual cluster.  There are various profiles stored in the profiles
directory including a default.profile. To pick a different profile,
create a link in the top level directory named current.profile that
links to the desired profile.

Some profiles:
* support-lab - a three node non-secure Hadoop cluster (KDC installed, not configured) with a basic Ambari blueprint applied

The types of control knob in the profile file are:
* nodes - a list of virtual machines to create
* security - a boolean for whether kerberos is enabled
* vm_memory - the amount of memory for each vm
* clients - a list of packages to install on client machines

For each host in nodes, you define the name, ip address, and the roles for 
that node. The available roles are:

* client - client/gateway machine
* hbase-master - HBase master
* hbase-regionmaster - HBase region master
* hive-db - Hive Metastore and Oozie backing mysql
* hive-meta - Hive Metastore
* kdc - kerberos kdc
* nn - HDFS NameNode
* oozie - Oozie master
* slave - HDFS DataNode & Yarn NodeManager
* yarn - Yarn Resource Manager and MapReduce Job History Server
* zk - Zookeeper Server

## Bring up the cluster

Use `vagrant up` to bring up the cluster. This will take 30 to 40 minutes for 
a 3 node cluster depending on your hardware and network connection.

Use `vagrant ssh ambari-server` to login to the gateway machine. If you configured 
security, you'll need to kinit before you run any hadoop commands.

## Set up on Mac

### Add host names

in /etc/hosts:
```
192.168.59.11 ambari-server.support.com ambari-server
192.168.59.12 ambari-slave1.support.com ambari-slave1
192.168.59.13 ambari-slave2.support.com ambari-slave2
```

### Finding the Web UIs

Refer to Ambari for component placement

### Set up Kerberos (for security)

in /etc/krb5.conf:
```
[logging]
  default = FILE:/var/log/krb5libs.log
  kdc = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log

[libdefaults]
  default_realm = EXAMPLE.COM
  dns_lookup_realm = false
  dns_lookup_kdc = false
  ticket_lifetime = 24h
  renew_lifetime = 7d
  forwardable = true
  udp_preference_limit = 1

[realms]
  EXAMPLE.COM = {
    kdc = nn.example.com
    admin_server = nn.example.com
  }

[domain_realm]
  .example.com = EXAMPLE.COM
  example.com = EXAMPLE.COM
```

You should be able to kinit to your new domain (user: vagrant and 
password: vagrant):

```
% kinit vagrant@EXAMPLE.COM
```

### Set up browser (for security)

Do a `/usr/bin/kinit vagrant` in a terminal. I've found that the browsers
won't use the credentials from MacPorts' kinit. 

Safari should just work.

Firefox go to "about:config" and set "network.negotiate-auth.trusted-uris" to 
".example.com".

Chrome needs command line parameters on every start and is not recommended.
