use avro;

drop table business_licenses_avro;

create table business_licenses_avro
stored as avro
as select * from business_licenses;
