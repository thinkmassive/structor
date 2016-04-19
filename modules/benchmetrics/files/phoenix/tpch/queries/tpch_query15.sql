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
