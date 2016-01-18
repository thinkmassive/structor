DROP TABLE IF EXISTS timeseries_test;

CREATE TABLE timeseries_test (
   device integer not null,
   tick_time timestamp not null,
   rate integer,
   temperature float,
   load float,
   price float,
   tests_passed boolean,
   tags varchar array
   constraint timeseries_test_pk primary key(device, tick_time)
);
