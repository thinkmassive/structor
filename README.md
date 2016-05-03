# "Structor 2" -- Structor + lots of extensions
=======

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
* CentOS 6

The currently supported projects:
* Ambari

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

