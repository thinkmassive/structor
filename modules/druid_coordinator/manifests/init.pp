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

class druid_coordinator {
  require druid_base

  # Configuration files.
  $component="coordinator"
  file { "/usr/local/share/druid/conf/druid/$component/jvm.config":
    ensure => file,
    content => template("druid_$component/jvm.config.erb"),
    before => Service["druid-coordinator"],
  }
  file { "/usr/local/share/druid/conf/druid/$component/runtime.properties":
    ensure => file,
    content => template("druid_$component/runtime.properties.erb"),
    before => Service["druid-coordinator"],
  }
  file { "/usr/local/share/druid/conf/druid/$component/main.config":
    ensure => file,
    source => "puppet:///modules/druid_$component/main.config",
    before => Service["druid-coordinator"],
  }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/druid-coordinator.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/druid-coordinator.service",
      before => Service["druid-coordinator"],
    }
  }
  service { 'druid-coordinator':
    ensure => running,
    enable => true,
  }
}
