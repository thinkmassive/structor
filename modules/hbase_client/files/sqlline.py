#!/usr/bin/env python
############################################################################
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
############################################################################

import os
import subprocess
import sys
import phoenix_utils
import atexit

from optparse import OptionParser

global childProc, tempFile
childProc = None
tempFile = None
def kill_child():
    if tempFile is not None:
        try:
            os.unlink(tempFile)
        except:
            pass
    if childProc is not None:
        childProc.terminate()
        childProc.kill()
        if os.name != 'nt':
            os.system("reset")
atexit.register(kill_child)

if __name__ == '__main__':
    phoenix_utils.setPath()

    parser = OptionParser()
    parser.add_option("-e", "--evaluate", help="Evaluate inline SQL")
    parser.add_option("-f", "--file", dest="run", help="SQL script to execute")
    parser.add_option("-m", "--memory", help="Max client memory")
    parser.add_option("-z", "--zookeeper", help="Zookeeper quorum")

    defaultColor = "true"
    if os.name == 'nt':
        defaultColor = "false"

    automatic = [ "run", "color", "fastconnect", "maxWidth", "outputformat", "verbose" ]
    parser.add_option("--color", help="control whether color is used for display", default=defaultColor)
    parser.add_option("--fastconnect", help="skip building table/column list for tab-completion")
    parser.add_option("--maxWidth", help="the maximum width of the terminal")
    parser.add_option("--outputformat", help="format mode for result display (table/vertical/csv/tsv)")
    parser.add_option("--verbose", help="show verbose error messages and debug info")
    (options, args) = parser.parse_args()

    # Handle positional arguments.
    if len(args) >= 1:
        options.zookeeper = args[0]
    if len(args) >= 2:
        options.run = args[1]

    # Attempt to find the Zookeeper quorum if it's not specified.
    if options.zookeeper == None:
        options.zookeeper = phoenix_utils.find_zookeeper()

    # Explicit memory setting?
    memory_arg = ""
    if options.memory != None:
        memory_arg = " {0} ".format(options.memory)

    # Build the classpath. Having core-site in the classpath lets us connect to secure clusters.
    classpath_components = [ phoenix_utils.hbase_conf_dir,
                             phoenix_utils.hadoop_conf,
                             phoenix_utils.phoenix_client_jar,
                             phoenix_utils.hadoop_common_jar,
                             phoenix_utils.hadoop_hdfs_jar ]
    classpath = os.pathsep.join(classpath_components)

    # Inline SQL. SQLLine offers no native support.
    if options.evaluate:
        from tempfile import NamedTemporaryFile
        f = NamedTemporaryFile(delete=False)
        tempFile = f.name
        f.write(options.evaluate)
        f.close()
        options.run = tempFile

    # Special quoting.
    if options.run:
        options.run = phoenix_utils.shell_quote([options.run])
    options.zookeeper = phoenix_utils.shell_quote([options.zookeeper])

    # Build the Java command line.
    option_hash = dict((x, eval("options.%s" % x)) for x in automatic)
    other_options = " ".join([ "--%s=%s" % (x, option_hash[x]) for x in automatic if option_hash[x]])
    java_cmd = 'java ' + \
        memory_arg + \
        '-cp "' + classpath + \
        '" -Dlog4j.configuration=file:' + os.path.join(phoenix_utils.current_dir, "log4j.properties") + \
        " sqlline.SqlLine -d org.apache.phoenix.jdbc.PhoenixDriver " + \
        " -u jdbc:phoenix:" + options.zookeeper + \
        " -n none -p none --isolation=TRANSACTION_READ_COMMITTED "  + \
        other_options

    childProc = subprocess.Popen(java_cmd, shell=True)
    # Wait for child process exit
    (output, error) = childProc.communicate()
    childProc = None
