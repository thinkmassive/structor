create database if not exists airline_ontime;
use airline_ontime;

drop table if exists flights_raw purge;
drop table if exists airports_raw purge;
drop table if exists airlines_raw purge;
drop table if exists planes_raw purge;

create table flights_raw (
  Year int,
  Month int,
  DayofMonth int,
  DayOfWeek int,
  DepTime  int,
  CRSDepTime int,
  ArrTime int,
  CRSArrTime int,
  UniqueCarrier varchar(6),
  FlightNum int,
  TailNum varchar(8),
  ActualElapsedTime int,
  CRSElapsedTime int,
  AirTime int,
  ArrDelay int,
  DepDelay int,
  Origin varchar(3),
  Dest varchar(3),
  Distance int,
  TaxiIn int,
  TaxiOut int,
  Cancelled int,
  CancellationCode varchar(1),
  Diverted varchar(1),
  CarrierDelay int,
  WeatherDelay int,
  NASDelay int,
  SecurityDelay int,
  LateAircraftDelay int
) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
                "separatorChar" = ",",
                "quoteChar"     = '"',
                "escapeChar"    = "\\"
                )  
stored as textfile 
tblproperties ("skip.header.line.count"="1")
;

create table airports_raw (
	iata string,
	airport string,
	city string,
	state double,
	country string,
	lat double,
	lon double
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
                "separatorChar" = ",",
                "quoteChar"     = '"',
                "escapeChar"    = "\\"
                )  
stored as textfile 
tblproperties ("skip.header.line.count"="1")
;

create table airlines_raw (
	code string,
	description string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
                "separatorChar" = ",",
                "quoteChar"     = '"',
                "escapeChar"    = "\\"
                )  
stored as textfile 
tblproperties ("skip.header.line.count"="1")
;

create table planes_raw (
	tailnum string,
	owner_type string,
	manufacturer string,
	issue_date string,
	model string,
	status string,
	aircraft_type string,
	engine_type string,
	year int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
                "separatorChar" = ",",
                "quoteChar"     = '"',
                "escapeChar"    = "\\"
                )  
stored as textfile
tblproperties ("skip.header.line.count"="1")
;

LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1987.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1988.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1989.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1990.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1991.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1992.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1993.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1994.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1995.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1996.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1997.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1998.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/1999.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2000.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2001.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2002.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2003.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2004.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2005.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2006.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2007.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/2008.csv.bz2' INTO TABLE flights_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/carriers.csv.gz' INTO TABLE airlines_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/airports.csv.gz' INTO TABLE airports_raw;
LOAD DATA LOCAL INPATH '/vagrant/modules/sample_airline_data/files/raw/plane-data.csv.gz' INTO TABLE planes_raw;
