use avro;

drop table business_licenses_orc;
create table business_licenses_orc
stored as orc
as select * from business_licenses_avro;
