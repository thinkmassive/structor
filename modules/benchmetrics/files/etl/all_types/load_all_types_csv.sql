drop database if exists all_types cascade;
create database all_types;
use all_types;

create table all_types(
	tinyint_val  tinyint,
	smallint_val smallint,
	int_val      int,
	bigint_val   bigint,

	float_val  float,
	double_val double,

	decimal_18_2_val decimal(18, 2),
	decimal_36_6_val decimal(36, 6),

	string_val     string,
	varchar_5_val  varchar(5),
	varchar_80_val varchar(80),
	char_2_val     char(2),
	char_11_val    char(11),

	boolean_val boolean
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
                "separatorChar" = "|",
                "quoteChar"     = '"',
                "escapeChar"    = "\\"
                )
stored as textfile;

LOAD DATA LOCAL INPATH '/tmp/all_types.0.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.1.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.2.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.3.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.4.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.5.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.6.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.7.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.8.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.9.txt' INTO TABLE all_types;

LOAD DATA LOCAL INPATH '/tmp/all_types.0.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.1.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.2.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.3.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.4.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.5.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.6.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.7.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.8.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.9.txt' INTO TABLE all_types;

LOAD DATA LOCAL INPATH '/tmp/all_types.0.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.1.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.2.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.3.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.4.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.5.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.6.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.7.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.8.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.9.txt' INTO TABLE all_types;

LOAD DATA LOCAL INPATH '/tmp/all_types.0.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.1.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.2.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.3.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.4.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.5.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.6.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.7.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.8.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.9.txt' INTO TABLE all_types;

LOAD DATA LOCAL INPATH '/tmp/all_types.0.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.1.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.2.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.3.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.4.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.5.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.6.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.7.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.8.txt' INTO TABLE all_types;
LOAD DATA LOCAL INPATH '/tmp/all_types.9.txt' INTO TABLE all_types;
