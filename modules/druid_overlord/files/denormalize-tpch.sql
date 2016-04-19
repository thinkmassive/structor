use tpch_bin_flat_orc_2;

INSERT OVERWRITE DIRECTORY '/user/vagrant/tpch-denormalized' 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' 
select
    cast(o_orderdate as date) + interval '10' year,
    o_orderstatus, o_orderpriority, p_name, p_brand, p_type, s_name,
    n_name, n_regionkey,
    l_quantity, l_extendedprice, l_discount, l_tax, l_orderkey, l_suppkey
from
    orders, part, supplier, nation, lineitem
where
    l_orderkey = o_orderkey
    and l_partkey = p_partkey
    and l_suppkey = s_suppkey
    and s_nationkey = n_nationkey
    and o_orderdate between '1996-01-01' and '1996-12-31';
