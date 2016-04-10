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

class druid_overlord {
  require druid_base

  # Configuration files.
  $component="overlord"
  file { "/usr/local/share/druid/conf/druid/$component/jvm.config":
    ensure => file,
    content => template("druid_$component/jvm.config.erb"),
    before => Service["druid-overlord"],
  }
  file { "/usr/local/share/druid/conf/druid/$component/runtime.properties":
    ensure => file,
    content => template("druid_$component/runtime.properties.erb"),
    before => Service["druid-overlord"],
  }
  file { "/usr/local/share/druid/conf/druid/$component/main.config":
    ensure => file,
    source => "puppet:///modules/druid_$component/main.config",
    before => Service["druid-overlord"],
  }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/druid-overlord.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/druid-overlord.service",
      before => Service["druid-overlord"],
    }
  }
  service { 'druid-overlord':
    ensure => running,
    enable => true,
  }

  # Samples.
  file { "/home/vagrant/sampleDruidIndexWiki.sh":
    ensure => file,
    owner => vagrant,
    group => vagrant,
    content => template("druid_overlord/sampleDruidIndexWiki.sh.erb"),
  }
  file { "/home/vagrant/wikiticker-index-hdfs.json":
    ensure => file,
    owner => vagrant,
    group => vagrant,
    source => "puppet:///modules/druid_overlord/wikiticker-index-hdfs.json",
  }
  file { "/home/vagrant/sampleTpchIndexWiki.sh":
    ensure => file,
    owner => vagrant,
    group => vagrant,
    content => template("druid_overlord/sampleTpchIndexWiki.sh.erb"),
  }
  file { "/home/vagrant/tpch-index-hdfs.json":
    ensure => file,
    owner => vagrant,
    group => vagrant,
    source => "puppet:///modules/druid_overlord/tpch-index-hdfs.json",
  }
  file { "/home/vagrant/sampleWeblog.sh":
    ensure => file,
    owner => vagrant,
    group => vagrant,
    content => template("druid_overlord/sampleWeblog.sh.erb"),
  }
}
