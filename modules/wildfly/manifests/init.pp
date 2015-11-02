#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# Install a Wildfly (fka JBoss) app server and register Phoenix JDBC.
# Admin port = :9990

class wildfly {
  require jdk
  require hbase_client

  $java="/usr/lib/jvm/java"
  $path="${java}/bin:/bin:/usr/bin:/usr/sbin"

  $wildfly_version="9.0.1.final"
  $wildfly_filename="wildfly-$wildfly_version"
  $wildfly_archive_name="$wildfly_filename.tar.gz"
  $wildfly_download_address="http://download.jboss.org/wildfly/$wildfly_version/$wildfly_archive_name"
  $install_dir="/usr/share"
  $wildfly_home="$install_dir/$wildfly_filename"
  $wildfly_conf="/etc/default/wildfly.conf"
  $wildfly_user="wildfly"
  $wildfly_pass="password"

  $jboss_cli = "$wildfly_home/bin/jboss-cli.sh"
  $modules_base = "$wildfly_home/modules/system/layers/base"
  $driver_dir = "$modules_base/org/apache/phoenix/jdbc/PhoenixDriver"

  package { "curl":
    ensure => installed,
    before => exec["curl -o $wildfly_download_address"],
  }

  # Install Wildfly.
  exec { "curl -o $wildfly_download_address":
    cwd => "/tmp",
    path => "$path",
  }
  ->
  exec { "tar -xzf $wildfly_archive_name -c $install_dir":
    cwd => "/tmp",
    path => "$path",
    creates => "$wildfly_home",
  }
  ->
  exec { "adduser $wildfly_user":
    cwd => "/",
    path => "$path",
    unless => "id -u $wildfly_user",
  }
  ->
  exec { "chown -fr $wildfly_user:$wildfly_user $wildfly_home/":
    cwd => "/",
    path => "$path",
    before => File["$modules_base/org"],
  }

  # Register Phoenix JDBC into Wildfly. Does not create a DataSource.
  $module_add = "'module add --name=org.apache.phoenix.jdbc.PhoenixDriver --resources=$driver_dir/phoenix-client.jar'"
  $jdbc_add = '"/subsystem=datasources/jdbc-driver=PhoenixDriver:add(driver-name=PhoenixDriver,driver-module-name=org.apache.phoenix.jdbc.PhoenixDriver)"'

  file { [ "$modules_base/org", "$modules_base/org/apache", "$modules_base/org/apache/phoenix",
	   "$modules_base/org/apache/phoenix/jdbc", "$modules_base/org/apache/phoenix/jdbc/PhoenixDriver" ]:
    ensure => 'directory',
    owner => $wildfly_user,
    group => $wildfly_user,
    mode => '755',
  }
  ->
  file { "$driver_dir/phoenix-client.jar":
    ensure => 'link',
    target => "/usr/hdp/current/phoenix-client/phoenix-client.jar",
  }
  ->
  file { "$driver_dir/module.xml":
    ensure => "file",
    owner => $wildfly_user,
    group => $wildfly_user,
    content => template('wildfly/module.xml'),
  }
  ->
  exec { "$jboss_cli --connect --user=$wildfly_user --password=$wildfly_pass --command=$module_add":
    cwd => "/",
    environment => "JAVA_HOME=${java}",
    path => "$path",
    creates => "$wildfly_home/modules/org/apache/phoenix/jdbc/PhoenixDriver",
    require => Service["wildfly"],
  }
  ->
  exec { "$jboss_cli --connect --user=$wildfly_user --password=$wildfly_pass --command=$jdbc_add":
    cwd => "/",
    environment => "JAVA_HOME=${java}",
    path => "$path",
    unless => "grep PhoenixDriver $wildfly_home/standalone/configuration/standalone.xml",
    require => Service["wildfly"],
  }

  # Create an admin user.
  exec { "$wildfly_home/bin/add-user.sh $wildfly_user $wildfly_pass":
    cwd => "/",
    path => "$path",
    environment => "JAVA_HOME=${java}",
    require => File["/etc/default/wildfly.conf"],
    before  => File["$driver_dir"],
  }

  # Startup script.
  case $operatingsystem {
    'centos': {
      file { "/etc/init.d/wildfly":
        ensure => 'link',
        target => "$wildfly_home/bin/init.d/wildfly-init-redhat.sh",
        require => File["/etc/default/wildfly.conf"],
      }
    }
    'ubuntu': {
      file { "/etc/init.d/wildfly":
        ensure => 'link',
        target => "$wildfly_home/bin/init.d/wildfly-init-debian.sh",
        require => File["/etc/default/wildfly.conf"],
      }
    }
  }

  # Start.
  service { "wildfly":
    ensure => running,
    enable => true,
    require => File["/etc/init.d/wildfly"],
  }

  # Environment stuff.
  file { "/etc/profile.d/wildfly.sh":
    ensure => "file",
    content => template('wildfly/wildfly.sh.erb'),
  }
  file { "/etc/default/wildfly.conf":
    ensure => "file",
    content => template('wildfly/wildfly.conf.erb'),
  }
}
