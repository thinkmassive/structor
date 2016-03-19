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

class hive2_llap {
  require hive2
  require slider

  $path="/bin:/usr/bin"

  # Build a package.
  # XXX: Need calculated node count and sizing.
  $extra_args="-XX:+UseG1GC -XX:TLABSize=8m -XX:+ResizeTLAB -XX:+UseNUMA -XX:+AggressiveOpts -XX:+AlwaysPreTouch -XX:InitiatingHeapOccupancyPercent=80 -XX:MaxGCPauseMillis=200"
  exec { "Eliminate old Slider package":
    command => "rm -rf /usr/hdp/llap-slider",
    path => $path,
  }
  ->
  exec { "Build LLAP package":
    command => "hive2 --service llap --instances 1 --cache 1024m --executors 2 --size 4096m --xmx 2048m --loglevel WARN --args \"$extra_args\"",
    cwd => "/usr/hdp",
    path => $path,
  }
  ->
  exec { "Rename LLAP package output to something guessable":
    command => "mv /usr/hdp/llap-slider-* /usr/hdp/llap-slider",
    path => $path,
  }
  ->
  exec { "Make run.sh executable":
    command => "chmod 755 /usr/hdp/llap-slider/run.sh",
    path => $path,
  }

  # Control script.
  # XXX: Don't even know if this is possible.

  # XXX: This needs to go ASAP.
  package { "python-argparse":
    ensure => installed,
    before => Exec["Build LLAP package"],
  }
}
