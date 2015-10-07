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

class odbc_client {
  $path="/bin:/usr/bin"

  $version="2.0.5.1005"
  $build="hive-odbc-native-$version"
  $rpmbase="$build-1.el6.x86_64"
  $rpm="$rpmbase.rpm"
  $driver_url="http://public-repo-1.hortonworks.com/HDP/hive-odbc/$version/centos6/$rpm"

  $config_path="/usr/local/odbc"
  $odbcini_path="$config_path/odbc.ini"
  $odbcinstini_path="$config_path/odbcinst.ini"
  $driverini_path="/usr/lib/hive/lib/native/Linux-amd64-64/hortonworks.hiveodbc.ini"

  package { [ "unixODBC", "unixODBC-devel", "cyrus-sasl-gssapi", "cyrus-sasl-plain" ]:
    ensure => installed,
    before => Exec["Download ODBC"],
  }

  file { "/tmp/expected_sums_odbc.txt":
    ensure => file,
    source => "puppet:///modules/odbc_client/expected_sums_odbc.txt",
  }
  ->
  exec { "Download ODBC":
    command => "curl -O $driver_url",
    cwd => "/tmp",
    path => "$path",
    unless => "md5sum -c expected_sums_odbc.txt --quiet",
  }
  ->
  exec { "Install ODBC":
    command => "rpm -i $rpm",
    cwd => "/tmp",
    path => "$path",
    unless => "rpm -qa | grep $build",
    before => File["$config_path"],
  }

  # Config files.
  file { "$config_path":
    ensure => 'directory',
    owner => root,
    group => root,
    mode => '755',
  }
  ->
  file { "$odbcini_path":
    ensure => file,
    content => template('odbc_client/odbc.ini.erb'),
  }
  ->
  file { "$odbcinstini_path":
    ensure => file,
    content => template('odbc_client/odbcinst.ini.erb'),
  }
  ->
  file { "$driverini_path":
    ensure => file,
    content => template('odbc_client/hortonworks.hiveodbc.ini.erb'),
  }

  # Environment.
  file { "/etc/profile.d/odbc.sh":
    ensure => "file",
    source => 'puppet:///modules/odbc_client/odbc.sh',
  }

  # Install pyodbc.
  package { "epel-release":
    ensure => installed,
  }
  ->
  package { "python-pip":
    ensure => installed,
  }
  ->
  exec { "Install pyodbc":
    command => "pip install pyodbc",
    cwd => "/tmp",
    path => "$path",
  }

  # Sample query.
  file { "/home/vagrant/sampleSQLQuery.py":
    ensure => "file",
    source => 'puppet:///modules/odbc_client/sampleSQLQuery.py',
    owner => vagrant,
    group => vagrant,
  }
}
