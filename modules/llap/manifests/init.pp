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

class llap {
  require hive_client

  $INSTALL_ROOT="/usr/local/llap"
  $TEZ_VERSION="0.8.0-TEZ-2003-SNAPSHOT"
  $TEZ_BRANCH="TEZ-2003"
  $HIVE_VERSION="2.0.0-SNAPSHOT"
  $HIVE_BRANCH="llap"
  $PROTOBUF_VER="protobuf-2.5.0"
  $PROTOBUF_DIST="http://protobuf.googlecode.com/files/$PROTOBUF_VER.tar.bz2"

  $path="/bin:/usr/bin:$INSTALL_ROOT/protoc/bin"

  # Build tools I need.
  package { "curl":
    ensure => installed,
    before => Exec["curl -O $PROTOBUF_DIST"],
  }
  package { "gcc":
    ensure => installed,
    before => Exec["curl -O $PROTOBUF_DIST"],
  }
  package { "cmake":
    ensure => installed,
    before => Exec["curl -O $PROTOBUF_DIST"],
  }
  package { "git":
    ensure => installed,
  }
  case $operatingsystem {
    'centos': {
      package { "zlib-devel":
        ensure => installed,
        before => Exec["curl -O $PROTOBUF_DIST"],
      }
      package { "openssl-devel":
        ensure => installed,
        before => Exec["curl -O $PROTOBUF_DIST"],
      }
    }
    'ubuntu': {
      package { "zlib1g-dev":
        ensure => installed,
        before => Exec["curl -O $PROTOBUF_DIST"],
      }
      package { "libssl-dev":
        ensure => installed,
        before => Exec["curl -O $PROTOBUF_DIST"],
      }
    }
  }

  # Build protobuf.
  exec {"curl -O $PROTOBUF_DIST":
    cwd => "/tmp",
    path => $path,
    require => Package["wget"]
  }
  ->
  exec {"tar -xvf $PROTOBUF_VER.tar.bz2":
    cwd => "/tmp",
    path => $path,
    creates => "/tmp/$PROTOBUF_VER"
  }
  ->
  exec {"/tmp/protobuf-2.5.0/configure --prefix=${INSTALL_ROOT}/protoc/":
    cwd => "/tmp/protobuf-2.5.0",
    path => $path,
  }
  ->
  exec {"make":
    cwd => "/tmp/protobuf-2.5.0",
    path => $path,
  }
  ->
  exec {"make install -k":
    cwd => "/tmp/protobuf-2.5.0",
    path => $path,
  }

  # Build Tez.
  exec {"git clone --branch $TEZ_BRANCH https://git-wip-us.apache.org/repos/asf/tez.git tez":
    cwd => "/tmp",
    path => $path,
    require => Exec["make install -k"],
  }
  ->
  exec {"mvn clean package install -DskipTests -Dhadoop.version=$HADOOP_VERSION -Paws -Phadoop24 -P\!hadoop26":
    cwd => "/tmp",
    path => $path,
    creates => "XXX",
  }

  # Build Hive.
  exec {"git clone --branch $HIVE_BRANCH https://github.com/apache/hive":
    cwd => "/tmp",
    path => $path,
    require => Exec["make install -k"],
  }
  ->
  exec {'sed -i~ "s@<tez.version>.*</tez.version>@<tez.version>$(TEZ_VERSION)</tez.version>@" pom.xml':
    cwd => "/tmp/hive",
    path => $path,
  }
  ->
  exec {"mvn clean package -Denforcer.skip=true -DskipTests=true -Pdir -Pdist -Phadoop-2 -Dhadoop-0.23.version=$HADOOP_VERSION -Dbuild.profile=nohcat":
    cwd => "/tmp",
    path => $path,
    creates => "XXX",
  }

  # Merge LLAP configuration into Hive configuration.
  file { '/tmp/config-llap.xml':
    ensure => file,
    content => template('llap/llap-frag.erb'),
  }
}
