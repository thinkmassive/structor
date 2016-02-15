create database if not exists ${DB};
use ${DB};

drop table if exists lineitem;
create table lineitem 
(L_ORDERKEY INT,
 L_PARTKEY INT,
 L_SUPPKEY INT,
 L_LINENUMBER INT,
 L_QUANTITY DOUBLE,
 L_EXTENDEDPRICE DOUBLE,
 L_DISCOUNT DOUBLE,
 L_TAX DOUBLE,
 L_RETURNFLAG STRING,
 L_LINESTATUS STRING,
 L_SHIPDATE STRING,
 L_COMMITDATE STRING,
 L_RECEIPTDATE STRING,
 L_SHIPINSTRUCT STRING,
 L_SHIPMODE STRING,
 L_COMMENT STRING)
CLUSTERED BY (L_ORDERKEY) into 3 BUCKETS
STORED AS ORC 
tblproperties("transactional"="true");
insert into table lineitem select * from ${SOURCE}.lineitem;

drop table if exists orders;
create table orders (O_ORDERKEY INT,
 O_CUSTKEY INT,
 O_ORDERSTATUS STRING,
 O_TOTALPRICE DOUBLE,
 O_ORDERDATE STRING,
 O_ORDERPRIORITY STRING,
 O_CLERK STRING,
 O_SHIPPRIORITY INT,
 O_COMMENT STRING)
CLUSTERED BY (O_ORDERKEY) into 3 BUCKETS
STORED AS ORC
tblproperties("transactional"="true");
insert into table orders select * from ${SOURCE}.orders;

drop table if exists part;
create table part (P_PARTKEY INT,
 P_NAME STRING,
 P_MFGR STRING,
 P_BRAND STRING,
 P_TYPE STRING,
 P_SIZE INT,
 P_CONTAINER STRING,
 P_RETAILPRICE DOUBLE,
 P_COMMENT STRING) 
CLUSTERED BY (P_PARTKEY) into 3 BUCKETS
STORED AS ORC 
tblproperties("transactional"="true");
insert into table part select * from ${SOURCE}.part;

drop table if exists supplier;
create table supplier (S_SUPPKEY INT,
 S_NAME STRING,
 S_ADDRESS STRING,
 S_NATIONKEY INT,
 S_PHONE STRING,
 S_ACCTBAL DOUBLE,
 S_COMMENT STRING) 
CLUSTERED BY (S_SUPPKEY) into 3 BUCKETS
STORED AS ORC 
tblproperties("transactional"="true");
insert into table supplier select * from ${SOURCE}.supplier;

drop table if exists partsupp;
create table partsupp (PS_PARTKEY INT,
 PS_SUPPKEY INT,
 PS_AVAILQTY INT,
 PS_SUPPLYCOST DOUBLE,
 PS_COMMENT STRING)
CLUSTERED BY (PS_PARTKEY) into 3 BUCKETS
STORED AS ORC
tblproperties("transactional"="true");
insert into table partsupp select * from ${SOURCE}.partsupp;

drop table if exists nation;
create table nation (N_NATIONKEY INT,
 N_NAME STRING,
 N_REGIONKEY INT,
 N_COMMENT STRING)
CLUSTERED BY (N_REGIONKEY) into 3 BUCKETS
STORED AS ORC
tblproperties("transactional"="true");
insert into table nation select * from ${SOURCE}.nation;

drop table if exists region;
create table region (R_REGIONKEY INT,
 R_NAME STRING,
 R_COMMENT STRING)
CLUSTERED BY (R_REGIONKEY) into 3 BUCKETS
STORED AS ORC
tblproperties("transactional"="true");
insert into table region select * from ${SOURCE}.region;

drop table if exists customer;
create table customer (C_CUSTKEY INT,
 C_NAME STRING,
 C_ADDRESS STRING,
 C_NATIONKEY INT,
 C_PHONE STRING,
 C_ACCTBAL DOUBLE,
 C_MKTSEGMENT STRING,
 C_COMMENT STRING)
CLUSTERED BY (C_CUSTKEY) into 3 BUCKETS
STORED AS ORC
tblproperties("transactional"="true");
insert into table customer select * from ${SOURCE}.customer;

analyze table customer compute statistics for columns;
analyze table lineitem compute statistics for columns;
analyze table nation compute statistics for columns;
analyze table orders compute statistics for columns;
analyze table part compute statistics for columns;
analyze table partsupp compute statistics for columns;
analyze table region compute statistics for columns;
analyze table supplier compute statistics for columns;
