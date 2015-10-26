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

class yarn_timelineserver {
  require yarn_client

  $path="/bin:/usr/bin"

  if $security == "true" {
    require kerberos_http
    require hdfs_client

    file { "${hdfs_client::keytab_dir}/ats.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/ats.keytab",
      owner => yarn,
      group => hadoop,
      mode => '400',
    }
  }

  $component = "hadoop-yarn-timelineserver"
  if ($hdp_version_major <= 2 and $hdp_version_minor <= 2) {
    $start_script="/usr/hdp/$hdp_version/etc/$platform_start_script_path/$component"
  }
  else {
    $start_script="/usr/hdp/$hdp_version/hadoop-yarn/etc/$platform_start_script_path/$component"
  }

  package { "hadoop${package_version}-yarn-timelineserver" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-yarn-timelineserver ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hadoop-yarn-timelineserver":
    ensure => 'link',
    target => "$start_script",
    before => Service["hadoop-yarn-timelineserver"],
  }

  service {"hadoop-yarn-timelineserver":
    ensure => running,
    enable => true,
  }
}
