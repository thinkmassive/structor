select
   count(distinct cs_order_number) as `order count`
  ,sum(cs_ext_ship_cost) as `total shipping cost`
  ,sum(cs_net_profit) as `total net profit`
from
   catalog_sales cs1
left semi join
  (select distinct(cs_order_number) as cs2_cs_order_number, cs_warehouse_sk as cs2_cs_warehouse_sk
      from catalog_sales) cs2
  on cs1.cs_order_number = cs2_cs_order_number
left join
  (select cr_order_number
     from catalog_returns cr1) cr1
  on cs1.cs_order_number = cr1.cr_order_number
join customer_address on cs1.cs_ship_addr_sk = ca_address_sk
join call_center on cs1.cs_call_center_sk = cc_call_center_sk
join date_dim on cs1.cs_ship_date_sk = d_date_sk
where
 cs2_cs_order_number is not null
and cr1.cr_order_number is null
and ca_state = 'OH'
and cc_county in ('Ziebach County','Williamson County','Walker County','Ziebach County', 'Ziebach County')
and cs_warehouse_sk <> cs2_cs_warehouse_sk
and d_date between '1999-5-01' and (cast('1999-5-01' as date) + interval '60' day)
order by `order count`
limit 100;
