use all_types;

drop table if exists all_types_orc;
create table all_types_orc
stored as orc
as select * from all_types;
