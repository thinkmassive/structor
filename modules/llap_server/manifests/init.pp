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

# Note: This manifest builds everything manually and replaces the existing Hive.

class llap_server {
  require hive_client
  require tez_client

  $INSTALL_ROOT="/usr/hdp/autobuild"
  $TEZ_VERSION="0.8.0-TEZ-2003-SNAPSHOT"
  $TEZ_BRANCH="TEZ-2003"
  $HIVE_VERSION="2.0.0-SNAPSHOT"
  $LLAP_BRANCH="llap"
  $HADOOP_VERSION="2.6.0"
  $PROTOBUF_VER="protobuf-2.5.0"
  $PROTOBUF_DIST="http://protobuf.googlecode.com/files/$PROTOBUF_VER.tar.bz2"

  # XXX: This path only works on Owen's base box!
  $path="/bin:/usr/bin:$INSTALL_ROOT/protoc/bin:/usr/local/share/apache-maven-3.2.1/bin"

  $target_tez="/tmp/tez/tez-dist/target/tez-$TEZ_VERSION.tar.gz"
  $hive_package="apache-hive-$HIVE_VERSION-bin"
  $target_hive="/tmp/hive/packaging/target/$hive_package.tar.gz"

  # Build tools I need.
  package { [ "curl", "gcc", "gcc-c++", "cmake", "git" ]:
    ensure => installed,
    before => Exec["curl -O $PROTOBUF_DIST"],
  }
  case $operatingsystem {
    'centos': {
      package { [ "zlib-devel", "openssl-devel" ]:
        ensure => installed,
        before => Exec["curl -O $PROTOBUF_DIST"],
      }
    }
    'ubuntu': {
      package { [ "zlib1g-dev", "libssl-dev" ]:
        ensure => installed,
        before => Exec["curl -O $PROTOBUF_DIST"],
      }
    }
  }

  # Build protobuf.
  exec {"curl -O $PROTOBUF_DIST":
    cwd => "/tmp",
    path => $path,
  }
  ->
  exec {"tar -xvf $PROTOBUF_VER.tar.bz2":
    cwd => "/tmp",
    path => $path,
    creates => "/tmp/$PROTOBUF_VER",
  }
  ->
  exec {"/tmp/$PROTOBUF_VER/configure --prefix=$INSTALL_ROOT/protoc/":
    cwd => "/tmp/$PROTOBUF_VER",
    path => $path,
    creates => "/tmp/$PROTOBUF_VER/Makefile",
  }
  ->
  exec {"Build Protobuf":
    cwd => "/tmp/$PROTOBUF_VER",
    path => $path,
    command => "make",
    creates => "/tmp/$PROTOBUF_VER/src/protoc",
  }
  ->
  exec {"Install Protobuf":
    cwd => "/tmp/$PROTOBUF_VER",
    path => $path,
    command => "make install -k",
    creates => "$INSTALL_ROOT/protoc",
  }

  # Build Tez.
  exec {"git clone --branch $TEZ_BRANCH https://github.com/apache/tez tez":
    cwd => "/tmp",
    path => $path,
    require => Exec["Install Protobuf"],
    creates => "/tmp/tez",
    user => "vagrant",
  }
  ->
  exec {"Update Tez":
    command => "git pull",
    cwd => "/tmp/tez",
    path => $path,
    user => "vagrant",
  }
  ->
  exec {"mvn clean package install -DskipTests -Dhadoop.version=$HADOOP_VERSION -Paws -Phadoop24 -P\\!hadoop26":
    cwd => "/tmp/tez",
    path => $path,
    creates => $target_tez,
    user => "vagrant",
  }
  ->
  file { "$INSTALL_ROOT/tez":
    ensure => directory,
    owner => root,
    group => root,
    mode => '755',
  }
  ->
  exec {"Deploy Tez Locally":
    cwd => "/tmp/tez/tez-dist/target",
    path => $path,
    command => "tar -C $INSTALL_ROOT/tez -xzvf $target_tez",
  }
  ->
  exec {"Deploy Tez to HDFS":
    cwd => "/tmp/hive",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $target_tez /hdp/apps/${hdp_version}/tez/tez.tar.gz",
    user => "hdfs",
  }

  # Needed?
  #exec {'sed -i~ "s@<tez.version>.*</tez.version>@<tez.version>$TEZ_VERSION</tez.version>@" pom.xml':
  #  cwd => "/tmp/hive",
  #  path => $path,
  #  user => "vagrant",
  #}

  # Build Hive / LLAP.
  exec {"git clone --branch $LLAP_BRANCH https://github.com/apache/hive":
    cwd => "/tmp",
    path => $path,
    require => Exec["Install Protobuf"],
    creates => "/tmp/hive",
    user => "vagrant",
  }
  ->
  exec {"Update Hive":
    command => "git pull",
    cwd => "/tmp/hive",
    path => $path,
    user => "vagrant",
  }
  ->
  exec { "Build Hive":
    cwd => "/tmp/hive",
    path => $path,
    command => "mvn clean package -Denforcer.skip=true -DskipTests=true -Pdir -Pdist -Phadoop-2 -Dhadoop-0.23.version=$HADOOP_VERSION -Dbuild.profile=nohcat",
    creates => $target_hive,
    user => "vagrant",
  }
  ->
  exec {"Deploy Hive":
    cwd => "/tmp/hive",
    path => $path,
    command => "tar -C $INSTALL_ROOT -xzvf $target_hive",
  }
  ->
  file {"$INSTALL_ROOT/hive":
    ensure => link,
    target => "$INSTALL_ROOT/$hive_package",
  }

  # Configuration files.
  file { "/etc/hive/conf/llap-daemon-site.xml":
    ensure => file,
    content => template('llap_server/llap-daemon-site.erb'),
  }
}