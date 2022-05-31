MERGE INTO ce_channel_classes  ch
    USING (SELECT DISTINCT
            channel_class_id AS channel_class_srcid, 
            'personnel_sales' AS channel_class_source_system, 
            'src_channels' AS channel_class_source_entity, 
             COALESCE(channel_class,'N/A')AS channel_class
    FROM  SA_SOURCE_SYSTEM_1.src_channels   
    ) t
         ON (ch.channel_class_srcid = t.channel_class_srcid
         AND ch.channel_class_source_system = t.channel_class_source_system
         AND ch.channel_class_source_entity = t.channel_class_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT( channel_class_id,channel_class_srcid, channel_class_source_system, channel_class_source_entity, channel_class, ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_channel_class_id.NEXTVAL,t.channel_class_srcid, t.channel_class_source_system, t.channel_class_source_entity, t.channel_class, SYSDATE,SYSDATE);

MERGE INTO ce_channel_classes  ch
    USING (SELECT DISTINCT
            -1 AS channel_class_id,
            -1 AS channel_class_srcid, 
            'personnel_sales' AS channel_class_source_system, 
            'src_channels' AS channel_class_source_entity, 
             'N/A' AS channel_class
    FROM  DUAL  
    ) t
         ON (ch.channel_class_srcid = t.channel_class_srcid
         AND ch.channel_class_source_system = t.channel_class_source_system
         AND ch.channel_class_source_entity = t.channel_class_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT( channel_class_id,channel_class_srcid, channel_class_source_system, channel_class_source_entity, channel_class, ta_update_dt, ta_insert_dt)
        VALUES(t.channel_class_id,t.channel_class_srcid, t.channel_class_source_system, t.channel_class_source_entity, t.channel_class, SYSDATE,SYSDATE);
SELECT * FROM ce_channel_classes;
commit;
-----------------------------------------------------------------
 MERGE INTO ce_channels ch
    USING ((SELECT DISTINCT
            c.channel_id AS channel_srcid, 
            'personnel_sales' AS channel_source_system, 
            'src_channels' AS channel_source_entity, 
            COALESCE(c.channel_desc,'N/A') as channel_description,
            COALESCE(c2.channel_class_id, -1) as channel_class_id
    FROM  SA_SOURCE_SYSTEM_1.src_channels c
    LEFT JOIN bl_3nf.ce_channel_classes c2
    on c.channel_class_id=c2.channel_class_srcid 
)
    UNION
    (SELECT DISTINCT
            c.channel_id AS channel_srcid, 
            'company_sales' AS channel_source_system, 
            'src_channels' AS channel_source_entity, 
            COALESCE(c.channel_desc,'N/A') as channel_description,
            COALESCE(c2.channel_class_id, -1) as channel_class_id
    FROM  SA_SOURCE_SYSTEM_2.src_channels c
    LEFT JOIN bl_3nf.ce_channel_classes c2
    on c.channel_class_id=c2.channel_class_srcid
)) t
         ON (ch.channel_srcid = t.channel_srcid
         AND ch.channel_source_system = t.channel_source_system
         AND ch.channel_source_entity = t.channel_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(channel_id, channel_srcid, channel_source_system, channel_source_entity, channel_description, channel_class_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_channel_id.NEXTVAL,t.channel_srcid, t.channel_source_system, t.channel_source_entity, t.channel_description, t.channel_class_id,SYSDATE,SYSDATE);
MERGE INTO ce_channels ch
    USING (SELECT DISTINCT
            -1 as channel_id,
            -1 AS channel_srcid, 
            'personnel_sales' AS channel_source_system, 
            'src_channels' AS channel_source_entity, 
            'N/A' as channel_description,
             -1 as channel_class_id
    FROM  DUAL
) t
         ON (ch.channel_srcid = t.channel_srcid
         AND ch.channel_source_system = t.channel_source_system
         AND ch.channel_source_entity = t.channel_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(channel_id, channel_srcid, channel_source_system, channel_source_entity, channel_description, channel_class_id,ta_update_dt, ta_insert_dt)
        VALUES(t.channel_id,t.channel_srcid, t.channel_source_system, t.channel_source_entity, t.channel_description, t.channel_class_id,SYSDATE,SYSDATE);
SELECT * FROM ce_channels;
commit;

-----------------------------------------------------

MERGE INTO ce_promotion_categories  ch
    USING (SELECT DISTINCT
            promo_category_id AS promotion_category_srcid, 
            'personnel_sales' AS promotion_category_source_system, 
            'src_promotions' AS promotion_category_source_entity, 
            COALESCE(promo_category,'N/A') as promotion_category
    FROM  SA_SOURCE_SYSTEM_1.src_promotions) t
         ON (ch.promotion_category_srcid = t.promotion_category_srcid
         AND ch.promotion_category_source_system = t.promotion_category_source_system
         AND ch.promotion_category_source_entity = t.promotion_category_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(promotion_category_id,promotion_category_srcid, promotion_category_source_system, promotion_category_source_entity, promotion_category,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_promotion_category_id.NEXTVAL,t.promotion_category_srcid, t.promotion_category_source_system, t.promotion_category_source_entity, t.promotion_category,SYSDATE,SYSDATE);
MERGE INTO ce_promotion_categories  ch
    USING (SELECT DISTINCT
            -1 as promotion_category_id,
            -1 AS promotion_category_srcid, 
            'personnel_sales' AS promotion_category_source_system, 
            'src_promotions' AS promotion_category_source_entity, 
            'N/A' as promotion_category
    FROM  DUAL) t
         ON (ch.promotion_category_srcid = t.promotion_category_srcid
         AND ch.promotion_category_source_system = t.promotion_category_source_system
         AND ch.promotion_category_source_entity = t.promotion_category_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(promotion_category_id,promotion_category_srcid, promotion_category_source_system, promotion_category_source_entity, promotion_category,ta_update_dt, ta_insert_dt)
        VALUES(t.promotion_category_id,t.promotion_category_srcid, t.promotion_category_source_system, t.promotion_category_source_entity, t.promotion_category,SYSDATE,SYSDATE);
SELECT * FROM ce_promotion_categories;
commit;
-----------------------------------------------------
 MERGE INTO ce_promotions_scd ch
    USING (SELECT DISTINCT
            c.promo_id AS promotion_srcid, 
            'personnel_sales' AS promotion_source_system, 
            'src_promotions' AS promotion_source_entity, 
            COALESCE(c.promo_name,'N/A') AS promotion_name,
            COALESCE(c2.promotion_category_id,-1)   AS promotion_category_id,
            COALESCE(TO_DATE(SUBSTR(c.promo_begin_date,1,10) ,'yyyy-mm-dd'),TO_DATE('9999-12-31' ,'yyyy-mm-dd'))  AS begin_sop_dt,
            COALESCE(TO_DATE(SUBSTR(c.promo_end_date,1,10) ,'yyyy-mm-dd'),TO_DATE('9999-12-31' ,'yyyy-mm-dd'))   AS end_eop_dt,
            COALESCE(c.promo_cost,'-1') AS cost            
    FROM  SA_SOURCE_SYSTEM_1.src_promotions c
    LEFT JOIN bl_3nf.ce_promotion_categories c2
    ON c.promo_category_id=c2.promotion_category_srcid) t
         ON (ch.promotion_srcid = t.promotion_srcid
         AND ch.promotion_source_system = t.promotion_source_system
         AND ch.promotion_source_entity = t.promotion_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(promotion_id, promotion_srcid, promotion_source_system, promotion_source_entity, promotion_name, promotion_category_id, begin_sop_dt, end_eop_dt,is_active, cost,ta_update_dt, ta_insert_dt)
        VALUES( seq_ce_promotion_id.NEXTVAL,t.promotion_srcid, t.promotion_source_system, t.promotion_source_entity, t.promotion_name, t.promotion_category_id, t.begin_sop_dt, t.end_eop_dt,'inactive', t.cost,SYSDATE,SYSDATE);
MERGE INTO ce_promotions_scd ch
    USING (SELECT DISTINCT
            -1 as promotion_id,
            -1 AS promotion_srcid, 
            'personnel_sales' AS promotion_source_system, 
            'src_promotions' AS promotion_source_entity, 
            'N/A' AS promotion_name,
            -1   AS promotion_category_id,
            TO_DATE('9999-12-31' ,'yyyy-mm-dd')  AS begin_sop_dt,
            TO_DATE('9999-12-31' ,'yyyy-mm-dd')   AS end_eop_dt,
            '-1' AS cost            
    FROM  DUAL) t
         ON (ch.promotion_srcid = t.promotion_srcid
         AND ch.promotion_source_system = t.promotion_source_system
         AND ch.promotion_source_entity = t.promotion_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(promotion_id, promotion_srcid, promotion_source_system, promotion_source_entity, promotion_name, promotion_category_id, begin_sop_dt, end_eop_dt,is_active, cost,ta_update_dt, ta_insert_dt)
        VALUES(t.promotion_id,t.promotion_srcid, t.promotion_source_system, t.promotion_source_entity, t.promotion_name, t.promotion_category_id, t.begin_sop_dt, t.end_eop_dt,'inactive', t.cost,SYSDATE,SYSDATE);


SELECT * FROM  ce_promotions_scd;
commit;

----------------------------------------------

MERGE INTO ce_brands  ch
    USING (SELECT DISTINCT
            brand_id AS product_brand_srcid, 
            'personnel_sales' AS product_brand_source_system, 
            'src_products' AS product_brand_source_entity, 
            COALESCE(brand,'N/A') as product_brand
    FROM  SA_SOURCE_SYSTEM_1.src_products ) t
         ON (ch.product_brand_srcid = t.product_brand_srcid
         AND ch.product_brand_source_system = t.product_brand_source_system
         AND ch.product_brand_source_entity = t.product_brand_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(product_brand_id,product_brand_srcid, product_brand_source_system, product_brand_source_entity, product_brand,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_brand_id.NEXTVAL,t.product_brand_srcid, t.product_brand_source_system, t.product_brand_source_entity, t.product_brand,SYSDATE,SYSDATE);   
        
MERGE INTO ce_brands  ch
    USING (SELECT DISTINCT
            -1 as brand_id,
            -1 AS product_brand_srcid, 
            'personnel_sales' AS product_brand_source_system, 
            'src_products' AS product_brand_source_entity, 
            'N/A' as product_brand
    FROM  dual ) t
         ON (ch.product_brand_srcid = t.product_brand_srcid
         AND ch.product_brand_source_system = t.product_brand_source_system
         AND ch.product_brand_source_entity = t.product_brand_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(product_brand_id,product_brand_srcid, product_brand_source_system, product_brand_source_entity, product_brand,ta_update_dt, ta_insert_dt)
        VALUES(t.brand_id,t.product_brand_srcid, t.product_brand_source_system, t.product_brand_source_entity, t.product_brand,SYSDATE,SYSDATE);  
SELECT * FROM  ce_brands;
commit;

MERGE INTO ce_product_types  ch
    USING (SELECT DISTINCT
            product_type_id AS product_type_srcid, 
            'personnel_sales' AS product_type_source_system, 
            'src_products' AS product_type_source_entity, 
           COALESCE(product_type, 'N/A') as  product_type
    FROM  SA_SOURCE_SYSTEM_1.src_products) t
         ON (ch.product_type_srcid = t.product_type_srcid
         AND ch.product_type_source_system = t.product_type_source_system
         AND ch.product_type_source_entity = t.product_type_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(product_type_id,product_type_srcid, product_type_source_system, product_type_source_entity, product_type,ta_update_dt, ta_insert_dt)
        VALUES(SEQ_CE_PRODUCT_TYPE_ID.nextval,t.product_type_srcid, t.product_type_source_system, t.product_type_source_entity, t.product_type,SYSDATE,SYSDATE); 
MERGE INTO ce_product_types  ch
    USING (SELECT DISTINCT
            -1 as product_type_id,
            -1 AS product_type_srcid, 
            'personnel_sales' AS product_type_source_system, 
            'src_products' AS product_type_source_entity, 
            'N/A' as  product_type
    FROM  DUAL) t
         ON (ch.product_type_srcid = t.product_type_srcid
         AND ch.product_type_source_system = t.product_type_source_system
         AND ch.product_type_source_entity = t.product_type_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(product_type_id,product_type_srcid, product_type_source_system, product_type_source_entity, product_type,ta_update_dt, ta_insert_dt)
        VALUES(t.product_type_id,t.product_type_srcid, t.product_type_source_system, t.product_type_source_entity, t.product_type,SYSDATE,SYSDATE); 

SELECT * FROM ce_product_types;
commit;




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
    WHEN NOT MATCHED THEN 
         INSERT(product_id, product_srcid, product_source_system, product_source_entity, product, unit_price, unit_cost, product_brand_id, product_type_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_product_id.NEXTVAL,t.product_srcid, t.product_source_system, t.product_source_entity, t.product, t.unit_price, t.unit_cost, t.product_brand_id, t.product_type_id,SYSDATE,SYSDATE);
   
MERGE INTO ce_products ch
    USING (SELECT DISTINCT
            -1 as product_id,
            -1 AS product_srcid, 
            'personnel_sales' AS product_source_system, 
            'src_products' AS product_source_entity, 
            'N/A' AS product,
            '-1' AS unit_price,
            '-1' AS unit_cost,     
            -1 AS product_brand_id,
            -1 AS product_type_id
            
    FROM  DUAL) t
         ON (ch.product_srcid = t.product_srcid
         AND ch.product_source_system = t.product_source_system
         AND ch.product_source_entity = t.product_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(product_id, product_srcid, product_source_system, product_source_entity, product, unit_price, unit_cost, product_brand_id, product_type_id,ta_update_dt, ta_insert_dt)
        VALUES(t.product_id,t.product_srcid, t.product_source_system, t.product_source_entity, t.product, t.unit_price, t.unit_cost, t.product_brand_id, t.product_type_id,SYSDATE,SYSDATE);
             
SELECT * FROM ce_products;
commit;



MERGE INTO ce_countries  ch
    USING (SELECT DISTINCT
            country_id AS country_srcid, 
            'personnel_sales' AS country_source_system, 
            'src_countries' AS country_source_entity, 
           COALESCE(country_name,'N/A') as country
    FROM  SA_SOURCE_SYSTEM_1.src_countires) t
         ON (ch.country_srcid = t.country_srcid
         AND ch.country_source_system = t.country_source_system
         AND ch.country_source_entity = t.country_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(country_id,country_srcid, country_source_system, country_source_entity, country,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_country_id.NEXTVAL,t.country_srcid, t.country_source_system, t.country_source_entity, t.country,SYSDATE,SYSDATE); 
MERGE INTO ce_countries  ch
    USING (SELECT DISTINCT
            -1 as country_id,
            -1 AS country_srcid, 
            'personnel_sales' AS country_source_system, 
            'src_countries' AS country_source_entity, 
            'N/A' as country
    FROM  DUAL) t
         ON (ch.country_srcid = t.country_srcid
         AND ch.country_source_system = t.country_source_system
         AND ch.country_source_entity = t.country_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(country_id,country_srcid, country_source_system, country_source_entity, country,ta_update_dt, ta_insert_dt)
        VALUES(t.country_id,t.country_srcid, t.country_source_system, t.country_source_entity, t.country,SYSDATE,SYSDATE); 
        
        
SELECT * FROM ce_countries;
commit;




MERGE INTO ce_states ch
    USING (SELECT DISTINCT
            c.store_state_id AS state_srcid, 
            'personnel_sales' AS state_source_system, 
            'src_stores' AS state_source_entity, 
            COALESCE(c.store_state,'N/A') as state_name,
            COALESCE(c3.country_id, -1) as country_id
    FROM  SA_SOURCE_SYSTEM_1.src_stores c
    LEFT JOIN bl_3nf.ce_countries c3
    ON c.store_country=c3.country
    Where c3.country_source_system='personnel_sales') t
         ON (ch.state_srcid = t.state_srcid
         AND ch.state_source_system = t.state_source_system
         AND ch.state_source_entity = t.state_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(state_id, state_srcid, state_source_system, state_source_entity,state_name, country_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_state_id.NEXTVAL,t.state_srcid, t.state_source_system, t.state_source_entity, t.state_name, t.country_id,SYSDATE,SYSDATE); 
        
MERGE INTO ce_states ch
    USING (SELECT DISTINCT
            -1 as state_id,
            -1 AS state_srcid, 
            'personnel_sales' AS state_source_system, 
            'src_stores' AS state_source_entity, 
            'N/A' as state_name,
            -1 as country_id
    FROM  DUAL) t
         ON (ch.state_srcid = t.state_srcid
         AND ch.state_source_system = t.state_source_system
         AND ch.state_source_entity = t.state_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(state_id, state_srcid, state_source_system, state_source_entity,state_name, country_id,ta_update_dt, ta_insert_dt)
        VALUES(t.state_id,t.state_srcid, t.state_source_system, t.state_source_entity, t.state_name, t.country_id,SYSDATE,SYSDATE); 
 SELECT * FROM ce_states;
commit;       


MERGE INTO ce_cities ch
    USING (SELECT DISTINCT
            c.store_city_id AS city_srcid, 
            'personnel_sales' AS city_source_system, 
            'src_stores' AS city_source_entity, 
            COALESCE(c.store_city,'N/A') as city,
            COALESCE(c3.state_id,-1) as  state_id
    FROM  SA_SOURCE_SYSTEM_1.src_stores c
    LEFT JOIN bl_3nf.ce_states c3
    ON c.store_state_id=c3.state_srcid
    Where c3.state_source_system='personnel_sales') t
         ON (ch.city_srcid = t.city_srcid
         AND ch.city_source_system = t.city_source_system
         AND ch.city_source_entity = t.city_source_entity
         )
    WHEN NOT MATCHED THEN 
         INSERT(city_id,city_srcid, city_source_system, city_source_entity,city, state_id,ta_update_dt, ta_insert_dt)
        VALUES(SEQ_CE_CITY_ID.nextval,t.city_srcid, t.city_source_system, t.city_source_entity,t.city, t.state_id,SYSDATE,SYSDATE);
        
MERGE INTO ce_cities ch
    USING (SELECT DISTINCT
            -1 as city_id,
            -1 AS city_srcid, 
            'personnel_sales' AS city_source_system, 
            'src_stores' AS city_source_entity, 
            'N/A' as city,
            -1 as  state_id
    FROM  DUAL) t
         ON (ch.city_srcid = t.city_srcid
         AND ch.city_source_system = t.city_source_system
         AND ch.city_source_entity = t.city_source_entity
         )
    WHEN NOT MATCHED THEN 
         INSERT(city_id,city_srcid, city_source_system, city_source_entity,city, state_id,ta_update_dt, ta_insert_dt)
        VALUES(t.city_id,t.city_srcid, t.city_source_system, t.city_source_entity,t.city, t.state_id,SYSDATE,SYSDATE);
 SELECT * FROM ce_cities;
commit;



MERGE INTO ce_addresses ch
    USING (SELECT DISTINCT
            c.store_street_address_id AS address_srcid, 
            'personnel_sales' AS address_source_system, 
            'src_stores' AS address_source_entity, 
            COALESCE(c.store_street_address,'-1') as street_address,
            COALESCE(c.store_postal_code,'-1') as postal_code,
            COALESCE(c3.city_id,-1) as  city_id
    FROM  SA_SOURCE_SYSTEM_1.src_stores c
    LEFT JOIN bl_3nf.ce_cities c3
    ON c.store_city_id=c3.city_srcid) t
         ON (ch.address_srcid = t.address_srcid
         AND ch.address_source_system = t.address_source_system
         AND ch.address_source_entity = t.address_source_entity
         )
    WHEN NOT MATCHED THEN 
         INSERT(address_id,address_srcid, address_source_system, address_source_entity,street_address,postal_code,city_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_address_id.NEXTVAL,t.address_srcid, t.address_source_system, t.address_source_entity,t.street_address,t.postal_code,t.city_id,SYSDATE,SYSDATE);
        
MERGE INTO ce_addresses ch
    USING (SELECT DISTINCT
            -1 as address_id,
            -1 AS address_srcid, 
            'personnel_sales' AS address_source_system, 
            'src_stores' AS address_source_entity, 
            '-1' as street_address,
            '-1' as postal_code,
            -1 as  city_id
    FROM DUAL) t
         ON (ch.address_srcid = t.address_srcid
         AND ch.address_source_system = t.address_source_system
         AND ch.address_source_entity = t.address_source_entity
         )
    WHEN NOT MATCHED THEN 
         INSERT(address_id,address_srcid, address_source_system, address_source_entity,street_address,postal_code,city_id,ta_update_dt, ta_insert_dt)
        VALUES(t.address_id,t.address_srcid, t.address_source_system, t.address_source_entity,t.street_address,t.postal_code,t.city_id,SYSDATE,SYSDATE);
 SELECT * FROM ce_addresses;
commit;

MERGE INTO ce_stores ch
    USING (SELECT DISTINCT
            c.store_id AS store_srcid, 
            'personnel_sales' AS store_source_system, 
            'src_stores' AS store_source_entity, 
            COALESCE(c.store_phone, 'N/A') as phone,
            COALESCE(c3.address_id,-1) as  address_id
    FROM  SA_SOURCE_SYSTEM_1.src_stores c
    LEFT JOIN bl_3nf.ce_addresses c3
    ON c.store_id=c3.address_srcid
    Where c3.address_source_system='personnel_sales') t
         ON (ch.store_srcid = t.store_srcid
         AND ch.store_source_system = t.store_source_system
         AND ch.store_source_entity = t.store_source_entity
         )
    WHEN NOT MATCHED THEN 
         INSERT(store_id,store_srcid, store_source_system, store_source_entity,phone,address_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_store_id.NEXTVAL,t.store_srcid, t.store_source_system, t.store_source_entity,t.phone,t.address_id,SYSDATE,SYSDATE);
        
MERGE INTO ce_stores ch
    USING (SELECT DISTINCT
            -1 as store_id,
           -1 AS store_srcid, 
            'personnel_sales' AS store_source_system, 
            'src_stores' AS store_source_entity, 
            'N/A' as phone,
            -1 as  address_id
    FROM DUAL) t
         ON (ch.store_srcid = t.store_srcid
         AND ch.store_source_system = t.store_source_system
         AND ch.store_source_entity = t.store_source_entity
         )
    WHEN NOT MATCHED THEN 
         INSERT(store_id,store_srcid, store_source_system, store_source_entity,phone,address_id,ta_update_dt, ta_insert_dt)
        VALUES(t.store_id,t.store_srcid, t.store_source_system, t.store_source_entity,t.phone,t.address_id,SYSDATE,SYSDATE);
        
 SELECT * FROM ce_stores;
commit;





MERGE INTO ce_customers ch
    USING ((SELECT DISTINCT
            c.customer_id AS customer_srcid, 
            'personnel_sales' AS customer_source_system, 
            'src_employees' AS customer_source_entity, 
            COALESCE(c.customer_first_name,'N/A') as first_name,
            COALESCE(c.customer_last_name,'N/A') as last_name,
            'N/A' as company_name,
            'N/A' as company_number,
            COALESCE(c.customer_phone,'N/A') as phone,
            COALESCE(c.customer_gender,'N/A') as gender,
            COALESCE(c.customer_year_of_birth,'-1')  as year_of_birthday,
            COALESCE(c.customer_email,'N/A') as email,
            COALESCE(c.customer_address,'N/A') as address,
            COALESCE(c3.country_id,-1) as country_id
    FROM  SA_SOURCE_SYSTEM_1.src_customers c
    LEFT JOIN bl_3nf.ce_countries c3
    ON c.customer_country_name=c3.country)
    UNION (
    SELECT DISTINCT
            c.customer_id AS customer_srcid, 
            'company_sales' AS customer_source_system, 
            'src_employees' AS customer_source_entity, 
            'N/A' as first_name,
            'N/A' as last_name,
            COALESCE(c.customer_company_name,'N/A') as company_name,
            COALESCE(c.customer_company_number,'N/A') as company_number,
            COALESCE(c.customer_phone,'N/A') as phone,
            'N/A' as gender,
            '-1' as year_of_birthday,
            COALESCE(c.customer_email,'N/A') as email,
            COALESCE(c.customer_address,'N/A') as address,
            COALESCE(c3.country_id,-1) as country_id
    FROM  SA_SOURCE_SYSTEM_2.src_customers c
    LEFT JOIN bl_3nf.ce_countries c3
    ON c.customer_country_name=c3.country
    )) t
         ON (ch.customer_srcid = t.customer_srcid
         AND ch.customer_source_system = t.customer_source_system
         AND ch.customer_source_entity = t.customer_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(customer_id, customer_srcid, customer_source_system, customer_source_entity,first_name, last_name,company_name, company_number,phone, gender,year_of_birthday,  email, address, country_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_customer_id.NEXTVAL,t.customer_srcid, t.customer_source_system, t.customer_source_entity,t.first_name, t.last_name,t.company_name, t.company_number,t.phone, t.gender,t.year_of_birthday, t.email, t.address, t.country_id,SYSDATE,SYSDATE);

MERGE INTO ce_customers ch
    USING (SELECT DISTINCT
            -1 as customer_id,
            -1 AS customer_srcid, 
            'personnel_sales' AS customer_source_system, 
            'src_employees' AS customer_source_entity, 
            'N/A' as first_name,
            'N/A' as last_name,
            'N/A' as company_name,
            'N/A' as company_number,
            'N/A' as phone,
            'N/A' as gender,
            -1  as year_of_birthday,
            'N/A' as email,
            'N/A' as address,
            -1 as country_id
    FROM  Dual) t
         ON (ch.customer_srcid = t.customer_srcid
         AND ch.customer_source_system = t.customer_source_system
         AND ch.customer_source_entity = t.customer_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(customer_id, customer_srcid, customer_source_system, customer_source_entity,first_name, last_name,company_name, company_number,phone, gender,year_of_birthday,  email, address, country_id,ta_update_dt, ta_insert_dt)
        VALUES(t.customer_id,t.customer_srcid, t.customer_source_system, t.customer_source_entity,t.first_name, t.last_name,t.company_name, t.company_number,t.phone, t.gender,t.year_of_birthday, t.email, t.address, t.country_id,SYSDATE,SYSDATE);

 SELECT * FROM ce_customers;
commit;       


MERGE INTO ce_positions  ch
    USING (SELECT DISTINCT
            employee_position_id AS position_srcid, 
            'personnel_sales' AS position_source_system, 
            'src_employees' AS position_source_entity, 
             COALESCE(employee_position,'N/A') as position
    FROM  SA_SOURCE_SYSTEM_1.src_employees) t
         ON (ch.position_srcid = t.position_srcid
         AND ch.position_source_system = t.position_source_system
         AND ch.position_source_entity = t.position_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(position_id,position_srcid, position_source_system, position_source_entity, position,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_position_id.NEXTVAL,t.position_srcid, t.position_source_system, t.position_source_entity, t.position,SYSDATE,SYSDATE); 
        
MERGE INTO ce_positions  ch
    USING (SELECT DISTINCT
            -1 as position_id,
            -1 AS position_srcid, 
            'personnel_sales' AS position_source_system, 
            'src_employees' AS position_source_entity, 
             'N/A' as position
    FROM  DUAL)
    WHEN NOT MATCHED THEN 
         INSERT(position_id,position_srcid, position_source_system, position_source_entity, position,ta_update_dt, ta_insert_dt)
        VALUES(t.position_id,t.position_srcid, t.position_source_system, t.position_source_entity, t.position,SYSDATE,SYSDATE); 
 SELECT * FROM ce_positions;
commit;      


MERGE INTO ce_employees ch
    USING (SELECT DISTINCT
            c.employee_id AS employee_srcid, 
            'personnel_sales' AS employee_source_system, 
            'src_employees' AS employee_source_entity, 
            COALESCE(c.employee_name,'N/A') as first_name,
            COALESCE(c.employee_last_name,'N/A') as last_name,
            COALESCE((TO_DATE(SUBSTR(c.employee_birthday,1,10) ,'yyyy-mm-dd')),TO_DATE('9999-12-31' ,'yyyy-mm-dd')) as day_of_birthday,
            COALESCE(c2.position_id,-1) as position_id,
            COALESCE(c.employee_phone,'N/A') as phone,
            COALESCE(c.employee_email,'N/A') as email,
            COALESCE(c.employee_address,'N/A') as address,
            COALESCE(c3.country_id,-1) as country_id
    FROM  SA_SOURCE_SYSTEM_1.src_employees c
    LEFT JOIN bl_3nf.ce_positions c2
    ON c.employee_position_id=c2.position_srcid
    LEFT JOIN bl_3nf.ce_countries c3
    ON c.employee_country=c3.country) t
         ON (ch.employee_srcid = t.employee_srcid
         AND ch.employee_source_system = t.employee_source_system
         AND ch.employee_source_entity = t.employee_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(employee_id, employee_srcid, employee_source_system, employee_source_entity,first_name, last_name, day_of_birthday,position_id, phone, email, address, country_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_epmployee_id.NEXTVAL,t.employee_srcid, t.employee_source_system, t.employee_source_entity,t.first_name, t.last_name, t.day_of_birthday,t.position_id, t.phone, t.email, t.address, t.country_id,SYSDATE,SYSDATE);
MERGE INTO ce_employees ch
    USING (SELECT DISTINCT
            -1 as employee_id,
            -1 AS employee_srcid, 
            'personnel_sales' AS employee_source_system, 
            'src_employees' AS employee_source_entity, 
            'N/A' as first_name,
            'N/A' as last_name,
            TO_DATE('9999-12-31' ,'yyyy-mm-dd') as day_of_birthday,
            -1 as position_id,
            'N/A' as phone,
            'N/A' as email,
            'N/A' as address,
            -1 as country_id
    FROM  DUAL) t
         ON (ch.employee_srcid = t.employee_srcid
         AND ch.employee_source_system = t.employee_source_system
         AND ch.employee_source_entity = t.employee_source_entity)
    WHEN NOT MATCHED THEN 
         INSERT(employee_id, employee_srcid, employee_source_system, employee_source_entity,first_name, last_name, day_of_birthday,position_id, phone, email, address, country_id,ta_update_dt, ta_insert_dt)
        VALUES(t.employee_id,t.employee_srcid, t.employee_source_system, t.employee_source_entity,t.first_name, t.last_name, t.day_of_birthday,t.position_id, t.phone, t.email, t.address, t.country_id,SYSDATE,SYSDATE);


 SELECT * FROM ce_employees;
commit; 



   
  INSERT INTO ce_sales (sale_id,sale_source_system,sale_source_entity, product_id, date_id, promotion_id, channel_id, store_id, employee_id, customer_id, sale_cost, sale_price, sale_quantity,ta_update_dt, ta_insert_dt)
  (SELECT
    seq_ce_sale_id.NEXTVAL,
    'pesonnel_sales' AS sale_source_system, 
    'src_sales' AS sale_source_entity, 
    COALESCE(p.product_id,-1),
    COALESCE((TO_DATE(c.time_id ,'yyyy-mm-dd')),(TO_DATE('9999-12-31' ,'yyyy-mm-dd'))) as date_id,
    COALESCE(p2.promotion_id,-1),
    COALESCE(c3.channel_id,-1),
    COALESCE(s.store_id,-1),
    COALESCE(e.employee_id,-1),
    COALESCE(c2.customer_id,-1),
    p.unit_cost*c.quantity_sold as sale_cost,
    p.unit_price*c.quantity_sold as sale_price,
    c.quantity_sold as sale_quantity,
    SYSDATE,SYSDATE
    FROM  SA_SOURCE_SYSTEM_1.src_sales c
    LEFT JOIN bl_3nf.ce_products p
    ON c.product_id=p.product_srcid
    LEFT JOIN bl_3nf.ce_customers c2
    ON c.customer_id=c2.customer_srcid
    LEFT JOIN bl_3nf.ce_channels c3
    ON c.channel_id=c3.channel_srcid
    LEFT JOIN bl_3nf.ce_promotions_scd p2
    ON c.promo_id=p2.promotion_srcid
    LEFT JOIN bl_3nf.ce_employees e
    ON c.employee_id=e.employee_srcid
    LEFT JOIN bl_3nf.ce_stores s
    ON c.store_id=s.store_srcid
    Where c2.customer_source_system='personnel_sales'
    and c3.channel_source_system='personnel_sales');
INSERT INTO ce_sales (sale_id,sale_source_system,sale_source_entity, product_id, date_id, promotion_id, channel_id, store_id, employee_id, customer_id, sale_cost, sale_price, sale_quantity,ta_update_dt, ta_insert_dt)
     (SELECT
    seq_ce_sale_id.NEXTVAL,
    'company_sales' AS sale_source_system, 
    'src_sales' AS sale_source_entity, 
    COALESCE(p.product_id,-1),
    COALESCE((TO_DATE(c.time_id ,'yyyy-mm-dd')),(TO_DATE('9999-12-31' ,'yyyy-mm-dd'))) as date_id,
    COALESCE(p2.promotion_id,-1),
    COALESCE(c3.channel_id,-1),
    COALESCE(s.store_id,-1),
    COALESCE(e.employee_id,-1),
    COALESCE(c2.customer_id,-1),
    p.unit_cost*c.quantity_sold as sale_cost,
    p.unit_price*c.quantity_sold as sale_price,
    c.quantity_sold as sale_quantity,
    SYSDATE,SYSDATE
    FROM  SA_SOURCE_SYSTEM_1.src_sales c
    LEFT JOIN bl_3nf.ce_products p
    ON c.product_id=p.product_srcid
    LEFT JOIN bl_3nf.ce_customers c2
    ON c.customer_id=c2.customer_srcid
    LEFT JOIN bl_3nf.ce_channels c3
    ON c.channel_id=c3.channel_srcid
    LEFT JOIN bl_3nf.ce_promotions_scd p2
    ON c.promo_id=p2.promotion_srcid
    LEFT JOIN bl_3nf.ce_employees e
    ON c.employee_id=e.employee_srcid
    LEFT JOIN bl_3nf.ce_stores s
    ON c.store_id=s.store_srcid
    Where c2.customer_source_system='company_sales'
    and c3.channel_source_system='company_sales');
     SELECT * FROM ce_sales;
commit; 