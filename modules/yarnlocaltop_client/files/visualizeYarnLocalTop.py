from Node import Node
from optparse import OptionParser

try:
	import pygraphviz as pgv
except:
	assert False, "Requires GraphViz and pygraphviz to be installed"

def main():
	example = "visualizeYarnLocalTop.py -n TezChild -t 0.03 -k FutureTask:run -f output.txt"
	parser = OptionParser(epilog=example)
	parser.add_option("-f", "--file")
	parser.add_option("-k", "--killlist")
	parser.add_option("-n", "--threadname")
	parser.add_option("-o", "--output", default="output.png")
	parser.add_option("-t", "--threshold", default=0.01)
	(options, args) = parser.parse_args()
	if options.file == None:
		assert False, "Input file (-f) option is required"
	if options.threadname== None:
		assert False, "Thread name (-n) option is required"
	threshold = float(options.threshold)

	ignorePackage = {
		"java.lang.reflect" : 1,
		"com.sun.proxy" : 1,
		"sun.reflect" : 1,
		"sun.nio.cs" : 1,
		"java.net" : 1,
		"java.io" : 1,
		"java.lang" : 1,
		"org.apache.hadoop.hive.cli" : 1,
		"org.apache.hadoop.util" : 1,
	}
	ignorePrefix = [
		"org.apache.thrift.",
		"org.apache.log4j.",
		"org.apache.hadoop.hive.metastore.",
	]
	killList = {
	}

	threadname = options.threadname
	traceTree = Node()
	trace = []
	oldPackage = None

	# Build a kill list if specified.
	if options.killlist:
		killList = dict([(x, 1) for x in options.killlist.split(",")])

	with open(options.file) as fd:
		for line in fd:
			if not line.startswith(threadname):
				addTrace(traceTree, trace, killList)
				trace = []
				oldPackage = None
				continue
			line = line.rstrip()
			(thread, traceInfo) = line.split(",")
			leftParen = traceInfo.rfind("(")
			traceInfo = traceInfo[:leftParen]
			path = traceInfo.split(".")
			method = path.pop()
			clazz = path.pop()
			package = ".".join(path)
			if package in ignorePackage:
				continue

			addPackage = True
			for prefix in ignorePrefix:
				if package.startswith(prefix):
					addPackage = False

			if addPackage == True and package != oldPackage:
				oldPackage = package
				trace.append((package, clazz, method))

	addPercentages(traceTree)
	dumpTree(traceTree, threshold)

def buildGraph(graph, parent, child, threshold=0.01):
	parentNodeName = parent
	childNodeName = child.get_name()
	myPercent = child.get_attribute("percent")
	if myPercent < threshold:
		return
	strPercent = "%0.2f%%" % (myPercent * 100)
	effectiveNodeName = "%s (%s)" % (childNodeName, strPercent)
	graph.add_node(effectiveNodeName, fillcolor=setColor(myPercent))
	graph.add_edge(parentNodeName, effectiveNodeName)
	for subchild in child.get_children():
		buildGraph(graph, effectiveNodeName, subchild, threshold)

def dumpTree(tree, threshold=0.01, outputFile="output.png"):
	A=pgv.AGraph()
	A.node_attr['style']='filled'
	A.node_attr['fillcolor']='white'

	myPercent = tree.get_attribute("percent")
	A.add_node("HEAD", fillcolor=setColor(myPercent))
	for child in tree.get_children():
		buildGraph(A, "HEAD", child, threshold)

	# Create the image.
	A.write('.graph.dot')
	B=pgv.AGraph('.graph.dot')
	B.layout(prog="dot")
	B.draw(outputFile)

def setColor(percent):
	# 100% -> Red, 0% -> White
	level = hex(255 - int(255 * percent))[2:]
	if len(level) == 1:
		level = "0" + level
	return "#ff%s%s" % (level, level)
	#return "#%s0000" % level

def addTrace(traceTree, trace, killList):
	if len(trace) > 0:
		# Build the trace path.
		array = [ "%s:%s" % (t[1], t[2]) for t in trace ]
		array.reverse()

		# Increment this path's count.
		thisNode = traceTree
		increment(thisNode)
		for step in array:
			if step in killList:
				return
			try:
				thisNode = thisNode.get_child(step)
			except:
				thisNode = thisNode.add_child(step)
			increment(thisNode)

def addPercentToTree(node, totalCount):
	myCount = node.get_attribute("count")
	node.set_attribute("percent", myCount * 1.0 / totalCount)
	for child in node.get_children():
		addPercentToTree(child, totalCount)

def addPercentages(traceTree):
	totalCount = traceTree.get_attribute("count")
	addPercentToTree(traceTree, totalCount)

def increment(node):
	count = 0
	try:
		count = node.get_attribute("count")
	except:
		pass
	node.set_attribute("count", count + 1)

if __name__ == "__main__":
	main()
