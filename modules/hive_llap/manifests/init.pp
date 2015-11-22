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

class hive_llap {
  require hive_client
  require tez_client
  require slider
  require maven

  $app_path="/user/vagrant/apps/llap"
  $install_root="/home/vagrant/llap"
  $tez_branch="master"
  $tez_version="0.8.2-SNAPSHOT"
  $llap_branch="llap"
  $hive_version="2.0.0-SNAPSHOT"
  $protobuf_ver="protobuf-2.5.0"
  $protobuf_dist="http://protobuf.googlecode.com/files/$protobuf_ver.tar.bz2"
  $path="/bin:/usr/bin:$install_root/protoc/bin:/usr/local/share/maven/bin"

  $start_script="/usr/hdp/autobuild/etc/rc.d/init.d/hive-llap"
  $hive_package="apache-hive-$hive_version-bin"
  $target_hive="/home/vagrant/hivesrc/packaging/target/$hive_package.tar.gz"
  $target_tez="/home/vagrant/tezsrc/tez-dist/target/tez-$tez_version.tar.gz"

  # Build tools I need.
  package { [ "curl", "gcc", "gcc-c++", "cmake", "git" ]:
    ensure => installed,
    before => Exec["Download Protobuf"],
  }
  case $operatingsystem {
    'centos': {
      package { [ "zlib-devel", "openssl-devel" ]:
        ensure => installed,
        before => Exec["Download Protobuf"],
      }
    }
    'ubuntu': {
      package { [ "zlib1g-dev", "libssl-dev" ]:
        ensure => installed,
        before => Exec["Download Protobuf"],
      }
    }
  }

  # Reset the install.
  exec {"rm -rf $install_root":
    cwd => "/",
    path => $path,
  }

  # Build protobuf.
  exec {"Download Protobuf":
    command => "curl -C - -O $protobuf_dist",
    cwd => "/tmp",
    path => $path,
    creates => "/tmp/$protobuf_ver.tar.bz2",
  }
  ->
  exec {"tar -xvf $protobuf_ver.tar.bz2":
    cwd => "/tmp",
    path => $path,
    creates => "/tmp/$protobuf_ver",
  }
  ->
  exec {"/tmp/$protobuf_ver/configure --prefix=$install_root/protoc/":
    cwd => "/tmp/$protobuf_ver",
    path => $path,
    creates => "/tmp/$protobuf_ver/Makefile",
  }
  ->
  exec {"Build Protobuf":
    cwd => "/tmp/$protobuf_ver",
    path => $path,
    command => "make",
    creates => "/tmp/$protobuf_ver/src/protoc",
  }
  ->
  exec {"Install Protobuf":
    cwd => "/tmp/$protobuf_ver",
    path => $path,
    command => "make install -k",
    creates => "$install_root/protoc",
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
  exec {"git clone --branch $tez_branch https://github.com/apache/tez tezsrc":
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
  file { "$install_root/tez":
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
    command => "tar -C $install_root/tez -xzvf $target_tez",
  }
  ->
  exec {"Make Tez Directory":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -mkdir -p $app_path/tez",
    user => "vagrant",
  }
  ->
  exec {"Deploy Tez to HDFS":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $target_tez $app_path/tez/tez.tar.gz",
    user => "vagrant",
  }

  # Build Hive / LLAP.
  exec {"git clone --branch $llap_branch https://github.com/apache/hive hivesrc":
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
    command => "sed -i~ 's@<tez.version>.*</tez.version>@<tez.version>${tez_version}</tez.version>@' pom.xml",
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
    command => "tar -C $install_root -xzvf $target_hive",
    require => Exec['Build Hive'],
  }
  ->
  file {"$install_root/hive":
    ensure => link,
    target => "$install_root/$hive_package",
  }
  ->
  exec {"Make Hive directory":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -mkdir -p $app_path/hive",
    user => "vagrant",
  }
  ->
  exec {"Deploy Hive Exec to HDFS":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $install_root/hive/lib/hive-exec-${hive_version}.jar $app_path/hive",
    user => "vagrant",
  }
  ->
  exec {"Deploy Hive LLAP to HDFS":
    cwd => "/",
    path => $path,
    command => "hdfs dfs -copyFromLocal -f $install_root/hive/lib/hive-llap-server-${hive_version}.jar $app_path/hive",
    user => "vagrant",
  }

  # Handy scripts.
  file { "/home/vagrant/llapGenerateSlider.sh":
    ensure => file,
    mode => "0755",
    source => 'puppet:///modules/hive_llap/llapGenerateSlider.sh',
  }
  file { "/home/vagrant/llapRunClient.sh":
    ensure => file,
    mode => "0755",
    source => 'puppet:///modules/hive_llap/llapRunClient.sh',
  }
  file { "/home/vagrant/controlHiveServer2":
    ensure => file,
    mode => "0755",
    source => 'puppet:///modules/hive_llap/controlHiveServer2',
  }
  file { "/home/vagrant/README.LLAP":
    ensure => file,
    source => 'puppet:///modules/hive_llap/README.LLAP',
  }

  # Configuration files.
  exec {"mv $install_root/hive/conf $install_root/hive/conf.dist":
    cwd => "/",
    path => $path,
    require => Exec['Deploy Hive'],
  }
  ->
  file {"$install_root/hive/conf":
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => '755',
  }
  ->
  exec {"cp /etc/hive/conf/* $install_root/hive/conf":
    cwd => "/",
    path => $path,
  }
  ->
  file { "$install_root/hive/conf/llap-daemon-site.xml":
    ensure => file,
    content => template('hive_llap/llap-daemon-site.erb'),
  }
  ->
  file { "$install_root/hive/conf/llap-daemon-log4j.properties":
    ensure => file,
    source => 'puppet:///modules/hive_llap/llap-daemon-log4j.properties',
  }
  ->
  file { "$install_root/hive/conf/hive-env.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/hive-env.sh',
  }
  ->
  file { "$install_root/hive/bin/hive-env.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/hive-env.sh',
  }
  ->
  file { "$install_root/hive/bin/hive-config.sh":
    ensure => file,
    source => 'puppet:///modules/hive_llap/hive-config.sh',
  }
  ->
  exec {"Merge LLAP Fragment":
    command => "python /vagrant/files/xmlcombine.py $install_root/hive/conf/hive-site.xml hive_llap hive-site-llap-extras",
    cwd => "/",
    path => $path,
  }
  ->
  file {"$install_root/tez/conf":
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => '755',
    require => Exec['Deploy Tez Locally'],
  }
  ->
  file { "$install_root/tez/conf/tez-site.xml":
    ensure => file,
    content => template('hive_llap/tez-site.xml.erb'),
  }
}
