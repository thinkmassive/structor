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

class ip_setup {

  exec {'stop-firewalld':
    command => "/usr/sbin/systemctl stop firewalld",
  }

  service {'disable-firewalld':
    command => "/usr/sbin/systemctl disable firewalld",
  }

  exec { 'disableipv6':
    command => "/usr/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1 && /usr/sbin/sysctl -w net.ipv6.conf.default.disable_ipv6=1",
  }

  file { '/etc/sysctl.d/disableipv6.conf':
    ensure => file,
    content => template('ip_setup/disableipv6.erb'),
  }

  file { '/etc/hosts':
    ensure => file,
    content => template('ip_setup/hosts.erb'),
  }
}
