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

class tez_ui {
  require httpd

  $path="/bin:/usr/bin"

  file { "/var/www/html/tez-ui":
    ensure => directory,
    mode => '755',
  }
  ->
  exec { "Extract the Tez UI WAR":
    command => "unzip /usr/hdp/$hdp_version/tez/ui/tez-ui-*.war",
    creates => "/var/www/html/tez-ui/index.html",
    cwd => "/var/www/html/tez-ui",
    path => $path,
  }
  ->
  file { "/var/www/html/tez-ui/scripts/configs.js":
    ensure => file,
    content => template('tez_ui/configs.js.erb'),
  }
}
