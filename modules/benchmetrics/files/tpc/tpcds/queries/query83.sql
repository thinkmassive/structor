use ${DB};

-- Note: Waiting on ticket 1782.

drop table if exists query83_temp;
create temporary table query83_temp as
select d_date
        from date_dim
        where d_week_seq in
                (select d_week_seq
                from date_dim d2
          where d2.d_date in ('1998-01-02','1998-10-15','1998-11-10'));

with sr_items as
 (select i_item_id item_id,
        sum(sr_return_quantity) sr_item_qty
 from store_returns,
      item,
      query83_temp
 where sr_item_sk = i_item_sk
 and   sr_returned_date_sk  = query83_temp.d_date
 group by i_item_id),
 cr_items as
 (select i_item_id item_id,
        sum(cr_return_quantity) cr_item_qty
 from catalog_returns,
      item,
      query83_temp
 where cr_item_sk = i_item_sk
 and   cr_returned_date_sk   = query83_temp.d_date
 group by i_item_id),
 wr_items as
 (select i_item_id item_id,
        sum(wr_return_quantity) wr_item_qty
 from web_returns,
      item,
      query83_temp
 where wr_item_sk = i_item_sk
 and   wr_returned_date_sk   = query83_temp.d_date
 group by i_item_id)
  select  sr_items.item_id
       ,sr_item_qty
       ,sr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 sr_dev
       ,cr_item_qty
       ,cr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 cr_dev
       ,wr_item_qty
       ,wr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 wr_dev
       ,(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 average
 from sr_items
     ,cr_items
     ,wr_items
 where sr_items.item_id=cr_items.item_id
   and sr_items.item_id=wr_items.item_id 
 order by sr_items.item_id
         ,sr_item_qty
 limit 100;

