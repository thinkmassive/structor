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

class sample_airline_data {
  require hdfs_client
  require hive_client

  $path = "/sbin:/usr/sbin:/bin:/usr/bin"

  if $security == "true" {
    require kerberos_client

    exec { "kinit vagrant":
      command => "echo vagrant | kinit",
      path => "$path",
      user => vagrant,
      before => Exec["Add Airline Data"],
    }
  }

  exec { "Add Airline Data":
    command => "hive -f /vagrant/modules/sample_airline_data/files/load.sql",
    path => "$path",
    user => vagrant,
    unless => "hadoop fs -test -e /apps/hive/warehouse/airline_ontime.db",
  }
}
