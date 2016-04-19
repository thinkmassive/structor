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

class druid_base {
  require zookeeper_client

  $druid_version="1.1.1"
  $druid_base="imply-$druid_version"
  $druid_home="/usr/local/share/$druid_base"
  $path="/bin:/usr/bin:/usr/sbin"

  # Install Node.
  exec { "curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -":
    cwd => "/",
    path => "$path",
    creates => "/etc/yum.repos.d/nodesource-el.repo",
  }
  ->
  package { "nodejs" :
    ensure => installed,
  }

  # Install Druid.
  exec { "tar -C /usr/local/share -zxf /vagrant/$druid_base.tar.gz":
    cwd => "/",
    path => "$path",
    creates => "$druid_home",
  }
  ->
  file { "/usr/local/share/druid":
    ensure => "link",
    target => "$druid_home",
  }
  ->
  exec { "adduser druid":
    cwd => "/",
    path => "$path",
    unless => "id -u druid",
  }
  ->
  exec { "chown -fR druid:druid $druid_home":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/var/log/druid":
    ensure => 'directory',
    owner => druid,
    group => druid,
    mode => '755',
  }
  ->
  file { "/usr/local/share/druid/conf/druid/_common/common.runtime.properties":
    ensure => file,
    content => template("druid_base/common.runtime.properties.erb"),
  }

  # Hadoop files.
  exec { "Install Hadoop configuration":
    command => "cp /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/mapred-site.xml /etc/hadoop/conf/yarn-site.xml /usr/local/share/druid/conf/druid/_common",
    cwd => "/",
    path => "$path",
    require => File["/usr/local/share/druid"],
  }
  ->
  exec {"Substitute HDP Version mapred":
    command => "sed -i~ 's@\${hdp.version}@$hdp_version@g' mapred-site.xml",
    cwd => "/usr/local/share/druid/conf/druid/_common",
    path => $path,
  }
  ->
  exec {"Substitute HDP Version YARN":
    command => "sed -i~ 's@\${hdp.version}@$hdp_version@g' yarn-site.xml",
    cwd => "/usr/local/share/druid/conf/druid/_common",
    path => $path,
  }
  ->
  exec { "Eliminate LZO":
    command => "sh /vagrant/modules/druid_base/files/eliminateLZO.sh",
    cwd => "/tmp",
    path => $path,
  }
}
