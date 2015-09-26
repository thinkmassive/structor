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

class sample_data {
  require hive_client

  $PATH = "/sbin:/usr/sbin:/bin:/usr/bin"

  exec { "Add sample data (ORCFile)":
    command => "hdfs dfs -copyFromLocal /vagrant/modules/sample_data/files/foodmart.db /apps/hive/warehouse",
    path => "$path",
    user => hive,
    unless => "hadoop fs -test -e /apps/hive/warehouse/foodmart.db",
  }
  ->
  exec { "Load sample data (ORCFile)":
    command => "hive -f /vagrant/modules/sample_data/files/foodmart.db/foodmart_hive.ddl",
    path => "$path",
    user => hive,
  }

  exec { "Add sample data (Parquet)":
    command => "hdfs dfs -copyFromLocal /vagrant/modules/sample_data/files/foodmart_parquet.db /apps/hive/warehouse",
    path => "$path",
    user => hive,
    unless => "hadoop fs -test -e /apps/hive/warehouse/foodmart_parquet.db",
  }
  ->
  exec { "Load sample data (Parquet)":
    command => "hive -f /vagrant/modules/sample_data/files/foodmart_parquet.db/foodmart_hive.ddl",
    path => "$path",
    user => hive,
  }
}
