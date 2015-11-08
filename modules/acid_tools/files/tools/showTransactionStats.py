#!/usr/bin/python

import os
import xml.etree.ElementTree as ET
from urlparse import urlparse

import HiveParser

def main():
	details = HiveParser.getConnectionDetails()
	print "Transaction State Summary:"
	HiveParser.runSql(details, "select TXN_STATE, count(*) from TXNS group by TXN_STATE")

	print "Average number of partitions per transaction:"
	HiveParser.runSql(details, "select avg(c) from (select count(*) c from COMPLETED_TXN_COMPONENTS group by CTC_TXNID) s")

	print "Details of aborted transactions:"
	HiveParser.runSql(details, "select * from TXNS, TXN_COMPONENTS where TXNS.TXN_ID = TXN_COMPONENTS.TC_TXNID")

	print "Compaction details:"
	HiveParser.runSql(details, "select * from COMPACTION_QUEUE")

	print "Current locks:"
	HiveParser.runSql(details, "select * from HIVE_LOCKS")

if __name__ == "__main__":
	main()
