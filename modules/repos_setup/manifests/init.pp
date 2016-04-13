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

  $unstable_base = "http://dev.hortonworks.com.s3.amazonaws.com"
  $unstable_ambari_url = "$unstable_base/ambari/${os_version}/2.x/updates/${ambari_version}/ambariqe.repo"
  $unstable_hdp_url = "$unstable_base/HDP/${os_version}/2.x/updates/${hdp_version}/hdpqe.repo"

  # Ambari.
  if ($operatingsystem == "centos") {
    if ($ambari_unstable == "1") {
      exec {"Download unstable Ambari repo":
        command => "curl -O $unstable_ambari_url",
        cwd => "/etc/yum.repos.d",
        path => $path,
        creates => "/etc/yum.repos.d/ambariqe.repo",
      }
    } else {
      file { '/etc/yum.repos.d/ambari.repo':
        ensure => file,
        source => "puppet:///files/repos/${os_version}.ambari.repo.${ambari_version}",
      }
    }
  }

  # HDP base.
  if ($operatingsystem == "centos") {
    if ($hdp_unstable == "1") {
      exec {"Download unstable HDP repo":
        command => "curl -O $unstable_hdp_url",
        cwd => "/etc/yum.repos.d",
        path => $path,
        creates => "/etc/yum.repos.d/hdpqe.repo",
      }
    } else {
      file { '/etc/yum.repos.d/hdp.repo':
        ensure => file,
        source => "puppet:///files/repos/${os_version}.hdp.repo.${hdp_short_version}",
      }
    }
  }

  # Update yum cache
  if ($operatingsystem == "centos") {
    exec { "yum clean all && yum update":
      command => "/usr/bin/yum clean all && /usr/bin/yum update -y",
      timeout => 600
    }
  }

  if ($operatingsystem == "ubuntu" and $operatingsystemmajrelease == "14.04") {
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
