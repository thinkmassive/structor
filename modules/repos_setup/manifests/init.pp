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

class repos_setup {
  $path="/bin:/usr/bin"

  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "6") {
    file { '/etc/yum.repos.d/hdp.repo':
      ensure => file,
      source => "puppet:///files/repos/centos6.hdp.repo.${hdp_short_version}",
    }
    file { '/etc/yum.repos.d/ambari.repo':
      ensure => file,
      source => "puppet:///files/repos/centos6.ambari.repo.${ambari_version}",
    }
  }
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { '/etc/yum.repos.d/hdp.repo':
      ensure => file,
      source => "puppet:///files/repos/centos7.hdp.repo.${hdp_short_version}",
    }
    file { '/etc/yum.repos.d/ambari.repo':
      ensure => file,
      source => "puppet:///files/repos/centos7.ambari.repo.${ambari_version}",
    }
  }
  elsif ($operatingsystem == "ubuntu" and $operatingsystemmajrelease == "14") {
    file { '/etc/apt/sources.list.d/hdp.list':
      ensure => file,
      source => "puppet:///files/repos/ubuntu14.hdp.list.${hdp_short_version}",
    }
    ->
    exec { "gpg-updates-import":
      command => "gpg --keyserver pgp.mit.edu --recv-keys B9733A7A07513CAD",
      path => "$path",
    }
    ->
    exec { "gpg-updates-aptkey":
      command => "gpg -a --export 07513CAD | apt-key add -",
      path => "$path",
    }
    ->
    exec { "refresh-apt-cache":
      command => "apt-get update",
      path => "$path",
    }
  }
}
