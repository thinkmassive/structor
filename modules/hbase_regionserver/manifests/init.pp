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

class hbase_regionserver {
  require hbase_server

  $path="/bin:/sbin:/usr/bin"

  $component = "hbase-regionserver"
  if ($hdp_version_major+0 <= 2 and $hdp_version_minor+0 <= 2) {
    $start_script="/usr/hdp/$hdp_version/etc/$platform_start_script_path/$component"
  }
  else {
    $start_script="/usr/hdp/$hdp_version/hbase/etc/$platform_start_script_path/$component"
  }

  case $operatingsystem {
    'centos': {
      package { "hbase${package_version}-regionserver" :
        ensure => installed,
        before => Exec["hdp-select set hbase-regionserver ${hdp_version}"],
      }
    }
    'ubuntu': {
      if ($hdp_version_major+0 <= 2 and $hdp_version_minor+0 < 3) {
        # XXX: Work around BUG-39010.
        exec { "apt-get download hbase${package_version}-regionserver":
          cwd => "/tmp",
          path => "$path",
        }
        ->
        exec { "dpkg -i --force-overwrite hbase${package_version}*.deb":
          cwd => "/tmp",
          path => "$path",
          user => "root",
        }
        # Fix incorrect startup script permissions.
        ->
        file { "$start_script":
          ensure => file,
          mode => '755',
          before => Exec["hdp-select set hbase-regionserver ${hdp_version}"],
        }
      }
      else {
        package { "hbase${package_version}-regionserver" :
          ensure => installed,
          before => Exec["hdp-select set hbase-regionserver ${hdp_version}"],
        }
      }
    }
  }

  exec { "hdp-select set hbase-regionserver ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  service {"hbase-regionserver":
    ensure => running,
    enable => true,
    subscribe => File['/etc/hbase/conf/hbase-site.xml'],
  }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/hbase-regionserver.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/hbase-regionserver.service",
      before => Service["hbase-regionserver"],
    }
    file { "/etc/systemd/system/hbase-regionserver.service.d":
      ensure => 'directory',
    } ->
    file { "/etc/systemd/system/hbase-regionserver.service.d/default.conf":
      ensure => 'file',
      source => "/vagrant/files/systemd/hbase-regionserver.service.d/default.conf",
      before => Service["hbase-regionserver"],
    }
  } else {
    # Replace broken start scripts if needed.
    if ($hdp_version_major+0 == 2 and $hdp_version_minor+0 <= 3 and $hdp_version_patch+0 <= 2) {
      file { "/etc/init.d/hbase-regionserver":
        ensure => file,
        source => "puppet:///files/init.d/hbase-regionserver",
        owner => root,
        group => root,
        mode => '755',
        before => Service["hbase-regionserver"],
      }
    } else {
      file { "/etc/init.d/hbase-regionserver":
        ensure => 'link',
        target => "$start_script",
        before => Service["hbase-regionserver"],
      }
    }
  }
}
