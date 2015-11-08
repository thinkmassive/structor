drop table if exists acid_test;
CREATE TABLE acid_test (
	bucket_key int,
	expected_total int,
	id int,
	id_text string,
	id_double double,
	id_float float,
	id_decimal decimal(10, 4),
	null_field string,
	id_string string,
	id_varchar varchar(5),
	id_char char(5),
	runid int,
	generationid int
)
PARTITIONED BY (day_partition STRING)
CLUSTERED BY (bucket_key) INTO 3 BUCKETS
STORED AS ORC TBLPROPERTIES ("orc.compress"="NONE","transactional"="true");
