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

class ranger_server {
  require repos_setup
  require jdk

  $java="/usr/lib/jvm/java"
  $path="/sbin:/usr/sbin:/bin:/usr/bin"
 
  # Install.
  package { "ranger${package_version}-admin" :
    ensure => installed,
  }

  # Setup admin.
  file { "/usr/hdp/${hdp_version}/ranger-admin/install.properties" :
    ensure => file,
    content => template('ranger_server/install.properties.admin.erb'),
  }
  ->
  exec { "/usr/hdp/${hdp_version}/ranger-admin/setup.sh" :
    cwd => "/usr/hdp/${hdp_version}/ranger-admin",
    environment => "JAVA_HOME=${java}",
    path => "$path",
  }

  # Setup HDFS plugin.
  file { "/usr/hdp/${hdp_version}/ranger-hdfs-plugin/install.properties" :
    ensure => file,
    content => template('ranger_server/install.properties.hdfs.erb'),
  }
  ->
  exec { "/usr/hdp/${hdp_version}/ranger-hdfs-plugin/enable-hdfs-plugin.sh" :
    cwd => "/usr/hdp/${hdp_version}/ranger-hdfs-plugin",
    environment => "JAVA_HOME=${java}",
    notify => Service['hadoop-hdfs-namenode'],
    path => "$path",
    require => Service['ranger-admin'],
  }

  # Setup Hive plugin.
  file { "/usr/hdp/${hdp_version}/ranger-hive-plugin/install.properties" :
    ensure => file,
    content => template('ranger_server/install.properties.hive.erb'),
  }
  ->
  exec { "/usr/hdp/${hdp_version}/ranger-hive-plugin/enable-hive-plugin.sh" :
    cwd => "/usr/hdp/${hdp_version}/ranger-hive-plugin",
    environment => "JAVA_HOME=${java}",
    notify => Service['hive-server2'],
    path => "$path",
    require => Service['ranger-admin'],
  }

  service { 'ranger-admin':
    ensure => running,
    enable => true,
    require => Exec["/usr/hdp/${hdp_version}/ranger-admin/setup.sh"],
  }
}
