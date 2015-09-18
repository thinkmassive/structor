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

  $WILDFLY_VERSION="9.0.1.Final"
  $WILDFLY_FILENAME="wildfly-$WILDFLY_VERSION"
  $WILDFLY_ARCHIVE_NAME="$WILDFLY_FILENAME.tar.gz"
  $WILDFLY_DOWNLOAD_ADDRESS="http://download.jboss.org/wildfly/$WILDFLY_VERSION/$WILDFLY_ARCHIVE_NAME"
  $INSTALL_DIR="/usr/share"
  $WILDFLY_HOME="$INSTALL_DIR/$WILDFLY_FILENAME"
  $WILDFLY_CONF="/etc/default/wildfly.conf"
  $WILDFLY_USER="wildfly"
  $WILDFLY_PASS="password"

  $jboss_cli = "$WILDFLY_HOME/bin/jboss-cli.sh"
  $modules_base = "$WILDFLY_HOME/modules/system/layers/base"
  $driver_dir = "$modules_base/org/apache/phoenix/jdbc/PhoenixDriver"

  package { "curl":
    ensure => installed,
    before => Exec["curl -O $WILDFLY_DOWNLOAD_ADDRESS"],
  }

  # Install Wildfly.
  exec { "curl -O $WILDFLY_DOWNLOAD_ADDRESS":
    cwd => "/tmp",
    path => "$path",
  }
  ->
  exec { "tar -xzf $WILDFLY_ARCHIVE_NAME -C $INSTALL_DIR":
    cwd => "/tmp",
    path => "$path",
    creates => "$WILDFLY_HOME",
  }
  ->
  exec { "adduser $WILDFLY_USER":
    cwd => "/",
    path => "$path",
    unless => "id -u $WILDFLY_USER",
  }
  ->
  exec { "chown -fR $WILDFLY_USER:$WILDFLY_USER $WILDFLY_HOME/":
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
    owner => $WILDFLY_USER,
    group => $WILDFLY_USER,
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
    owner => $WILDFLY_USER,
    group => $WILDFLY_USER,
    content => template('wildfly/module.xml'),
  }
  ->
  exec { "$jboss_cli --connect --user=$WILDFLY_USER --password=$WILDFLY_PASS --command=$module_add":
    cwd => "/",
    environment => "JAVA_HOME=${java}",
    path => "$path",
    creates => "$WILDFLY_HOME/modules/org/apache/phoenix/jdbc/PhoenixDriver",
    require => Service["wildfly"],
  }
  ->
  exec { "$jboss_cli --connect --user=$WILDFLY_USER --password=$WILDFLY_PASS --command=$jdbc_add":
    cwd => "/",
    environment => "JAVA_HOME=${java}",
    path => "$path",
    unless => "grep PhoenixDriver $WILDFLY_HOME/standalone/configuration/standalone.xml",
    require => Service["wildfly"],
  }

  # Create an admin user.
  exec { "$WILDFLY_HOME/bin/add-user.sh $WILDFLY_USER $WILDFLY_PASS":
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
        target => "$WILDFLY_HOME/bin/init.d/wildfly-init-redhat.sh",
        require => File["/etc/default/wildfly.conf"],
      }
    }
    'ubuntu': {
      file { "/etc/init.d/wildfly":
        ensure => 'link',
        target => "$WILDFLY_HOME/bin/init.d/wildfly-init-debian.sh",
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
