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

class druid_pivot {
  require druid_base

  # Configuration files.
  $component="pivot"
  file { "/usr/local/share/druid/conf/pivot/config.yaml":
    ensure => file,
    content => template("druid_$component/config.yaml.erb"),
    before => Service["druid-pivot"],
  }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/druid-pivot.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/druid-pivot.service",
      before => Service["druid-pivot"],
    }
  }
  service { 'druid-pivot':
    ensure => running,
    enable => true,
  }
}
