select
        l_returnflag,
        l_linestatus,
        sum(l_quantity) as sum_qty,
        sum(l_extendedprice) as sum_base_price,
        sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
        sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
        avg(l_quantity) as avg_qty,
        avg(l_extendedprice) as avg_price,
        avg(l_discount) as avg_disc,
        count(*) as count_order
from
        lineitem
where
        l_shipdate <= to_date('1998-09-16')
group by
        l_returnflag,
        l_linestatus
order by
        l_returnflag,
        l_linestatus;
select
	c_custkey,
	c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal,
	n_name,
	c_address,
	c_phone,
	c_comment
from
	customer,
	orders,
	lineitem,
	nation
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= to_date('1993-07-01')
	and o_orderdate < to_date('1993-10-01')
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey,
	c_name,
	c_acctbal,
	c_phone,
	n_name,
	c_address,
	c_comment
order by
	revenue desc
limit 20;
select
        ps_partkey,
        sum(ps_supplycost * ps_availqty) as val
from
        partsupp,
        supplier,
        nation
where
        ps_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and n_name = 'GERMANY'
group by
        ps_partkey having
                sum(ps_supplycost * ps_availqty) > (
                        select
                                sum(ps_supplycost * ps_availqty) * 0.0001
                        from
                                partsupp,
                                supplier,
                                nation
                        where
                                ps_suppkey = s_suppkey
                                and s_nationkey = n_nationkey
	                        and n_name = 'GERMANY'
                )
order by
        val desc;
select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT'
			or o_orderpriority = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT'
			and o_orderpriority <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	orders,
	lineitem
where
	o_orderkey = l_orderkey
	and l_shipmode in ('REG AIR', 'MAIL')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= to_date('1995-01-01')
	and l_receiptdate < to_date('1996-01-01')
group by
	l_shipmode
order by
	l_shipmode;
select
	c_count,
	count(*) as custdist
from
	(
		select
			c_custkey,
			count(o_orderkey) as c_count
		from
			customer left outer join orders on
				c_custkey = o_custkey
				and o_comment not like '%unusual%accounts%'
		group by
			c_custkey
	) c_orders
group by
	c_count
order by
	custdist desc,
	c_count desc;
select
	100.00 * sum(case
		when p_type like 'PROMO%'
			then l_extendedprice * (1 - l_discount)
		else 0
	end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
	lineitem,
	part
where
	l_partkey = p_partkey
	and l_shipdate >= to_date('1995-08-01')
	and l_shipdate < to_date('1995-09-01');
drop table if exists revenue_cached;
create table revenue_cached(l_suppkey integer primary key, total_revenue DECIMAL(15,2));
upsert into revenue_cached
select
	l_suppkey as supplier_no,
	sum(l_extendedprice * (1 - l_discount)) as total_revenue
from
	lineitem
where
	l_shipdate >= to_date('1996-01-01')
	and l_shipdate < to_date('1996-04-01')
group by l_suppkey;

select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue_cached
where
	s_suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue_cached
	)
order by
	s_suppkey;
select
	p_brand,
	p_type,
	p_size,
	count(distinct ps_suppkey) as supplier_cnt
from
	partsupp,
	part
where
	p_partkey = ps_partkey
	and p_brand <> 'Brand#34'
	and p_type not like 'ECONOMY BRUSHED%'
	and p_size in (22, 14, 27, 49, 21, 33, 35, 28)
	and partsupp.ps_suppkey not in (
		select
			s_suppkey
		from
			supplier
		where
			s_comment like '%Customer%Complaints%'
	)
group by
	p_brand,
	p_type,
	p_size
order by
	supplier_cnt desc,
	p_brand,
	p_type,
	p_size;
select
        sum(l_extendedprice) / 7.0 as avg_yearly
from
        lineitem,
        part
where
        p_partkey = l_partkey
        and p_brand = 'Brand#23'
        and p_container = 'MED BOX'
        and l_quantity < (
                select
                        0.2 * avg(l_quantity)
                from
                        lineitem
                where
                        l_partkey = p_partkey
        );
select
        c_name,
        c_custkey,
        o_orderkey,
        o_orderdate,
        o_totalprice,
        sum(l_quantity)
from
        customer,
        orders,
        lineitem
where
        o_orderkey in (
                select
                        l_orderkey
                from
                        lineitem
                group by
                        l_orderkey having
                                sum(l_quantity) > 300
        )
        and c_custkey = o_custkey
        and o_orderkey = l_orderkey
group by
        c_name,
        c_custkey,
        o_orderkey,
        o_orderdate,
        o_totalprice
order by
        o_totalprice desc,
        o_orderdate
limit 100;

select
	sum(l_extendedprice* (1 - l_discount)) as revenue
from
	lineitem,
	part
where
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#32'
		and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
		and l_quantity >= 7 and l_quantity <= 7 + 10
		and p_size between 1 and 5
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	)
	or
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#35'
		and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
		and l_quantity >= 15 and l_quantity <= 15 + 10
		and p_size between 1 and 10
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	)
	or
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#24'
		and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
		and l_quantity >= 26 and l_quantity <= 26 + 10
		and p_size between 1 and 15
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	);
select
        s_acctbal,
        s_name,
        n_name,
        p_partkey,
        p_mfgr,
        s_address,
        s_phone,
        s_comment
from
        part,
        supplier,
        partsupp,
        nation,
        region
where
        p_partkey = ps_partkey
        and s_suppkey = ps_suppkey
        and p_size = 37
        and p_type like '%COPPER'
        and s_nationkey = n_nationkey
        and n_regionkey = r_regionkey
        and r_name = 'EUROPE'
        and ps_supplycost = (
                select
                        min(ps_supplycost)
                from
                        partsupp,
                        supplier,
                        nation,
                        region
                where
                        p_partkey = ps_partkey
                        and s_suppkey = ps_suppkey
                        and s_nationkey = n_nationkey
                        and n_regionkey = r_regionkey
                        and r_name = 'EUROPE'
        )
order by
        s_acctbal desc,
        n_name,
        s_name,
        p_partkey
limit 100;
select
        s_name,
        s_address
from
        supplier,
        nation
where
        s_suppkey in (
                select
                        ps_suppkey
                from
                        partsupp
                where
                        ps_partkey in (
                                select
                                        p_partkey
                                from
                                        part
                                where
                                        p_name like 'forest%'
                        )
                        and ps_availqty > (
                                select
                                        0.5 * sum(l_quantity)
                                from
                                        lineitem
                                where
                                        l_partkey = ps_partkey
                                        and l_suppkey = ps_suppkey
                                        and l_shipdate >= to_date('1994-01-01')
                                        and l_shipdate < to_date('1995-01-01')
                        )
        )
        and s_nationkey = n_nationkey
        and n_name = 'CANADA'
order by
        s_name;
drop table if exists q21_tmp1_cached;
create table q21_tmp1_cached(l_orderkey integer not null primary key, count_suppkey integer, max_suppkey integer);
upsert into q21_tmp1_cached
select
        l_orderkey,
        count(distinct l_suppkey) as count_suppkey,
        max(l_suppkey) as max_suppkey
from
        lineitem
where
        l_orderkey is not null
group by
        l_orderkey;

drop table if exists q21_tmp2_cached;
create table q21_tmp2_cached(l_orderkey integer not null primary key, count_suppkey integer, max_suppkey integer);
upsert into q21_tmp2_cached
select
        l_orderkey,
        count(distinct l_suppkey) count_suppkey,
        max(l_suppkey) as max_suppkey
from
        lineitem
where
        l_receiptdate > l_commitdate
        and l_orderkey is not null
group by
        l_orderkey;

explain select s_name, count(1) as numwait
from (
        select s_name from (
                select
                        s_name, l_suppkey, count_suppkey, max_suppkey
                from
                        q21_tmp2_cached t2 right outer join (
                        select
                                s_name, a.l_orderkey,
                                l_suppkey from (
                                select
                                        s_name, t1.l_orderkey, l_suppkey, count_suppkey, max_suppkey
                                from
                                        q21_tmp1_cached t1 join (
                                                select
                                                        s_name, l_orderkey, l_suppkey
                                                from
                                                        orders o join (
                                                        select
                                                                s_name, l_orderkey, l_suppkey
                                                        from
                                                                nation n join supplier s
                                                        on
                                                                s.s_nationkey = n.n_nationkey
                                                                join lineitem l
                                                        on
                                                                s.s_suppkey = l.l_suppkey
                                                        where
                                                                n.n_name = 'SAUDI ARABIA'
                                                                and l.l_receiptdate > l.l_commitdate
                                                                and l.l_orderkey is not null
                                                ) l1 on o.o_orderkey = l1.l_orderkey
                                                where
                                                        o.o_orderstatus = 'F'
                                        ) l2 on l2.l_orderkey = t1.l_orderkey
                                ) a
                        where
                                (count_suppkey > 1)
                                or ((count_suppkey=1)
                                and (l_suppkey <> max_suppkey))
                ) l3 on l3.l_orderkey = t2.l_orderkey
        ) b
        where
                (count_suppkey is null)
                or ((count_suppkey=1)
                and (l_suppkey = max_suppkey))
) c
group by
        s_name
order by
        numwait desc, s_name
limit 100;
select
        cntrycode,
        count(*) as numcust,
        sum(c_acctbal) as totacctbal
from
        (
                select
                        substr(c_phone, 1, 2) as cntrycode,
                        c_acctbal
                from
                        customer
                where
                        substr(c_phone, 1, 2) in ('13', '31', '23', '29', '30', '18', '17')
                        and c_acctbal > (
                                select
                                        avg(c_acctbal)
                                from
                                        customer
                                where
                                        c_acctbal > 0.00
                                        and substr(c_phone, 1, 2) in ('13', '31', '23', '29', '30', '18', '17')
                        )
                        and not exists (
                                select
                                        *
                                from
                                        orders
                                where
                                        o_custkey = c_custkey
                        )
        ) as custsale
group by
        cntrycode
order by
        cntrycode;
select
	l_orderkey,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	o_orderdate,
	o_shippriority
from
	customer,
	orders,
	lineitem
where
	c_mktsegment = 'BUILDING'
	and c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate < to_date('1995-03-22')
	and l_shipdate > to_date('1995-03-22')
group by
	l_orderkey,
	o_orderdate,
	o_shippriority
order by
	revenue desc,
	o_orderdate
limit 10;
select
	o_orderpriority,
	count(*) as order_count
from
	orders as o
where
	o_orderdate >= to_date('1996-05-01')
	and o_orderdate < to_date('1996-08-01')
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o.o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;
select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	customer,
	orders,
	lineitem,
	supplier,
	nation,
	region
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and l_suppkey = s_suppkey
	and c_nationkey = s_nationkey
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'AFRICA'
	and o_orderdate >= to_date('1993-01-01')
	and o_orderdate < to_date('1994-01-01')
group by
	n_name
order by
	revenue desc;
select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= to_date('1993-01-01')
	and l_shipdate < to_date('1994-01-01')
	and l_discount between 0.06 - 0.01 and 0.06 + 0.01
	and l_quantity < 25;
select
        supp_nation,
        cust_nation,
        l_year,
        sum(volume) as revenue
from
        (
                select
                        n1.n_name as supp_nation,
                        n2.n_name as cust_nation,
                        year(l_shipdate) as l_year,
                        l_extendedprice * (1 - l_discount) as volume
                from
                        supplier,
                        lineitem,
                        orders,
                        customer,
                        nation n1,
                        nation n2
                where
                        s_suppkey = l_suppkey
                        and o_orderkey = l_orderkey
                        and c_custkey = o_custkey
                        and s_nationkey = n1.n_nationkey
                        and c_nationkey = n2.n_nationkey
                        and (
                                (n1.n_name = 'KENYA' and n2.n_name = 'PERU')
                                or (n1.n_name = 'PERU' and n2.n_name = 'KENYA')
                        )
                        and l_shipdate between to_date('1995-01-01') and to_date('1996-12-31')
        ) as shipping
group by
        supp_nation,
        cust_nation,
        l_year
order by
        supp_nation,
        cust_nation,
        l_year;
select
        o_year,
        sum(case
                when nation = 'PERU' then volume
                else 0
        end) / sum(volume) as mkt_share
from
        (
                select
                        year(o_orderdate) as o_year,
                        l_extendedprice * (1 - l_discount) as volume,
                        n2.n_name as nation
                from
                        part,
                        supplier,
                        lineitem,
                        orders,
                        customer,
                        nation n1,
                        nation n2,
                        region
                where
                        p_partkey = l_partkey
                        and s_suppkey = l_suppkey
                        and l_orderkey = o_orderkey
                        and o_custkey = c_custkey
                        and c_nationkey = n1.n_nationkey
                        and n1.n_regionkey = r_regionkey
                        and r_name = 'AMERICA'
                        and s_nationkey = n2.n_nationkey
                        and o_orderdate between to_date('1995-01-01') and to_date('1996-12-31')
                        and p_type = 'ECONOMY BURNISHED NICKEL'
        ) as all_nations
group by
        o_year
order by
        o_year;
select
        nation,
        o_year,
        sum(amount) as sum_profit
from
        (
                select
                        n_name as nation,
                        year(o_orderdate) as o_year,
                        l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
                from
                        part,
                        supplier,
                        lineitem,
                        partsupp,
                        orders,
                        nation
                where
                        s_suppkey = l_suppkey
                        and ps_suppkey = l_suppkey
                        and ps_partkey = l_partkey
                        and p_partkey = l_partkey
                        and o_orderkey = l_orderkey
                        and s_nationkey = n_nationkey
                        and p_name like '%plum%'
        ) as profit
group by
        nation,
        o_year
order by
        nation,
        o_year desc;
