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

class hdfs_client {
  require repos_setup
  require hdp_select
  require jdk

  $conf_dir="/etc/hadoop/hdp"
  $path="${jdk::HOME}/bin:/bin:/usr/bin"
  $log_dir="/var/log/hadoop"
  $data_dir="/var/lib/hadoop"
  $pid_dir="/var/run/pid"
  $keytab_dir="/etc/security/hadoop"

  package { "flume${package_version}":
    ensure => installed,
  }
  ->
  exec { "hdp-select set flume ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
}
