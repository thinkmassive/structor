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

class yarn_resource_manager {
  require yarn_client
  require hadoop_server

  $path="/usr/bin"
  $yarn_component = "hadoop-yarn-resourcemanager"
  $mapreduce_component = "hadoop-mapreduce-historyserver"

  if ($hdp_version_major <= 2 and $hdp_version_minor <= 2) {
    $yarn_start_script="/usr/hdp/current/$yarn_component/../etc/$platform_start_script_path/$yarn_component"
    $mapreduce_start_script="/usr/hdp/current/$mapreduce_component/../etc/$platform_start_script_path/$mapreduce_component"
  }
  else {
    $yarn_start_script="/usr/hdp/$hdp_version/hadoop-yarn/etc/$platform_start_script_path/$yarn_component"
    $mapreduce_start_script="/usr/hdp/$hdp_version/hadoop-mapreduce/etc/$platform_start_script_path/$mapreduce_component"
  }

  if $security == "true" {
    require kerberos_http

    file { "${hdfs_client::keytab_dir}/rm.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/rm.keytab",
      owner => 'yarn',
      group => 'hadoop',
      mode => '400',
    }
    ->
    Package["hadoop${package_version}-mapreduce-historyserver"]

    file { "${hdfs_client::keytab_dir}/jhs.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/jhs.keytab",
      owner => 'mapred',
      group => 'hadoop',
      mode => '400',
    }
    ->
    Package["hadoop${package_version}-yarn-resourcemanager"]
  }

  package { "hadoop${package_version}-yarn-resourcemanager" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-yarn-resourcemanager ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hadoop-yarn-resourcemanager":
    ensure => 'link',
    target => "$yarn_start_script",
  }
  ->
  service {"hadoop-yarn-resourcemanager":
    ensure => running,
    enable => true,
  }

  package { "hadoop${package_version}-mapreduce-historyserver" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-mapreduce-historyserver ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hadoop-mapreduce-historyserver":
    ensure => 'link',
    target => "$mapreduce_start_script",
  }
  ->
  service {"hadoop-mapreduce-historyserver":
    ensure => running,
    enable => true,
  }
}
