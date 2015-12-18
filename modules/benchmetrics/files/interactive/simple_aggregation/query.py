#!/usr/bin/python

import pyodbc

cnxn = pyodbc.connect('DSN=Hortonworks Hive DSN;UID=vagrant;PWD=vagrant', autocommit=True)
cursor = cnxn.cursor()

cursor.execute("select count(*) from foodmart.sales_fact_1997;")
row = cursor.fetchone()
print row
cursor.close()
cnxn.close()
