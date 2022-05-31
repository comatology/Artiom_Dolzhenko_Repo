
SELECT  *
FROM ce_products
WHERE unit_cost<100;

CREATE INDEX idx_btree ON ce_products (unit_cost);
Update  bl_3nf.ce_products
set unit_cost=unit_cost+1;
commit;

-------------------------
CREATE INDEX idx_btree3 ON ce_sales (product_id);
CREATE INDEX idx_btree ON ce_product_brand (product_id);

SELECT s.sale_id, c.channel_description, p.product, b.product_brand, pt.product_type, p.unit_cost
FROM CE_SALES s
Left JOIN CE_products p
on s.product_id=p.product_id
Left  join ce_brands b
on p.product_brand_id=b.product_brand_id
Left  join ce_product_types pt
on p.product_type_id=pt.product_type_id
left join ce_channels c
on s.channel_id=c.channel_id
Where p.unit_cost<100;
select * from table(dbms_xplan.display)
-- system block
select prev_sql_id from v$session where sid=sys_context('userenv','sid');--dnpvjvxvfy7rj
select sql_id, sql_text from v$sqltext 
where sql_id in ('dnpvjvxvfy7rj');
SELECT * FROM V$SQL WHERE SQL_ID = 'dnpvjvxvfy7rj';


   
