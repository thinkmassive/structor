create database if not exists avro;
use avro;

drop table business_licenses;
create table business_licenses (
    field1 string, field2 string, field3 string, field4 string,
    field5 string, field6 string, field7 string, field8 string,
    id string,
    license_id int,
    account_number int,
    site_number int,
    legal_name string,
    business_name string,
    address string, city string, state string, zipcode string,
    ward int, precinct int, police_district int,
    license_code int,
    license_description string,
    license_number int,
    application_type string,
    payment_date string,
    start_date string, expire_date string,
    date_issued string,
    license_status string,
    status_change_date string,
    lat double, long double,
    location struct<field1:string, lat:double, long:double, field2:string, field3:string>
) stored as textfile;

LOAD DATA LOCAL INPATH '/vagrant/modules/benchmetrics/files/etl/license_csv_avro/data.csv' INTO TABLE business_licenses;
