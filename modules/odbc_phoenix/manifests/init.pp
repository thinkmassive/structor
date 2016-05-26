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

class odbc_phoenix {
  $path="/sbin:/usr/sbin:/bin:/usr/bin"

  $install_path="/opt/simba/phoenixodbc"
  $config_path="$install_path/Setup"
  $odbcini_path="$config_path/odbc.ini"
  $odbcinstini_path="$config_path/odbcinst.ini"
  $driverini_path="$install_path/lib/64/simba.phoenixodbc.ini"

  if ($operatingsystem == "centos") {
    package { [ "unixODBC", "unixODBC-devel", "cyrus-sasl-gssapi", "cyrus-sasl-plain" ]:
      ensure => installed,
      before => Exec["Download ODBC"],
    }
    $version="1.0.0.0004"
    $build="SimbaPhoenixODBC-64bit-$version"
    $rpmbase="$build-1"
    $rpm="$rpmbase.rpm"
    #$driver_url="http://public-repo-1.hortonworks.com/HDP/phoenix-odbc/$version/centos6/$rpm"
    $driver_url="file:///vagrant/$rpm"
    $expected_sums="expected_sums_odbc_centos.txt"
  } else {
    fail("No Phoenix ODBC support for Ubuntu")
  }

  file { "/tmp/expected_sums_odbc.txt":
    ensure => file,
    source => "puppet:///modules/odbc_phoenix/$expected_sums",
  }
  ->
  exec { "Download ODBC":
    command => "curl -O $driver_url",
    cwd => "/tmp",
    path => "$path",
    unless => "md5sum -c expected_sums_odbc.txt --quiet",
  }

  if ($operatingsystem == "centos") {
    exec { "Install ODBC":
      command => "rpm -i $rpm",
      cwd => "/tmp",
      path => "$path",
      unless => "rpm -qa | grep $build",
      before => File["$config_path"],
      require => Exec["Download ODBC"],
    }
  } else {
    fail("No Phoenix ODBC support for Ubuntu")
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
    content => template('odbc_phoenix/odbc.ini.erb'),
  }
  ->
  file { "$odbcinstini_path":
    ensure => file,
    content => template('odbc_phoenix/odbcinst.ini.erb'),
  }

  # Environment.
  file { "/etc/profile.d/odbc_phoenix.sh":
    ensure => "file",
    source => 'puppet:///modules/odbc_phoenix/odbc_phoenix.sh',
  }

  # Install pyodbc.
  if ($operatingsystem == "centos") {
    package { "epel-release":
      ensure => installed,
    }
    ->
    package { "python-pip":
      ensure => installed,
    }
    ->
    package { "python-devel":
      ensure => installed,
    }
    ->
    package { "gcc-c++":
      ensure => installed,
    }
    ->
    exec { "Install pyodbc":
      command => "pip install pyodbc",
      cwd => "/tmp",
      path => "$path",
    }
  } else {
    package { "python-pyodbc":
      ensure => installed,
    }
  }

  # Sample query.
  file { "/home/vagrant/samplePythonODBCQuery.py":
    ensure => "file",
    source => 'puppet:///modules/odbc_phoenix/samplePythonODBCQuery.py',
    owner => vagrant,
    group => vagrant,
  }
}
