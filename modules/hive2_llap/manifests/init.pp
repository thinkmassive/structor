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

  # LLAP Sizing:
  # LLAP will take up all YARN memory minus 1 GB (including Slider AM overhead of 0.5 GB)
  #   First: Try to set number of executors = number of CPUs.
  #   If we have memory left over, we take the rest up with cache.
  #   Note this only allows 2 concurrent queries (2 AMs)
  if ($vm_mem+0 <= 2048) {
    $yarn_total = $vm_mem - 1024
  } elsif ($vm_mem+0 <= 8192) {
    $yarn_total = $vm_mem - 2048
  } else {
    $yarn_total = $vm_mem - 4096
  }

  # Note: These computations assume <16 GB VMs.
  $max_queries = 2
  $am_size = $am_mem+0
  $slider_am_overhead = 512
  $gc_anti_slop = 512
  $num_executors = $vm_cpus+0
  $total_am_overhead       = ($am_size * $max_queries) + $slider_am_overhead
  $full_executor_allotment = ($client_mem+0) * $num_executors
  $llap_yarn_size          = $yarn_total - $total_am_overhead
  if ($full_executor_allotment > $llap_yarn_size) {
    # Not enough capacity, try it with half the number of executors.
    $num_executors = $num_executors / 2
    $full_executor_allotment = $client_mem+0 * $num_executors
  }
  $cache_size = $llap_yarn_size - $full_executor_allotment
  $xmx_size   = $full_executor_allotment - $gc_anti_slop

  # Build a package.
  $extra_args="-XX:+UseG1GC -XX:TLABSize=8m -XX:+ResizeTLAB -XX:+UseNUMA -XX:+AggressiveOpts -XX:+AlwaysPreTouch -XX:InitiatingHeapOccupancyPercent=80 -XX:MaxGCPauseMillis=200"
  exec { "Eliminate old Slider package":
    command => "rm -rf /usr/hdp/llap-slider",
    path => $path,
  }
  ->
  exec { "Build LLAP package":
    command => "hive2 --service llap --instances 1 --cache ${cache_size}m --executors ${num_executors} --size ${llap_yarn_size}m --xmx ${xmx_size}m --loglevel WARN --slider-am-container-mb 512 --args \"$extra_args\"",
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
