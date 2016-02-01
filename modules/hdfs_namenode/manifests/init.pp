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

class hdfs_namenode {
  require hdfs_client
  require hadoop_server

  $path="/bin:/usr/bin"
  $dirs="/user/yarn /user/yarn/history /user/yarn/app-logs /user/vagrant /user/hive /user/oozie /user/admin /user/ambari /apps/hive/warehouse /apps/hbase /tmp /hdp/apps/${hdp_version}/mapreduce /hdp/apps/${hdp_version}/tez /hdp/apps/${hdp_version}/pig /hdp/apps/${hdp_version}/hive"
  $mode177_dirs="/user/yarn/app-logs /apps/hive/warehouse /apps/hbase /tmp"

  $component = "hadoop-hdfs-namenode"
  if ($hdp_version_major+0 <= 2 and $hdp_version_minor+0 <= 2) {
    $start_script="/usr/hdp/$hdp_version/etc/$platform_start_script_path/$component"
  }
  else {
    $start_script="/usr/hdp/$hdp_version/hadoop-hdfs/etc/$platform_start_script_path/$component"
  }

  if $security == "true" {
    require kerberos_http
    file { "${hdfs_client::keytab_dir}/nn.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/nn.keytab",
      owner => hdfs,
      group => hadoop,
      mode => '400',
    }
    ->
    exec { "kinit -k -t ${hdfs_client::keytab_dir}/nn.keytab nn/${hostname}.${domain}":
      path => $path,
      user => hdfs,
    }
    ->
    Package["hadoop${package_version}-hdfs-namenode"]
  }

  package { "hadoop${package_version}-hdfs-namenode" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-hdfs-namenode ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->

  exec {"namenode-format":
    command => "hadoop namenode -format",
    path => "$path",
    creates => "${hdfs_client::data_dir}/hdfs/namenode",
    user => "hdfs",
    require => Package["hadoop${package_version}-hdfs-namenode"],
  }
  ->
  service {"hadoop-hdfs-namenode":
    ensure => running,
    enable => true,
  }
  ->
  exec {"make-all-dirs":
    command => "hadoop fs -mkdir -p $dirs",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"yarn-home-chown":
    command => "hadoop fs -chown yarn:yarn /user/yarn",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"yarn-history-chown":
    command => "hadoop fs -chown -R mapred:mapred /user/yarn/history",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"yarn-app-logs-chown":
    command => "hadoop fs -chown yarn:mapred /user/yarn/app-logs",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"vagrant-home-chown":
    command => "hadoop fs -chown vagrant:vagrant /user/vagrant",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"oozie-home-chown":
    command => "hadoop fs -chown oozie:oozie /user/oozie",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"hbase-warehouse-chown":
    command => "hadoop fs -chown hbase:hbase /apps/hbase",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"hive-chown":
    command => "hadoop fs -chown hive:hive /user/hive /apps/hive/warehouse",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"ambari-chown":
    command => "hadoop fs -chown ambari:ambari /user/ambari",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"admin-home-chown":
    command => "hadoop fs -chown admin:admin /user/admin",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"chmod-177":
    command => "hadoop fs -chmod 1777 $mode177_dirs",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"yarn-home-chmod":
    command => "hadoop fs -chmod 755 /user/yarn",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"yarn-history-chmod":
    command => "hadoop fs -chmod 775 /user/yarn/history",
    path => "$path",
    user => "hdfs",
  }
  ->
  exec {"tarball-chmod":
    command => "hadoop fs -chmod -R +rX /hdp",
    path => "$path",
    user => "hdfs",
  }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/hadoop-hdfs-namenode.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/hadoop-hdfs-namenode.service",
      before => Service["hadoop-hdfs-namenode"],
    }
    file { "/etc/systemd/system/hadoop-hdfs-namenode.service.d":
      ensure => 'directory',
    } ->
    file { "/etc/systemd/system/hadoop-hdfs-namenode.service.d/default.conf":
      ensure => 'file',
      source => "/vagrant/files/systemd/hadoop-hdfs-namenode.service.d/default.conf",
      before => Service["hadoop-hdfs-namenode"],
    }
  } else {
    file { "/etc/init.d/hadoop-hdfs-namenode":
      ensure => 'link',
      target => "$start_script",
      before => Service["hadoop-hdfs-namenode"],
    }
  }
}
