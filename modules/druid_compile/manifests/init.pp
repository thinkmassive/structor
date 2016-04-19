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

class druid_compile {
  $druid_version="1.1.1"
  $druid_base="imply-$druid_version"
  $druid_home="/usr/local/share/$druid_base"
  $path="/bin:/usr/bin:/usr/sbin"

  exec { "Compile and Install Druid":
    command => "sh /vagrant/modules/druid_base/files/buildForHDP.sh",
    creates => "$druid_home",
    cwd => "/tmp",
    path => $path,
    timeout => 1200,
    user => vagrant,
  }
  ->
  exec { "Stash the Build":
    command => "tar -czf /vagrant/$druid_base-hdp.tar.gz /home/vagrant/tmp/implydata/staging/$druid_base",
    cwd => "/tmp",
    path => $path,
  }
}
