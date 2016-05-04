use ${DB};

drop view revenue_cached;
drop view max_revenue_cached;

create view revenue_cached as
select
	l_suppkey as supplier_no,
	sum(cast(l_extendedprice as decimal(15, 2)) * (1 - cast(l_discount as decimal(15, 2)))) as total_revenue
from
	lineitem
where
	l_shipdate >= '1996-01-01'
	and l_shipdate < '1996-04-01'
group by l_suppkey;

create view max_revenue_cached as
select
	max(cast(total_revenue as decimal(15, 2))) as max_revenue
from
	revenue_cached;

select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue_cached,
	max_revenue_cached
where
	s_suppkey = supplier_no
	and total_revenue = max_revenue 
order by s_suppkey;
