import pyodbc
import time
import threading

def query_with_time_out(conn, query, timeout):
	def watchdog(cursor, timeout):
		time.sleep(timeout)
		print "Canceling", cursor
		cursor.cancel()

	cursor = conn.cursor()
	t = threading.Thread(target=watchdog, args=(cursor, timeout))
	t.start()
	try:
		cursor.execute(query)
		result = cursor.fetchall()
	except Exception:
		result = 'timed out'

	return result

querytext = """
select * from (
select
   iata, airport, city, description, c, row_number() over (partition by iata order by c desc) rn
from (
   select
      iata, airport, city, description, count(*) c
   from
      airline_ontime.flights, airline_ontime.airports, airline_ontime.airlines
   where
      flights.origin = cast(airports.iata as varchar(3))
      and flights.uniquecarrier = cast(airlines.code as varchar(6))
   group by
      iata, airport, city, description) sub ) sub2
where
   rn <= 3;
"""

cnxn = pyodbc.connect('DSN=Hortonworks Hive DSN;UID=vagrant;PWD=vagrant', autocommit=True)
cursor = cnxn.cursor()
query_with_time_out(cnxn, querytext, 5)
