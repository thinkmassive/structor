select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= to_date('1993-01-01')
	and l_shipdate < to_date('1994-01-01')
	and l_discount between 0.06 - 0.01 and 0.06 + 0.01
	and l_quantity < 25;
