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

class maven {
  $maven_version="3.3.3"
  $maven_base="apache-maven-$maven_version"
  $maven_bin="$maven_base-bin.tar.gz"
  $maven_dist="http://mirrors.ibiblio.org/apache/maven/maven-3/$maven_version/binaries/$maven_bin"
  $m2_home="/usr/local/share/$maven_base"
  $path="/bin:/usr/bin:$install_root/protoc/bin:$m2_home/bin"

  # Get Maven.
  exec {"Install Maven":
    command => "curl -C - -O $maven_dist",
    cwd => "/tmp",
    path => $path,
    creates => "/tmp/$maven_bin",
  }
  ->
  exec {"tar -C /usr/local/share -xvf $maven_bin":
    cwd => "/tmp",
    path => $path,
    creates => "$m2_home",
    before => Exec["Add Vendor Repos"],
  }

  file { "/usr/local/share/maven":
    ensure => "link",
    target => "/usr/local/share/$maven_base",
  }

  # Add to profile.d.
  file { "/etc/profile.d/maven.sh":
    ensure => "file",
    source => 'puppet:///modules/maven/maven.sh',
  }

  # Add vendor repos to Maven.
  exec {"Add Vendor Repos":
    command => "sed -i~ -e '/<profiles>/r /vagrant/modules/maven/files/vendor-repos.xml' settings.xml",
    cwd => "$m2_home/conf",
    path => $path,
    unless => 'grep HDPReleases settings.xml',
  }
}
