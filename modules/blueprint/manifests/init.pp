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

class blueprint {
  require ambari_server
  $path="/bin:/usr/bin:/sbin:/usr/sbin"

  exec { "deploy blueprint":
    command => "curl -H \"X-Requested-By: ambari\" -X POST --data @/vagrant/files/blueprint.json -u admin:admin http://localhost:8080/api/v1/blueprints/BP",
    path => $path,
  }
 ->
  exec { "install blueprint":
    command => "curl -iv -H \"X-Requested-By: ambari\" -X POST --data @/vagrant/files/cluster.json -u admin:admin http://localhost:8080/api/v1/clusters/supportLab",
    path => $path,
  }
}
