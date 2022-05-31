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