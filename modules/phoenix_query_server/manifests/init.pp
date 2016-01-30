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

class phoenix_query_server {
  require hbase_client

  if $security == "true" {
    require hbase_authorization

    file { "${hdfs_client::keytab_dir}/phoenix.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/phoenix.keytab",
      owner => hbase,
      group => hadoop,
      mode => '400',
    }
    -> Service["phoenix-query-server"]
  }
 
  # Install and enable.
  # HDP 2.x doesn't have a Phoenix Query Server startup script, insert our own.
  if ($hdp_version_major+0 <= 2) {
    file { "/etc/init.d/phoenix-query-server":
      ensure => file,
      mode => '0755',
      replace => true,
      source => 'puppet:///modules/phoenix_query_server/phoenix-query-server',
      before => Service['phoenix-query-server'],
    }
  }

  # Fix the control script to add core-site to classpath (for secure cluster)
  if ($hdp_version_major+0 <= 2 and $hdp_version_minor+0 <= 3) {
    file { "/usr/hdp/$hdp_version/phoenix/bin/queryserver.py":
      ensure => file,
      mode => '0755',
      replace => true,
      source => 'puppet:///modules/phoenix_query_server/queryserver.py',
      before => Service['phoenix-query-server'],
    }
  }

  # Start the service up.
  service { 'phoenix-query-server':
    ensure => running,
    enable => true,
  }

  # A sample query.
  file { "/home/vagrant/sample-phoenix-query-server-query.py":
    ensure => "file",
    mode => '0755',
    source => 'puppet:///modules/phoenix_query_server/sample-phoenix-query-server-query.py',
    owner => vagrant,
    group => vagrant,
  }
}
