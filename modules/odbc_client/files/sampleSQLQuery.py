import pyodbc

cnxn = pyodbc.connect('DSN=Hortonworks Hive DSN;UID=vagrant;PWD=vagrant', autocommit=True)
cursor = cnxn.cursor()

print "Number of records in sales_fact_1997 database:"
cursor.execute("select count(*) from foodmart.sales_fact_1997;")
row = cursor.fetchone()
if row:
	print row
