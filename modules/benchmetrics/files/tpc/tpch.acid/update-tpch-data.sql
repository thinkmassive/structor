use ${DB};

drop table if exists lineitem_stage purge;
create external table lineitem_stage
(L_ORDERKEY BIGINT,
 L_PARTKEY BIGINT,
 L_SUPPKEY BIGINT,
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
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE
LOCATION '/tmp/tpch.updates/lineitem_stage';

drop table if exists orders_stage purge;
create external table orders_stage (O_ORDERKEY BIGINT,
 O_CUSTKEY BIGINT,
 O_ORDERSTATUS STRING,
 O_TOTALPRICE DOUBLE,
 O_ORDERDATE STRING,
 O_ORDERPRIORITY STRING,
 O_CLERK STRING,
 O_SHIPPRIORITY INT,
 O_COMMENT STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE
LOCATION '/tmp/tpch.updates/orders_stage';

drop table if exists delete_stage purge;
create external table delete_stage (D_ORDERKEY BIGINT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE
LOCATION '/tmp/tpch.updates/delete_stage';

insert into table lineitem select * from lineitem_stage;
insert into table orders select * from orders;
delete from lineitem where L_ORDERKEY in (select D_ORDERKEY from delete_stage);
delete from orders   where O_ORDERKEY in (select D_ORDERKEY from delete_stage);
