import pyodbc

cnxn = pyodbc.connect('DSN=Hortonworks Hive DSN;UID=vagrant;PWD=vagrant', autocommit=True)
cursor = cnxn.cursor()

query = """
select
   sum(sales_fact_1998.store_sales)
from
   foodmart.sales_fact_1998
   join foodmart.time_by_day on sales_fact_1998.time_id = time_by_day.time_id
group by
   1
having
   (count(1) > 0);
"""

cursor.execute(query)
row = cursor.fetchone()
print row
