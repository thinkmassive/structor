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

class sample_phoenix_data {
  require hbase_client

  $path = "/sbin:/usr/sbin:/bin:/usr/bin"

  if $security == "true" {
    require kerberos_client

    exec { "kinit -k -t ${hdfs_client::keytab_dir}/hbase.keytab hbase/${hostname}.${domain}":
      path => $path,
      user => hbase,
    }
  }

  exec { "Add sample data (Phoenix)":
    command => "hdfs dfs -copyFromLocal /vagrant/modules/sample_phoenix_data/files/foodmart_delimited /tmp",
    path => "$path",
    user => hbase,
    unless => "hadoop fs -test -e /tmp/foodmart_delimited",
  }
  ->
  file { "/tmp/create_tables.sh":
    ensure => file,
    mode => '755',
    content => template('sample_phoenix_data/create_tables.sh.erb'),
  }
  ->
  file { "/tmp/count_rows.sh":
    ensure => file,
    mode => '755',
    content => template('sample_phoenix_data/count_rows.sh.erb'),
  }
  ->
  exec { "Create Phoenix Tables":
    command => "/tmp/create_tables.sh",
    path => "$path",
    unless => "/tmp/count_rows.sh",
    user => hbase,
  }
  ->
  exec { "Load sample data (Phoenix, Takes ~30 minutes)":
    command => "/vagrant/modules/sample_phoenix_data/files/load_sample_data.sh",
    path => "$path",
    unless => "/tmp/count_rows.sh",
    user => hbase,
    timeout => 2000,
  }
}
