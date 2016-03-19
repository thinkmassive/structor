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

class hive2_server2 {
  require hive2

  $path="/bin:/usr/bin"

  # Enable and start the service.
  service { 'hive2-server2':
    ensure => running,
    enable => true,
  }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/hive2-server2.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/hive2-server2.service",
      before => Service["hive2-server2"],
    }
    file { "/etc/systemd/system/hive2-server2.service.d":
      ensure => 'directory',
    } ->
    file { "/etc/systemd/system/hive2-server2.service.d/default.conf":
      ensure => 'file',
      source => "/vagrant/files/systemd/hive2-server2.service.d/default.conf",
      before => Service["hive2-server2"],
    }
  } else {
    file { "/usr/hdp/${hdp_version}/etc/default/hive2-server2":
      ensure => file,
      mode   => '755',
      source => 'puppet:///modules/hive2_server2/hive2-server2',
      before => Service["hive2-server2"],
    }
    file { "/etc/init.d/hive2-server2":
      ensure => 'link',
      target => "/usr/hdp/${hdp_version}/etc/default/hive2-server2",
      before => Service["hive2-server2"],
    }
  }
}
