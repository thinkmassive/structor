drop table if exists nation;
CREATE TABLE NATION  ( N_NATIONKEY  INTEGER  primary key,
                            N_NAME       CHAR(25),
                            N_REGIONKEY  INTEGER,
                            N_COMMENT    VARCHAR(152));

drop table if exists region;
CREATE TABLE REGION  ( R_REGIONKEY  INTEGER primary key,
                            R_NAME       CHAR(25),
                            R_COMMENT    VARCHAR(152));

drop table if exists part;
CREATE TABLE PART  ( P_PARTKEY     INTEGER primary key,
                          P_NAME        VARCHAR(55),
                          P_MFGR        CHAR(25),
                          P_BRAND       CHAR(10),
                          P_TYPE        VARCHAR(25),
                          P_SIZE        INTEGER,
                          P_CONTAINER   CHAR(10),
                          P_RETAILPRICE DECIMAL(15,2),
                          P_COMMENT     VARCHAR(23) );

drop table if exists supplier;
CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER primary key,
                             S_NAME        CHAR(25),
                             S_ADDRESS     VARCHAR(40),
                             S_NATIONKEY   INTEGER,
                             S_PHONE       CHAR(15),
                             S_ACCTBAL     DECIMAL(15,2),
                             S_COMMENT     VARCHAR(101));

drop table if exists partsupp;
CREATE TABLE PARTSUPP ( PS_PARTKEY     INTEGER primary key,
                             PS_SUPPKEY     INTEGER,
                             PS_AVAILQTY    INTEGER,
                             PS_SUPPLYCOST  DECIMAL(15,2) ,
                             PS_COMMENT     VARCHAR(199) );

drop table if exists customer;
CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER primary key,
                             C_NAME        VARCHAR(25),
                             C_ADDRESS     VARCHAR(40),
                             C_NATIONKEY   INTEGER,
                             C_PHONE       CHAR(15),
                             C_ACCTBAL     DECIMAL(15,2)  ,
                             C_MKTSEGMENT  CHAR(10),
                             C_COMMENT     VARCHAR(117));

drop table if exists orders;
CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER primary key,
                           O_CUSTKEY        INTEGER,
                           O_ORDERSTATUS    CHAR(1),
                           O_TOTALPRICE     DECIMAL(15,2),
                           O_ORDERDATE      DATE,
                           O_ORDERPRIORITY  CHAR(15),
                           O_CLERK          CHAR(15),
                           O_SHIPPRIORITY   INTEGER,
                           O_COMMENT        VARCHAR(79));

drop table if exists lineitem;
CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER primary key,
                             L_PARTKEY     INTEGER,
                             L_SUPPKEY     INTEGER,
                             L_LINENUMBER  INTEGER,
                             L_QUANTITY    DECIMAL(15,2),
                             L_EXTENDEDPRICE  DECIMAL(15,2),
                             L_DISCOUNT    DECIMAL(15,2),
                             L_TAX         DECIMAL(15,2),
                             L_RETURNFLAG  CHAR(1),
                             L_LINESTATUS  CHAR(1),
                             L_SHIPDATE    DATE,
                             L_COMMITDATE  DATE,
                             L_RECEIPTDATE DATE,
                             L_SHIPINSTRUCT CHAR(25),
                             L_SHIPMODE     CHAR(10),
                             L_COMMENT      VARCHAR(44));
