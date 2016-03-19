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

class hive2 {
  require hive_client

  $path="/bin:/usr/bin"

  package { "hive2${package_version}":
    ensure => installed,
  }
  package { "tez_hive2${package_version}":
    ensure => installed,
  }

  # Configs.
  file { '/etc/hive2/conf/hive-site.xml':
    ensure => file,
    content => template('hive2/hive-site.xml.erb'),
    require => Package["hive2${package_version}"],
  }
  file { '/etc/hive2/conf/hive-env.sh':
    ensure => file,
    content => template('hive2/hive-env.sh.erb'),
    require => Package["hive2${package_version}"],
  }
  file { '/etc/tez_hive2/conf/tez-site.xml':
    ensure => file,
    content => template('hive2/tez-site.xml.erb'),
    require => Package["tez_hive2${package_version}"],
  }
  file { '/etc/hadoop/hdp/hadoop-env.sh.hive2':
    ensure => file,
    content => template('hive2/hadoop-env.sh.erb'),
  }
  #->
  #exec { 'Replace hadoop-env':
  #  # XXX: This will stop when we have the real solution in 2.6.
  #  cwd => "/",
  #  path => $path,
  #  command => "mv -f /etc/hadoop/hdp/hadoop-env.sh.hive2 /etc/hadoop/hdp/hadoop-env.sh",
  #}

  # Convenience links.
  file {"/usr/bin/hive2":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hive2/bin/hive",
  }
  file {"/usr/bin/hplsql":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hive2/bin/hplsql",
  }
}
