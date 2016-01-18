import os,sys,re,math
from getopt import getopt
from glob import glob
from os.path import basename
from datetime import datetime 

testplan = """
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="2.8" jmeter="2.13 r1665067">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="HIVE" enabled="true">
      <stringProp name="TestPlan.comments"></stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
      <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
        <collectionProp name="Arguments.arguments"/>
      </elementProp>
      <stringProp name="TestPlan.user_define_classpath">../../apache-hive-1.3.0-SNAPSHOT-jdbc.jar</stringProp>
    </TestPlan>
    <hashTree>
      <CSVDataSet guiclass="TestBeanGUI" testclass="CSVDataSet" testname="CSV Data Set Config" enabled="true">
        <stringProp name="filename">./queries_%(results_for)s.csv</stringProp>
        <stringProp name="fileEncoding"></stringProp>
        <stringProp name="variableNames">queryId,query</stringProp>
        <stringProp name="delimiter">^</stringProp>
        <boolProp name="quotedData">true</boolProp>
        <boolProp name="recycle">false</boolProp>
        <boolProp name="stopThread">true</boolProp>
        <stringProp name="shareMode">shareMode.all</stringProp>
      </CSVDataSet>
      <hashTree/>
      %(thread_groups)s
      <ResultCollector guiclass="SummaryReport" testclass="ResultCollector" testname="Summary Report" enabled="true">
        <boolProp name="ResultCollector.error_logging">false</boolProp>
        <objProp>
          <name>saveConfig</name>
          <value class="SampleSaveConfiguration">
            <time>true</time>
            <latency>true</latency>
            <timestamp>true</timestamp>
            <success>true</success>
            <label>true</label>
            <code>true</code>
            <message>true</message>
            <threadName>true</threadName>
            <dataType>true</dataType>
            <encoding>false</encoding>
            <assertions>true</assertions>
            <subresults>true</subresults>
            <responseData>true</responseData>
            <samplerData>true</samplerData>
            <xml>true</xml>
            <fieldNames>false</fieldNames>
            <responseHeaders>false</responseHeaders>
            <requestHeaders>false</requestHeaders>
            <responseDataOnError>false</responseDataOnError>
            <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
            <assertionsResultsToSave>0</assertionsResultsToSave>
            <bytes>true</bytes>
            <threadCounts>true</threadCounts>
          </value>
        </objProp>
        <stringProp name="filename">summary_%(results_for)s.xml</stringProp>
      </ResultCollector>
      <hashTree/>
      <JDBCDataSource guiclass="TestBeanGUI" testclass="JDBCDataSource" testname="JDBC Connection Configuration" enabled="true">
        <stringProp name="dataSource">hiveConnection</stringProp>
        <stringProp name="poolMax">%(threads)d</stringProp>
        <stringProp name="timeout">0</stringProp>
        <stringProp name="trimInterval">60000</stringProp>
        <boolProp name="autocommit">false</boolProp>
        <stringProp name="transactionIsolation">DEFAULT</stringProp>
        <boolProp name="keepAlive">true</boolProp>
        <stringProp name="connectionAge">5000000</stringProp>
        <stringProp name="checkQuery"></stringProp>
        <stringProp name="dbUrl">%(jdbc)s</stringProp>
        <stringProp name="driver">org.apache.hive.jdbc.HiveDriver</stringProp>
        <stringProp name="username"></stringProp>
        <stringProp name="password"></stringProp>
      </JDBCDataSource>
      <hashTree/>
      <ResultCollector guiclass="ViewResultsFullVisualizer" testclass="ResultCollector" testname="View Results Tree" enabled="true">
        <boolProp name="ResultCollector.error_logging">false</boolProp>
        <objProp>
          <name>saveConfig</name>
          <value class="SampleSaveConfiguration">
            <time>true</time>
            <latency>true</latency>
            <timestamp>true</timestamp>
            <success>true</success>
            <label>true</label>
            <code>true</code>
            <message>true</message>
            <threadName>true</threadName>
            <dataType>true</dataType>
            <encoding>false</encoding>
            <assertions>true</assertions>
            <subresults>true</subresults>
            <responseData>false</responseData>
            <samplerData>false</samplerData>
            <xml>true</xml>
            <fieldNames>false</fieldNames>
            <responseHeaders>false</responseHeaders>
            <requestHeaders>false</requestHeaders>
            <responseDataOnError>false</responseDataOnError>
            <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
            <assertionsResultsToSave>0</assertionsResultsToSave>
            <bytes>true</bytes>
            <threadCounts>true</threadCounts>
          </value>
        </objProp>
        <stringProp name="filename">raw_%(results_for)s.xml</stringProp>
      </ResultCollector>
      <hashTree/>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
"""


thread_group = """
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="User-%(group)d" enabled="true">
        <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
        <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
          <boolProp name="LoopController.continue_forever">false</boolProp>
          <intProp name="LoopController.loops">-1</intProp>
        </elementProp>
        <stringProp name="ThreadGroup.num_threads">1</stringProp>
        <stringProp name="ThreadGroup.ramp_time">1</stringProp>
        <longProp name="ThreadGroup.start_time">1448412990000</longProp>
        <longProp name="ThreadGroup.end_time">1448412990000</longProp>
        <boolProp name="ThreadGroup.scheduler">false</boolProp>
        <stringProp name="ThreadGroup.duration"></stringProp>
        <stringProp name="ThreadGroup.delay"></stringProp>
      </ThreadGroup>
      <hashTree>
        <JDBCSampler guiclass="TestBeanGUI" testclass="JDBCSampler" testname="${queryId}" enabled="true">
          <stringProp name="dataSource">hiveConnection</stringProp>
          <stringProp name="queryType">Select Statement</stringProp>
          <stringProp name="query">${query}</stringProp>
          <stringProp name="queryArguments"></stringProp>
          <stringProp name="queryArgumentsTypes"></stringProp>
          <stringProp name="variableNames"></stringProp>
          <stringProp name="resultVariable">${queryId}</stringProp>
          <stringProp name="queryTimeout"></stringProp>
          <stringProp name="resultSetHandler">Store as String</stringProp>
        </JDBCSampler>
        <hashTree/>
      </hashTree>
"""


SQL_COMMENT = re.compile("-- .*") 

def scrub(l):
    global SQL_COMMENT
    m = SQL_COMMENT.search(l)
    if m: return l.replace(m.group(0), "");
    return l
def oneliner(q):
    lines = [scrub(l.strip()) for l in q.split("\n")]
    return " ".join(lines)

def main(argv):
    (opts, args) = getopt(argv, "d:e:j:n:p:t:u:")
    threads = 1
    repeats = 1
    explain = ""
    path = None
    jdbc = "jdbc:hive2://localhost:10000/"
    database = None
    for k,v in opts:
        if(k == "-d"):
            database = v
        if(k == "-e"):
            explain = "explain formatted "
        if(k == "-j"):
            jdbc = v
        if(k == "-n"):
            repeats = int(v)
        if(k == "-p"):
            path = v
        if(k == "-t"):
            threads = int(v)
        if(k == "-u"):
            jdbc = v
    if database == None:
        print "Specify database (-d)"
        sys.exit(1)
    jdbc_url = jdbc + "%s?hive.exec.orc.split.strategy=ETL" % database;

    if path == None:
        print "Need -p (path to queries)"
        sys.exit(1)
    output_path = "runs/%s" % os.path.basename(path)
    queries = []
    queries += [("hive", v) for v in glob("%s/*.sql"% path)]
    if len(queries) == 0:
        print "Empty input path"
        sys.exit(1)
    now = "x%d_%s" % (threads, datetime.now().strftime("%s")) 

    jdbc_queries = []
    for (qtype, q) in queries:
        qtext = open(q).read()
        if (len(qtext.split(";")) > 2):
            sys.stderr.write("Cannot load " + q + " too many queries in one file")
            continue
        qtext = qtext.replace(";","")
        qname = basename(q).replace(".sql","")
        jdbc_queries.append((qname, oneliner(qtext)))

    try:
        os.mkdir(output_path)
    except:
        pass
    open("%s/queries_%s.csv" % (output_path, now), "w").write("\n".join(["hive-%s^%s" % j for j in jdbc_queries])) 

    thread_groups = ""
    for i in range(threads):
        thread_groups += thread_group % {"group" : i, "repeats" : repeats} 
    args = {
        "jdbc" : jdbc,
        "threads" : threads,
        "thread_groups" : thread_groups,
        "results_for" : now 
    }
    open("%s/driver_%s.jmx" % (output_path, now), "w").write(testplan % args)

    print "Driver and query set written to", output_path

if __name__ == "__main__":
    main(sys.argv[1:])
