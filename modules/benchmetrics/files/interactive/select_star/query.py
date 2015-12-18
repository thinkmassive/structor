import pyodbc

cnxn = pyodbc.connect('DSN=Hortonworks Hive DSN;UID=vagrant;PWD=vagrant', autocommit=True)
cursor = cnxn.cursor()

cursor.execute("select * from airline_ontime.flights;")
row = cursor.fetchone()
print row
cursor.close()
cnxn.close()
