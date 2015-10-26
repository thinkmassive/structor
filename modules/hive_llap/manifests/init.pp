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

class hive_llap {
  require hive_client
  require tez_client
  require slider

  $APP_PATH="/user/vagrant/apps/llap"
  $INSTALL_ROOT="/home/vagrant/llap"
  $TEZ_BRANCH="master"
  $TEZ_VERSION="0.8.2-SNAPSHOT"
  $LLAP_BRANCH="llap"
  $HIVE_VERSION="2.0.0-SNAPSHOT"
  $PROTOBUF_VER="protobuf-2.5.0"
  $PROTOBUF_DIST="http://protobuf.googlecode.com/files/$PROTOBUF_VER.tar.bz2"

  # XXX: This path only works on Owen's base box!
  $m2_home="/usr/local/share/apache-maven-3.2.1"
  $path="/bin:/usr/bin:$INSTALL_ROOT/protoc/bin:$m2_home/bin"
  $start_script="/usr/hdp/autobuild/etc/rc.d/init.d/hive-llap"

  $hive_package="apache-hive-$HIVE_VERSION-bin"
  $target_hive="/home/vagrant/hivesrc/packaging/target/$hive_package.tar.gz"
  $target_tez="/home/vagrant/tezsrc/tez-dist/target/tez-$TEZ_VERSION.tar.gz"

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

  # Add vendor repos to Maven.
  exec {"Add Vendor Repos":
    command => "sed -i~ -e '/<profiles>/r /vagrant/modules/hive_llap/files/vendor-repos.xml' settings.xml",
    cwd => "$m2_home/conf",
    path => $path,
    unless => 'grep HDPReleases settings.xml',
  }

  # Reset the install.
  exec {"rm -rf $INSTALL_ROOT":
    cwd => "/",
    path => $path,
  }

  # Build protobuf.
  exec {"curl -O $PROTOBUF_DIST":
    cwd => "/tmp",
    path => $path,
    creates => "/tmp/$PROTOBUF_VER.tar.bz2",
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

  file {"Allow access to dist":
    path => '/home/vagrant',
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => '755',
    before => Exec['Build Tez'],
  }

  # Build Tez.
  exec {"git clone --branch $TEZ_BRANCH https://github.com/apache/tez tezsrc":
    cwd => "/home/vagrant",
    path => $path,
    require => Exec["Install Protobuf"],
    creates => "/home/vagrant/tezsrc",
    user => "vagrant",
  }
  ->
  exec {"Update Tez":
    command => "git pull",
    cwd => "/home/vagrant/tezsrc",
    path => $path,
    user => "vagrant",
    creates => "/tmp/skip",
  }
  ->
  file {"Bower is stupid":
    path => '/home/root',
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => '755',
  }
  ->
  exec {'Build Tez':
    command => 'mvn clean package install -DskipTests -Dhadoop.version=$(hadoop version | head -1 | cut -d" " -f2) -Paws -Phadoop24 -P\\!hadoop26',
    cwd => "/home/vagrant/tezsrc",
    path => $path,
    creates => $target_tez,
    user => "vagrant",
    timeout => 1200,
    require => Exec['Add Vendor Repos'],
  }

  # Deploy Tez
  file { "$INSTALL_ROOT/tez":
    ensure => directory,
    owner => root,
    group => root,
    mode => '755',
    require => Exec['Build Tez'],
  }
  ->
  exec {"Deploy Tez Locally":
    cwd => "/",
    path => $path,
    command => "tar -C $INSTALL_ROOT/tez -xzvf $target_tez",
  }
  ->
  exec {"Make Tez Directory":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -mkdir -p $APP_PATH/tez",
    user => "vagrant",
  }
  ->
  exec {"Deploy Tez to HDFS":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $target_tez $APP_PATH/tez/tez.tar.gz",
    user => "vagrant",
  }

  # Build Hive / LLAP.
  exec {"git clone --branch $LLAP_BRANCH https://github.com/apache/hive hivesrc":
    cwd => "/home/vagrant",
    path => $path,
    require => Exec["Install Protobuf"],
    creates => "/home/vagrant/hivesrc",
    user => "vagrant",
  }
  ->
  exec {"Update Hive":
    command => "git pull",
    cwd => "/home/vagrant/hivesrc",
    path => $path,
    user => "vagrant",
    creates => "/tmp/skip",
  }
  ->
  exec {"Put the right Tez version in Hive's POM":
    command => "sed -i~ 's@<tez.version>.*</tez.version>@<tez.version>${TEZ_VERSION}</tez.version>@' pom.xml",
    cwd => "/home/vagrant/hivesrc",
    path => $path,
    user => "vagrant",
  }
  ->
  exec { "Build Hive":
    cwd => "/home/vagrant/hivesrc",
    path => $path,
    command => 'mvn clean package -Denforcer.skip=true -DskipTests=true -Pdir -Pdist -Phadoop-2 -Dhadoop-0.23.version=$(hadoop version | head -1 | cut -d" " -f2) -Dbuild.profile=nohcat',
    creates => $target_hive,
    user => "vagrant",
    timeout => 1200,
    require => Exec['Add Vendor Repos'],
  }

  exec {"Deploy Hive":
    cwd => "/",
    path => $path,
    command => "tar -C $INSTALL_ROOT -xzvf $target_hive",
    require => Exec['Build Hive'],
  }
  ->
  file {"$INSTALL_ROOT/hive":
    ensure => link,
    target => "$INSTALL_ROOT/$hive_package",
  }
  ->
  exec {"Make Hive directory":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -mkdir -p $APP_PATH/hive",
    user => "vagrant",
  }
  ->
  exec {"Deploy Hive Exec to HDFS":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $INSTALL_ROOT/hive/lib/hive-exec-${HIVE_VERSION}.jar $APP_PATH/hive",
    user => "vagrant",
  }
  ->
  exec {"Deploy Hive LLAP to HDFS":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $INSTALL_ROOT/hive/lib/hive-llap-server-${HIVE_VERSION}.jar $APP_PATH/hive",
    user => "vagrant",
  }

  # Handy scripts.
  file { "/home/vagrant/llapGenerateSlider.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/llapGenerateSlider.sh',
  }
  file { "/home/vagrant/llapRunClient.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/llapRunClient.sh',
  }
  file { "/home/vagrant/README.LLAP":
    ensure => file,
    source => 'puppet:///modules/hive_llap/README.LLAP',
  }

  # Configuration files.
  exec {"mv $INSTALL_ROOT/hive/conf $INSTALL_ROOT/hive/conf.dist":
    cwd => "/",
    path => $path,
    require => Exec['Deploy Hive'],
  }
  ->
  file {"$INSTALL_ROOT/hive/conf":
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => '755',
  }
  ->
  exec {"cp /etc/hive/conf/* $INSTALL_ROOT/hive/conf":
    cwd => "/",
    path => $path,
  }
  ->
  file { "$INSTALL_ROOT/hive/conf/llap-daemon-site.xml":
    ensure => file,
    content => template('hive_llap/llap-daemon-site.erb'),
  }
  ->
  file { "$INSTALL_ROOT/hive/conf/llap-daemon-log4j.properties":
    ensure => file,
    source => 'puppet:///modules/hive_llap/llap-daemon-log4j.properties',
  }
  ->
  file { "$INSTALL_ROOT/hive/conf/hive-env.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/hive-env.sh',
  }
  ->
  file { "$INSTALL_ROOT/hive/bin/hive-env.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/hive-env.sh',
  }
  ->
  file { "$INSTALL_ROOT/hive/bin/hive-config.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/hive-config.sh',
  }
  ->
  exec {"Merge LLAP Fragment":
    command => "python /vagrant/files/xmlcombine.py $INSTALL_ROOT/hive/conf/hive-site.xml hive_llap hive-site-llap-extras",
    cwd => "/",
    path => $path,
  }
  ->
  file {"$INSTALL_ROOT/tez/conf":
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => '755',
    require => Exec['Deploy Tez Locally'],
  }
  ->
  file { "$INSTALL_ROOT/tez/conf/tez-site.xml":
    ensure => file,
    content => template('hive_llap/tez-site.xml.erb'),
  }
}
