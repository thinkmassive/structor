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

class yarn_node_manager {
  require yarn_client
  require hadoop_server

  $path="/bin:/usr/bin"

  $component = "hadoop-yarn-nodemanager"
  if ($hdp_version_major+0 <= 2 and $hdp_version_minor+0 <= 2) {
    $start_script="/usr/hdp/$hdp_version/etc/$platform_start_script_path/$component"
  }
  else {
    $start_script="/usr/hdp/$hdp_version/hadoop-yarn/etc/$platform_start_script_path/$component"
  }

  if $security == "true" {
    require kerberos_http

    file { "${hdfs_client::keytab_dir}/nm.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/nm.keytab",
      owner => yarn,
      group => hadoop,
      mode => '400',
    }
    ->
    file { "${hdfs_client::conf_dir}/container-executor.cfg":
      ensure => file,
      content => template('yarn_node_manager/container-executor.erb'),
      owner => root,
      group => mapred,
      mode => '400',
    }
    ->
    Package["hadoop${package_version}-yarn-nodemanager"]
  }

  package { "hadoop${package_version}-yarn-nodemanager" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-yarn-nodemanager ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hadoop-yarn-nodemanager":
    ensure => 'link',
    target => "$start_script",
    before => Service["hadoop-yarn-nodemanager"],
  }

  if ($hdp_version_major+0 <= 2 and $hdp_version_minor+0 <= 3 and $hdp_version_patch+0 <= 2) {
    exec { "chgrp yarn /usr/hdp/${hdp_version}/hadoop-yarn/bin/container-executor":
      # Bug: Older packages don't work on secure cluster due to wrong group membership.
      cwd => "/",
      path => "$path",
    }
    ->
    exec { "chmod 6050 /usr/hdp/${hdp_version}/hadoop-yarn/bin/container-executor":
      # Bug: Puppet can't deal with a mode of 6050.
      cwd => "/",
      path => "$path",
      before => Service["hadoop-yarn-nodemanager"],
    }
  }

  service {"hadoop-yarn-nodemanager":
    ensure => running,
    enable => true,
  }
}
