CREATE OR REPLACE PACKAGE BODY PKG_LOAD_BL_DM_TABLES IS
    ----------------------------------------------------------------------
    -- Load CE_CHANNEL_CLASSES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_DIM_CHANNELS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER := 0;
        ROW_CH_CL            DIM_CHANNELS%ROWTYPE;
        TYPE CHANNELS_T IS
            TABLE OF BL_3NF.CE_CHANNELS%ROWTYPE;
        LOADED_CHANNELS      CHANNELS_T;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_BL_DM_CHANNELS';
        L_TABLE              VARCHAR2(100) := 'CE_CHANNELS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            DIM_CHANNELS;

        CURSOR CURSOR_CHANNELS IS
        SELECT
            *
        FROM
            BL_3NF.CE_CHANNELS C;
 
    
    BEGIN

---------Explicit Cursor usage -------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------

---------Merhe logic------------------------------------------------------------

        OPEN CURSOR_CHANNELS;
        LOOP
            FETCH CURSOR_CHANNELS
            BULK COLLECT INTO LOADED_CHANNELS LIMIT 100;
            FORALL CHANEL IN LOADED_CHANNELS.FIRST..LOADED_CHANNELS.LAST
                MERGE INTO DIM_CHANNELS CH
                USING (
                          SELECT
                              LOADED_CHANNELS(CHANEL).CHANNEL_ID          AS CHANNEL_SRCID,
                              LOADED_CHANNELS(CHANEL).CHANNEL_DESCRIPTION AS CHANNEL_DESCRIPTION,
                              LOADED_CHANNELS(CHANEL).CHANNEL_CLASS_ID    AS CHANNEL_CLASS_ID, 
                              '3nf'                                       AS SOURCE_SYSTEM,
                              'ce_channels'                               AS SOURCE_ENTITY
                          FROM
                              DUAL
                      )
                T ON ( CH.CHANNEL_SRCID = T.CHANNEL_SRCID
                       AND CH.SOURCE_SYSTEM = T.SOURCE_SYSTEM
                       AND CH.SOURCE_ENTITY = T.SOURCE_ENTITY )
                WHEN MATCHED THEN UPDATE
                SET CH.CHANNEL_DESCRIPTION = T.CHANNEL_DESCRIPTION,
                    CH.CHANNEL_CLASS_ID = T.CHANNEL_CLASS_ID
                WHERE
                    ( DECODE(CH.CHANNEL_DESCRIPTION, T.CHANNEL_DESCRIPTION, 0, 1) + DECODE(CH.CHANNEL_CLASS_ID, T.CHANNEL_CLASS_ID, 0,
                    1) ) > 0
                WHEN NOT MATCHED THEN
                INSERT (
                    CHANNEL_SURR_ID,
                    CHANNEL_SRCID,
                    SOURCE_SYSTEM,
                    SOURCE_ENTITY,
                    CHANNEL_DESCRIPTION,
                    CHANNEL_CLASS_ID,
                    CHANNEL_CLASS,
                    TA_UPDATE_DT,
                    TA_INSERT_DT )
                VALUES
                    ( SEQ_DIM_CHANNEL_ID.NEXTVAL,
                    T.CHANNEL_SRCID,
                    T.SOURCE_SYSTEM,
                    T.SOURCE_ENTITY,
                    T.CHANNEL_DESCRIPTION,
                    T.CHANNEL_CLASS_ID,
                    '---',
                    SYSDATE,
                    SYSDATE );

            L_ROWS := L_ROWS + SQL%ROWCOUNT;
    -----Update logic------------------------------------------------------- 
            UPDATE (
                SELECT
                    C.CHANNEL_CLASS_ID,
                    C.CHANNEL_CLASS  CL1,
                    C2.CHANNEL_CLASS CL2
                FROM
                    DIM_CHANNELS       C,
                    CE_CHANNEL_CLASSES C2
                WHERE
                    C.CHANNEL_CLASS_ID = C2.CHANNEL_CLASS_ID
            )
            SET
                CL1 = CL2;
    ------------------------------------------------------------------------
            COMMIT;
            EXIT WHEN CURSOR_CHANNELS%NOTFOUND;
        END LOOP;
        CLOSE CURSOR_CHANNELS;
--------------------------------------------------------------------------------

---------Explicit Cursor usage--------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------
---------Logging on finish procedure--------------------------------------------

        PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, COUNT_OF_ROWS_BEFORE,
               L_ROWS, COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL); 
--------------------------------------------------------------------------------       
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
---------Logging on exception procedure-----------------------------------------
            L_CONTEXT := 'LOADING DIM_CHANNELS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_DIM_CHANNELS;
    
    
    
    
     ----------------------------------------------------------------------
    -- Load CE_CHANNEL_CLASSES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_DIM_PROMOTIONS_SCD IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER := 0;
        p_last_update_dt DATE;
        ROW_CH_CL            DIM_PROMOTIONS_SCD%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_BL_DM_CHANNELS';
        L_TABLE              VARCHAR2(100) := 'DIM_PROMOTIONS_SCD';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            DIM_PROMOTIONS_SCD;

        

    BEGIN

---------Explicit Cursor usage -------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------

---------Merhe logic------------------------------------------------------------

        
SELECT 
            previous_loaded_date
        INTO 
            p_last_update_dt 
        FROM 
            BL_CL.PRM_MTA_INCREMENTAL_LOAD 
        WHERE
            sa_table_name = 'CE_PROMOTIONS_SCD';


        MERGE INTO DIM_PROMOTIONS_SCD DM
        USING (
            SELECT
            TO_CHAR(PROMOS.promotion_id) as promotion_srcid,
                '3nf' as promotion_source_system,
                'ce_promotions_scd' as promotion_source_entity,
                PROMOS.promotion_name as promotion_name,
                PROMOS.promotion_category_id as promotion_category_id,
                pc.promotion_category as promotion_category,
                PROMOS.start_dt as start_dt,
                PROMOS.end_dt as end_dt,
                PROMOS.is_active as is_active,
                PROMOS.Cost as cost
                
            FROM
    
                CE_PROMOTIONS_SCD PROMOS 
                inner join BL_3NF.ce_promotion_categories pc
                on promos.promotion_category_id=pc.promotion_category_id
            WHERE
            PROMOS.TA_UPDATE_DT>P_LAST_UPDATE_DT AND
                promos.promotion_id > -1
        ) NF
        ON ( 
            DM.promotion_srcid = NF.promotion_srcid
            AND DM.source_system = NF.promotion_source_system
            AND DM.source_entity = NF.promotion_source_entity
            AND DM.START_DT = NF.START_DT)
        WHEN MATCHED THEN 
            UPDATE SET
                DM.promotion_name = NF.promotion_name,
                DM.promotion_category_id = NF.promotion_category_id,
                DM.PROMOTION_CATEGORY = NF.promotion_category,

                DM.end_dt = NF.end_dt,
                DM.is_active = NF.is_active,
                DM.COST=NF.COST,
                DM.ta_update_dt = sysdate
            WHERE (
                DECODE(DM.promotion_name, NF.promotion_name, 0, 1)+
                DECODE(DM.promotion_category_id, NF.promotion_category_id, 0, 1)+
                DECODE(DM.promotion_category, NF.promotion_category, 0, 1)
                + DECODE(DM.start_dt, NF.start_dt, 0, 1)
                + DECODE(DM.end_dt, NF.end_dt, 0, 1)
                + DECODE(DM.is_active, NF.is_active, 0, 1)
                + DECODE(DM.cost, NF.cost, 0, 1)) > 0
        WHEN NOT MATCHED THEN 
            INSERT (
                    PROMOTION_SURR_ID     ,
                    PROMOTION_SRCID       ,
                    SOURCE_SYSTEM         ,
                    SOURCE_ENTITY         ,
                    PROMOTION_NAME        ,
                    PROMOTION_CATEGORY_ID ,
                    PROMOTION_CATEGORY    ,
                    START_DT              ,
                    END_DT                ,
                    IS_ACTIVE             ,
                    COST                  ,
                    TA_UPDATE_DT          ,
                    TA_INSERT_DT  
            )
            VALUES (
                BL_DM.SEQ_DIM_PROMOTION_ID .nextval,
                 NF.PROMOTION_SRCID       ,
                    NF.promotion_SOURCE_SYSTEM         ,
                    NF.promotion_SOURCE_ENTITY         ,
                    NF.PROMOTION_NAME        ,
                    NF.PROMOTION_CATEGORY_ID ,
                    NF.PROMOTION_CATEGORY    ,
                    NF.START_DT              ,
                    NF.END_DT                ,
                    NF.IS_ACTIVE             ,
                    NF.COST                  ,
                sysdate,
                sysdate
            );

        L_ROWS := L_ROWS + SQL%ROWCOUNT;
        
        COMMIT;




        UPDATE BL_CL.PRM_MTA_INCREMENTAL_LOAD
        SET 
            previous_loaded_date = sysdate
        WHERE sa_table_name = 'CE_PROMOTIONS_SCD';

--------------------------------------------------------------------------------

---------Explicit Cursor usage--------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------
---------Logging on finish procedure--------------------------------------------

        PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, COUNT_OF_ROWS_BEFORE,
               L_ROWS, COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL); 
--------------------------------------------------------------------------------       
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
---------Logging on exception procedure-----------------------------------------
            L_CONTEXT := 'LOADING DIM_PROMOTIONS_SCD: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_DIM_PROMOTIONS_SCD;
    
    
    
    
    
       ----------------------------------------------------------------------
    -- Load  DIM_PRODUCTS load from 2 sources without dedublication because of business requirenments
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_DIM_PRODUCTS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            DIM_PRODUCTS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_DIM_PRODUCTS';
        L_TABLE              VARCHAR2(100) := 'DIM_PRODUCTS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            DIM_PRODUCTS;

    BEGIN

---------Explicit Cursor usage -------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------


---------Merhe logic------------------------------------------------------------
MERGE INTO dim_products ch
    USING (SELECT 
            c.product_id AS product_srcid, 
            '3nf' AS product_source_system, 
            'ce_products' AS product_source_entity, 
            COALESCE(c.product,'N/A') AS product_name,
            COALESCE(c2.product_brand_id,-1) AS PRODUCT_BRAND_ID,
            COALESCE(c2.product_brand,'N/A') AS PRODUCT_BRAND,
            COALESCE(c3.product_type_id,-1) AS PRODUCT_TYPE_ID,
            COALESCE(c3.product_type,'N/A') AS PRODUCT_TYPE

            
    FROM  CE_PRODUCTS c
    LEFT JOIN ce_brands c2
    ON c.product_brand_id=c2.product_brand_id 
    LEFT JOIN ce_product_types c3 
    on c.product_type_id=c3.product_type_id
     ) t
         ON (ch.product_srcid = t.product_srcid
         AND ch.source_system = t.product_source_system
         AND ch.source_entity = t.product_source_entity)
    WHEN  MATCHED THEN
        Update set 

    PRODUCT_NAME=product_name, PRODUCT_BRAND_ID= PRODUCT_BRAND_ID,PRODUCT_BRAND=PRODUCT_BRAND,PRODUCT_TYPE_ID=PRODUCT_TYPE_ID,PRODUCT_TYPE=PRODUCT_TYPE,ta_update_dt=SYSDATE
        Where  ( DECODE(CH.product_name, T.product_name, 0, 1) + 
                DECODE(CH.PRODUCT_BRAND_ID, T.PRODUCT_BRAND_ID, 0, 1) +
                DECODE(CH.PRODUCT_BRAND, T.PRODUCT_BRAND, 0, 1) +
                 DECODE(CH.PRODUCT_TYPE_ID, T.PRODUCT_TYPE_ID, 0, 1) +
                DECODE(CH.PRODUCT_TYPE, T.PRODUCT_TYPE, 0, 1) 
                ) >0 
    WHEN NOT MATCHED THEN 
         INSERT(PRODUCT_SURR_ID,PRODUCT_SRCID,SOURCE_SYSTEM,SOURCE_ENTITY,PRODUCT_NAME,PRODUCT_BRAND_ID,PRODUCT_BRAND,PRODUCT_TYPE_ID,PRODUCT_TYPE,TA_UPDATE_DT,TA_INSERT_DT)
        VALUES(seq_dim_product_id.NEXTVAL,t.product_srcid, t.product_source_system, t.product_source_entity, t.product_name, t.PRODUCT_BRAND_ID,t.PRODUCT_BRAND,t.PRODUCT_TYPE_ID,t.PRODUCT_TYPE,SYSDATE,SYSDATE);

        
        L_ROWS := SQL%ROWCOUNT;
--------------------------------------------------------------------------------

---------Explicit Cursor usage--------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------
---------Logging on finish procedure--------------------------------------------

        PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, COUNT_OF_ROWS_BEFORE,
               L_ROWS, COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL); 
--------------------------------------------------------------------------------       
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
---------Logging on exception procedure-----------------------------------------
            L_CONTEXT := 'LOADING CE_CHANNEL_CLASSES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_DIM_PRODUCTS;
    
    
    
      ----------------------------------------------------------------------
    -- Load  CE_STORES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_DIM_STORES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            DIM_STORES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_DIM_STORES';
        L_TABLE              VARCHAR2(100) := 'DIM_STORES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           DIM_STORES;

    BEGIN

---------Explicit Cursor usage -------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------

---------Merhe logic------------------------------------------------------------
MERGE INTO dim_stores ch
    USING (SELECT DISTINCT
            c.store_id AS store_srcid, 
            'personnel_sales' AS store_source_system, 
            'src_stores' AS store_source_entity, 
            COALESCE(c.phone, 'N/A') as phone,
            COALESCE(c3.address_id,-1) as  address_id,
            COALESCE(c3.street_address,'N/A') as  STREET_ADDRESS,
            COALESCE(c3.POSTAL_CODE,'N/A') as  POSTAL_CODE,
            COALESCE(c4.city_id,-1) as  city_id,
            COALESCE(c4.city,'N/A') as  city,
            COALESCE(s.state_id,-1) as  state_id,
            COALESCE(s.state_name,'N/A') as  state,
            COALESCE(c5.country_id,-1) as  country_id,
            COALESCE(c5.country,'N/A') as  country
    FROM  ce_stores c
    LEFT JOIN ce_addresses c3
    ON c.store_id=c3.address_id
    LEFT JOIN ce_cities c4
    ON c4.city_id=c3.city_id
    LEFT JOIN ce_states s
    ON s.state_id=c4.state_id
    LEFT JOIN ce_countries c5
    ON s.country_id=c5.country_id
   ) t
         ON (ch.store_srcid = t.store_srcid
         AND ch.source_system = t.store_source_system
         AND ch.source_entity = t.store_source_entity
         )
     WHEN  MATCHED THEN
       Update set 
         PHONE=PHONE,
    STREET_ADDRESS= STREET_ADDRESS,
    POSTAL_CODE=POSTAL_CODE,
    CITY_ID=CITY_ID,
    CITY=city,
    STATE_ID=state_id,
    STATE= state,
    COUNTRY_ID=country_id,
    COUNTRY= country,
    ta_update_dt=SYSDATE
         WHERE ( DECODE(CH.PHONE, T.PHONE, 0, 1) + DECODE(CH.STREET_ADDRESS, T.STREET_ADDRESS, 0, 1)+
         DECODE(CH.POSTAL_CODE, T.POSTAL_CODE, 0, 1) + DECODE(CH.CITY_ID, T.CITY_ID, 0, 1)+
         DECODE(CH.CITY, T.CITY, 0, 1) + DECODE(CH.STATE_ID, T.STATE_ID, 0, 1)+
         DECODE(CH.STATE, T.STATE, 0, 1) + DECODE(CH.COUNTRY_ID, T.COUNTRY_ID, 0, 1)+
         DECODE(CH.COUNTRY, T.COUNTRY, 0, 1) 
         ) > 
            0
         
    WHEN NOT MATCHED THEN 
    INSERT (
    STORE_SURR_ID,
    STORE_SRCID,
    SOURCE_SYSTEM,
    SOURCE_ENTITY,
    PHONE,
    STREET_ADDRESS,
    POSTAL_CODE,
    CITY_ID,
    CITY,
    STATE_ID,
    STATE,
    COUNTRY_ID,
    COUNTRY,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
     seq_dim_store_id.NEXTVAL,
   t.STORE_SRCID,
    t.store_SOURCE_SYSTEM,
    t.store_SOURCE_ENTITY,
    t.PHONE,
    t.STREET_ADDRESS,
    t.POSTAL_CODE,
    t.CITY_ID,
    t.CITY,
    t.STATE_ID,
    t.STATE,
    t.COUNTRY_ID,
    t.COUNTRY
    ,SYSDATE,SYSDATE
);
   
        L_ROWS := SQL%ROWCOUNT;
--------------------------------------------------------------------------------

---------Explicit Cursor usage--------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------
---------Logging on finish procedure--------------------------------------------

        PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, COUNT_OF_ROWS_BEFORE,
               L_ROWS, COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL); 
--------------------------------------------------------------------------------       
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
---------Logging on exception procedure-----------------------------------------
            L_CONTEXT := 'LOADING DIM_STORES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_DIM_STORES;
   
    ----------------------------------------------------------------------
    -- Load  CE_CUSTOMERS load from 2 sources withou dedublication because business guarantees that there is no equal customers in different systems
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_DIM_CUSTOMERS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            DIM_CUSTOMERS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_DIM_CUSTOMERS';
        L_TABLE              VARCHAR2(100) := 'DIM_CUSTOMERS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           DIM_CUSTOMERS;

    BEGIN

---------Explicit Cursor usage -------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------


---------Merhe logic------------------------------------------------------------
MERGE INTO DIM_CUSTOMERS ch
    USING (SELECT 
            c.customer_id AS customer_srcid, 
            '3nf' AS customer_source_system, 
            'src_employees' AS customer_source_entity, 
            COALESCE(c.first_name,'N/A') as first_name,
            COALESCE(c.last_name,'N/A') as last_name,
            COALESCE(c.company_name,'N/A') as company_name,
            COALESCE(c.phone,'N/A') as phone,
            COALESCE(c.company_number,'N/A') as company_number,
            COALESCE(c.gender,'N/A') as gender,
            COALESCE(c.year_of_birthday,-1) as year_of_birthday,
            COALESCE(c.email,'N/A') as email,
            COALESCE(c3.country,'N/A') as country,
            COALESCE(c3.country_id,-1) as country_id,
            COALESCE(c.address,'N/A') as address
            
    FROM  ce_customers c
    LEFT JOIN bl_3nf.ce_countries c3
    ON c.country_id=c3.country_id
   ) t
         ON (ch.customer_srcid = t.customer_srcid
         AND ch.source_system = t.customer_source_system
         AND ch.source_entity = t.customer_source_entity)
     WHEN  MATCHED THEN
        Update set 
         first_name=first_name, last_name=last_name,company_name=company_name, company_number=company_number,phone=phone, gender=gender,year_of_birth=year_of_birthday,  email=email, address=address, country_id=country_id,country=country, ta_update_dt=SYSDATE
         WHERE ( DECODE(CH.first_name, T.first_name, 0, 1) + DECODE(CH.last_name, T.last_name, 0, 1)
         + DECODE(CH.company_name, T.company_name, 0, 1)+ DECODE(CH.company_number, T.company_number, 0, 1)
         + DECODE(CH.phone, T.phone, 0, 1)+ DECODE(CH.gender, T.gender, 0, 1)
         + DECODE(CH.year_of_birth, T.year_of_birthday, 0, 1)+ DECODE(CH.email, T.email, 0, 1)
         + DECODE(CH.address, T.address, 0, 1)+ DECODE(CH.country_id, T.country_id, 0, 1)+DECODE(CH.country, T.country, 0, 1)
         ) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(customer_SURR_ID, customer_srcid, source_system, source_entity,first_name, last_name,company_name,phone, company_number, gender,year_of_birth,  email, country, country_id,address,ta_update_dt, ta_insert_dt)
        VALUES(seq_dim_customer_id.NEXTVAL,t.customer_srcid, t.customer_source_system, t.customer_source_entity,t.first_name, t.last_name,t.company_name,t.phone, t.company_number, t.gender,t.year_of_birthday,  t.email, t.country, t.country_id,t.address,SYSDATE,SYSDATE);



        L_ROWS := SQL%ROWCOUNT;
--------------------------------------------------------------------------------

---------Explicit Cursor usage--------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------
---------Logging on finish procedure--------------------------------------------

        PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, COUNT_OF_ROWS_BEFORE,
               L_ROWS, COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL); 
--------------------------------------------------------------------------------       
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
---------Logging on exception procedure-----------------------------------------
            L_CONTEXT := 'LOADING DIM_CUSTOMERS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_DIM_CUSTOMERS;
    
    
        ----------------------------------------------------------------------
    -- Load  CE_EMPLOYEES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_DIM_EMPLOYEES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            DIM_EMPLOYEES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_DIM_EMPLOYEES';
        L_TABLE              VARCHAR2(100) := 'DIM_EMPLOYEES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           DIM_EMPLOYEES;

    BEGIN

---------Explicit Cursor usage -------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------

---------Merhe logic------------------------------------------------------------
MERGE INTO DIM_employees ch
    USING (SELECT DISTINCT
            c.employee_id AS employee_srcid, 
            '3nf' AS employee_source_system, 
            'ce_employees' AS employee_source_entity, 
            COALESCE(c.first_name,'N/A') as first_name,
            COALESCE(c.last_name,'N/A') as last_name,
            COALESCE(c.day_of_birthday,TO_DATE('9999-12-31' ,'yyyy-mm-dd')) as day_of_birthday,
            COALESCE(c2.position_id,-1) as position_id,
            COALESCE(c2.position,'N/A') as position,
            COALESCE(c.phone,'N/A') as phone,
            COALESCE(c.email,'N/A') as email,
            COALESCE(c.address,'N/A') as address,
            COALESCE(c3.country_id,-1) as country_id,
            COALESCE(c3.country,'N/A') as country
    FROM  ce_employees c
    LEFT JOIN bl_3nf.ce_positions c2
    ON c.position_id=c2.position_id
    LEFT JOIN bl_3nf.ce_countries c3
    ON c.country_id=c3.country_id) t
         ON (ch.employee_srcid = t.employee_srcid
         AND ch.source_system = t.employee_source_system
         AND ch.source_entity = t.employee_source_entity)
    WHEN  MATCHED THEN
        Update set 
         first_name=first_name, last_name=last_name, day_of_birthday_dt=day_of_birthday,position_id=position_id,position=position, phone=phone, email=email, address=address, country_id=country_id,country=country,ta_update_dt=SYSDATE
         Where ( DECODE(CH.first_name, T.first_name, 0, 1) + DECODE(CH.last_name, T.last_name, 0, 1) +
         DECODE(CH.day_of_birthday_dt, T.day_of_birthday, 0, 1) + DECODE(CH.position_id, T.position_id, 0, 1) +
         DECODE(CH.phone, T.phone, 0, 1) + DECODE(CH.email, T.email, 0, 1) +
         DECODE(CH.address, T.address, 0, 1) + DECODE(CH.country_id, T.country_id, 0, 1) +
          DECODE(CH.position, T.position, 0, 1) + DECODE(CH.country, T.country, 0, 1)
         ) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(employee_SURR_ID, employee_srcid, source_system, source_entity,first_name, last_name, day_of_birthday_dt,position_id,position, phone, email, address, country_id,country,ta_update_dt, ta_insert_dt)
        VALUES(SEQ_DIM_EMPLOYEE_ID.NEXTVAL,t.employee_srcid, t.employee_source_system, t.employee_source_entity,t.first_name, t.last_name, t.day_of_birthday,t.position_id,t.position, t.phone, t.email, t.address, t.country_id,t.country,SYSDATE,SYSDATE);



        L_ROWS := SQL%ROWCOUNT;
--------------------------------------------------------------------------------

---------Explicit Cursor usage--------------------------------------------------
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        CLOSE CH_CL;
--------------------------------------------------------------------------------
---------Logging on finish procedure--------------------------------------------

        PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, COUNT_OF_ROWS_BEFORE,
               L_ROWS, COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL); 
--------------------------------------------------------------------------------       
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
---------Logging on exception procedure-----------------------------------------
            L_CONTEXT := 'LOADING DIM_EMPLOYEES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_DIM_EMPLOYEES;


END PKG_LOAD_BL_DM_TABLES;