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

include repos_setup
include vm_users
include ip_setup
include selinux
include weak_random
include ntp

# determine the required modules based on the roles.

if $security == "true" {
  include kerberos_client
}

if $security == "true" and hasrole($roles, 'kdc') {
  include kerberos_kdc
}

if hasrole($roles, 'ambari-agent') {
  include ambari_agent
}

if hasrole($roles, 'ambari-server') {
  include ambari_server
}

if hasrole($roles, 'blueprint') {
  include blueprint
}

if hasrole($roles, 'ambari-views') {
  include ambari_views
}

if hasrole($roles, 'cert') {
   include certification
}

if hasrole($roles, 'client') {
  if hasrole($clients, 'hbase') {
    include hbase_client
  }
  if hasrole($clients, 'hdfs') {
    include hdfs_client
  }
  if hasrole($clients, 'hive') {
    include hive_client
  }
  if hasrole($clients, 'jvmtop') {
    include jvmtop_client
  }
  if hasrole($clients, 'maven') {
    include maven
  }
  if hasrole($clients, 'odbc') {
    include odbc_client
  }
  if hasrole($clients, 'oozie') {
    include oozie_client
  }
  if hasrole($clients, 'pig') {
    include pig_client
  }
  if hasrole($clients, 'slider') {
    include slider
  }
  if hasrole($clients, 'spark') {
    include spark_client
  }
  if hasrole($clients, 'sqoop') {
    include sqoop_client
  }
  if hasrole($clients, 'tez') {
    include tez_client
  }
  if hasrole($clients, 'yarn') {
    include yarn_client
  }
  if hasrole($clients, 'yarnlocaltop') {
    include yarnlocaltop_client
  }
  if hasrole($clients, 'zk') {
    include zookeeper_client
  }

  # Add kerberos client if we are in secure mode.
  #if $security == "true" {
  #  include kerberos_client
  #}
}

# Various Druid roles.
if hasrole($roles, 'druid-bard') {
  include druid_bard
}
if hasrole($roles, 'druid-broker') {
  include druid_broker
}
if hasrole($roles, 'druid-coordinator') {
  include druid_coordinator
}
if hasrole($roles, 'druid-historical') {
  include druid_historical
}
if hasrole($roles, 'druid-middlemanager') {
  include druid_middlemanager
}
if hasrole($roles, 'druid-overlord') {
  include druid_overlord
}
if hasrole($roles, 'druid-pivot') {
  include druid_pivot
}

if hasrole($roles, 'flume-server') {
  include flume_server
}

if hasrole($roles, 'hbase-master') {
  include hbase_master
}

if hasrole($roles, 'hbase-regionserver') {
  include hbase_regionserver
}

if hasrole($roles, 'hive-db') {
  include hive_db
}

if hasrole($roles, 'hive-meta') {
  include hive_meta
}

if hasrole($roles, 'hive-server2') {
  include hive_server2
}

if hasrole($roles, 'hive2') {
  include hive2
}

if hasrole($roles, 'hive2-llap') {
  include hive2_llap
}

if hasrole($roles, 'hive2-server2') {
  include hive2_server2
}

if hasrole($roles, 'hue') {
  include hue_server
}

if hasrole($roles, 'kafka') {
  include kafka_server
}

if hasrole($roles, 'knox') {
  include knox_gateway
}

if hasrole($roles, 'hive-llap') {
  include hive_llap
}

if hasrole($roles, 'httpd') {
  include httpd
}

if hasrole($roles, 'nn') {
  include hdfs_namenode
}

if hasrole($roles, 'oozie') {
  include oozie_server
}

if hasrole($roles, 'phoenix-query-server') {
  include phoenix_query_server
}

if hasrole($roles, 'postgres') {
  include postgres_server
}

if hasrole($roles, 'ranger-server') {
  include ranger_server
}

if hasrole($roles, 'slave') {
  include hdfs_datanode
  include yarn_node_manager
}

if hasrole($roles, 'tez-ui') {
  include tez_ui
}

if hasrole($roles, 'wildfly') {
  include wildfly
}

if hasrole($roles, 'yarn') {
  include yarn_resource_manager
}

if hasrole($roles, 'yarn-timelineserver') {
  include yarn_timelineserver
}

if hasrole($roles, 'zk') {
  include zookeeper_server
}

if islastslave($nodes, $hostname) {
  include install_hdfs_tarballs

  if (!("" in [$extras])) {
    if (hasrole($extras, 'hive-brickhouse-udf')) {
      include hive_brickhouse_udf
    }

    if (hasrole($extras, 'sample-hive-data')) {
      include sample_hive_data
      Class['install_hdfs_tarballs'] -> Class['sample_hive_data']
    }

    if (hasrole($extras, 'sample-airline-data')) {
      include sample_airline_data
      Class['install_hdfs_tarballs'] -> Class['sample_airline_data']
    }

    if (hasrole($extras, 'sample-phoenix-data')) {
      include sample_phoenix_data
      Class['hbase_regionserver'] -> Class['sample_phoenix_data']
    }
  }
}

# Ensure the kdc is brought up before major services.
if $security == "true" and hasrole($roles, 'kdc') {
  if hasrole($roles, 'ambari-server') {
    Class['kerberos_kdc'] -> Class['ambari_server']
  }

  if hasrole($roles, 'hbase-master') {
    Class['kerberos_kdc'] -> Class['hbase_master']
  }

  if hasrole($roles, 'hive-meta') {
    Class['kerberos_kdc'] -> Class['hive_meta']
  }

  if hasrole($roles, 'hbase-regionserver') {
    Class['kerberos_kdc'] -> Class['hbase_regionserver']
  }

  if hasrole($roles, 'nn') {
    Class['kerberos_kdc'] -> Class['hdfs_namenode']
  }
}

# Ensure the namenode is brought up before the slaves, jobtracker, metastore,
# and oozie
if hasrole($roles, 'nn') {
  if hasrole($roles, 'slave') {
    Class['hdfs_namenode'] -> Class['hdfs_datanode']
  }

  if hasrole($roles, 'yarn') {
    Class['hdfs_namenode'] -> Class['yarn_resource_manager']
  }

  if hasrole($roles, 'hive-meta') {
    Class['hdfs_namenode'] -> Class['hive_meta']
  }

  if hasrole($roles, 'oozie') {
    Class['hdfs_namenode'] -> Class['oozie_server']
  }

  if hasrole($roles, 'hbase-master') {
    Class['hdfs_namenode'] -> Class['hbase_master']
  }

  if hasrole($roles, 'hbase-regionserver') {
    Class['hdfs_namenode'] -> Class['hbase_regionserver']
  }
}

# Ensure the db is started before oozie and hive metastore
if hasrole($roles, 'hive-db') {
  if hasrole($roles, 'hive-meta') {
    Class['hive_db'] -> Class['hive_meta']
  }

  if hasrole($roles, 'oozie') {
    Class['hive_db'] -> Class['oozie_server']
  }
}

# Bring up the metastore before Hive servers.
if hasrole($roles, 'hive-server2') {
  if hasrole($roles, 'hive-meta') {
    Class['hive_meta'] -> Class['hive_server2']
  }
  if hasrole($roles, 'hive-llap') {
    Class['hive_meta'] -> Class['hive_llap']
  }
}

# ZK before Kafka
if hasrole($roles, 'kafka') {
  if hasrole($roles, 'zk') {
    Class['zookeeper_server'] -> Class['kafka_server']
  }
}

# Ensure oozie runs after the datanode on the same node
if hasrole($roles, 'slave') and hasrole($roles, 'oozie') {
  Class['hdfs_datanode'] -> Class['oozie_server']
}

# Datanode before HS2 to avoid 0-length Tez library.
if hasrole($roles, 'slave') and hasrole($roles, 'hive-server2') {
  Class['hdfs_datanode'] -> Class['hive_server2']
}
if hasrole($roles, 'slave') and hasrole($roles, 'hive2-server2') {
  Class['hdfs_datanode'] -> Class['hive2_server2']
}

# Hack until LLAP stops reading from HDFS at build time.
if hasrole($roles, 'hive2-llap') {
  Class['install_hdfs_tarballs'] -> Class['hive2_llap']
}

if hasrole($roles, 'phoenix-query-server') {
  if hasrole($roles, 'hbase-regionserver') {
    Class['hbase_regionserver'] -> Class['phoenix_query_server']
  }
}

if hasrole($roles, 'hbase-master') {
  if hasrole($roles, 'hbase-regionserver') {
    Class['hbase_master'] -> Class['hbase_regionserver']
  }

  # The master needs a datanode before it can start up
  if hasrole($roles, 'slave') {
    Class['hdfs_datanode'] -> Class['hbase_master']
  }
}
