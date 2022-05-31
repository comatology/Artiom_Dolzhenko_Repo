EXPLAIN PLAN FOR
Select /*+ USE_NL(cs c) */ *
From ce_channel_classes cs
inner join ce_channels c 
on c.channel_class_id=cs.channel_class_id;
SELECT * FROM table (DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------------
EXPLAIN PLAN FOR
Select /*+ USE_MERGE(p pt)*/* 
From ce_products p
inner join ce_product_types pt
on p.product_type_id=pt.product_type_id
Where p.unit_cost>1000;
SELECT * FROM table (DBMS_XPLAN.DISPLAY);
--------------------------------------------------------------------------------
EXPLAIN PLAN FOR
Select /*+ USE_HASH(p pt)*/* 
From ce_sales s
inner join ce_products p
on p.product_id=s.product_id;
SELECT * FROM table (DBMS_XPLAN.DISPLAY);
--------------------------------------------------------------------------------
Select ce_channel_classes.channel_class, ce_channels.channel_description, ce_channels.channel_id from ce_channel_classes
EXPLAIN PLAN FOR
Select  /*+ ORDERED*/ *
From ce_channel_classes ,ce_channels  
where ce_channel_classes.channel_class_id=ce_channels.channel_class_id;
and  ce_channel_classes.channel_class='tDirect';
SELECT * FROM table (DBMS_XPLAN.DISPLAY);




EXPLAIN PLAN FOR
Select  ce_channel_classes.channel_class, ce_channels.channel_description, ce_channels.channel_id
From ce_channel_classes ,ce_channels;  
SELECT * FROM table (DBMS_XPLAN.DISPLAY);
--------------------------------------------------------------------------------
EXPLAIN PLAN FOR
Select *
From ce_products p
left outer join ce_product_types pt
on p.product_type_id=pt.product_type_id;
SELECT * FROM table (DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
Select *
From ce_products p, ce_product_types pt
Where p.product_type_id=pt.product_type_id(+);
SELECT * FROM table (DBMS_XPLAN.DISPLAY);
--------------------------------------------------------------------------------
EXPLAIN PLAN FOR
Select count(*) 
From ce_products p
full outer join ce_brands b
on p.product_brand_id=b.product_brand_id;
SELECT * FROM table (DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
Select count (*)
From (
    Select * 
    From ce_products p, ce_brands b
    Where p.product_brand_id=b.product_brand_id(+)
    union
Select * 
    From ce_products p, ce_brands b
    Where p.product_brand_id(+)=b.product_brand_id);
SELECT * FROM table (DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------------
MERGE INTO ce_products ch
    USING (SELECT DISTINCT
            c.product_id AS product_srcid, 
            'personnel_sales' AS product_source_system, 
            'src_products' AS product_source_entity, 
            COALESCE(c.product_name,'N/A') AS product,
            COALESCE(c.unit_price,'-1') AS unit_price,
            COALESCE(c.unit_cost,'-1') AS unit_cost,     
            COALESCE(c2.product_brand_id,-1) AS product_brand_id,
            COALESCE(c3.product_type_id,-1) AS product_type_id
            
    FROM  SA_SOURCE_SYSTEM_1.src_products c
    LEFT JOIN bl_3nf.ce_brands c2
    ON c.brand_id=c2.product_brand_srcid
    LEFT JOIN bl_3nf.ce_product_types c3
    on c.product_type_id=c3.product_type_srcid) t
         ON (ch.product_srcid = t.product_srcid
         AND ch.product_source_system = t.product_source_system
         AND ch.product_source_entity = t.product_source_entity)
    WHEN  MATCHED THEN
        Update set 
        product=product, unit_price=unit_price, unit_cost=unit_cost, product_brand_id=product_brand_id, product_type_id=product_type_id,ta_update_dt=SYSDATE
    WHEN NOT MATCHED THEN 
         INSERT(product_id, product_srcid, product_source_system, product_source_entity, product, unit_price, unit_cost, product_brand_id, product_type_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_product_id.NEXTVAL,t.product_srcid, t.product_source_system, t.product_source_entity, t.product, t.unit_price, t.unit_cost, t.product_brand_id, t.product_type_id,SYSDATE,SYSDATE);