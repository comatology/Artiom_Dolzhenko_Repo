CREATE OR REPLACE PACKAGE BODY PKG_LOAD_3NF_TABLES IS
    ----------------------------------------------------------------------
    -- Load CE_CHANNEL_CLASSES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_CHANNEL_CLASSES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CHANNEL_CLASSES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_CHANNEL_CLASSES';
        L_TABLE              VARCHAR2(100) := 'CE_CHANNEL_CLASSES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_CHANNEL_CLASSES;

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

        MERGE INTO CE_CHANNEL_CLASSES CH
        USING (
                  SELECT DISTINCT
                      CHANNEL_CLASS_ID               AS CHANNEL_CLASS_SRCID,
                      'personnel_sales'              AS CHANNEL_CLASS_SOURCE_SYSTEM,
                      'src_channels'                 AS CHANNEL_CLASS_SOURCE_ENTITY,
                      COALESCE(CHANNEL_CLASS, 'N/A') AS CHANNEL_CLASS
                  FROM
                      SA_SOURCE_SYSTEM_1.SRC_CHANNELS
              )
        T ON ( CH.CHANNEL_CLASS_SRCID = T.CHANNEL_CLASS_SRCID
               AND CH.CHANNEL_CLASS_SOURCE_SYSTEM = T.CHANNEL_CLASS_SOURCE_SYSTEM
               AND CH.CHANNEL_CLASS_SOURCE_ENTITY = T.CHANNEL_CLASS_SOURCE_ENTITY )
        WHEN MATCHED THEN UPDATE
        SET CHANNEL_CLASS = CHANNEL_CLASS,
            TA_UPDATE_DT = SYSDATE
        WHERE
            CH.CHANNEL_CLASS <> T.CHANNEL_CLASS
        WHEN NOT MATCHED THEN
        INSERT (
            CHANNEL_CLASS_ID,
            CHANNEL_CLASS_SRCID,
            CHANNEL_CLASS_SOURCE_SYSTEM,
            CHANNEL_CLASS_SOURCE_ENTITY,
            CHANNEL_CLASS,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( SEQ_CE_CHANNEL_CLASS_ID.NEXTVAL,
            T.CHANNEL_CLASS_SRCID,
            T.CHANNEL_CLASS_SOURCE_SYSTEM,
            T.CHANNEL_CLASS_SOURCE_ENTITY,
            T.CHANNEL_CLASS,
            SYSDATE,
            SYSDATE );

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
    END PRC_LOAD_CE_CHANNEL_CLASSES;
    
    ----------------------------------------------------------------------
    -- Load CE_CHANNELS  DEDUBLICATION PROCEDURE
    ----------------------------------------------------------------------    
    PROCEDURE PRC_MAP_CHANNELS IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table  BL_CL.MAP_CHANNELS';
        INSERT INTO BL_CL.MAP_CHANNELS (
            CHANNEL_ID,
            CHANNEL_SRCID,
            CHANNEL_SOURCE_SYSTEM,
            CHANNEL_SOURCE_ENTITY,
            CHANNEL_DESCRIPTION,
            CHANNEL_CLASS_ID,
            TA_UPDATE_DT,
            TA_INSERT_DT
        )
            SELECT
                SEQ_MAP_CHANNEL_ID.NEXTVAL,
                C.CHANNEL_ID                       AS CHANNEL_SRCID,
                'personnel_sales'                  AS CHANNEL_SOURCE_SYSTEM,
                'src_channels'                     AS CHANNEL_SOURCE_ENTITY,
                COALESCE(C.CHANNEL_DESC, 'N/A')    AS CHANNEL_DESCRIPTION,
                COALESCE(C2.CHANNEL_CLASS_ID, - 1) AS CHANNEL_CLASS_ID,
                SYSDATE,
                SYSDATE
            FROM
                SA_SOURCE_SYSTEM_1.SRC_CHANNELS C
                LEFT JOIN BL_3NF.CE_CHANNEL_CLASSES       C2 ON C.CHANNEL_CLASS_ID = C2.CHANNEL_CLASS_SRCID;

        INSERT INTO BL_CL.MAP_CHANNELS (
            CHANNEL_ID,
            CHANNEL_SRCID,
            CHANNEL_SOURCE_SYSTEM,
            CHANNEL_SOURCE_ENTITY,
            CHANNEL_DESCRIPTION,
            CHANNEL_CLASS_ID,
            TA_UPDATE_DT,
            TA_INSERT_DT
        )
            SELECT
                M.CHANNEL_ID,
                C.CHANNEL_ID,
                'company_sales',
                'src_channels',
                COALESCE(C.CHANNEL_DESC, 'N/A'),
                COALESCE(C2.CHANNEL_CLASS_ID, - 1),
                SYSDATE,
                SYSDATE
            FROM
                SA_SOURCE_SYSTEM_2.SRC_CHANNELS C
                LEFT JOIN BL_3NF.CE_CHANNEL_CLASSES       C2 ON C.CHANNEL_CLASS_ID = C2.CHANNEL_CLASS_SRCID
                JOIN BL_CL.MAP_CHANNELS              M ON M.CHANNEL_DESCRIPTION = C.CHANNEL_DESC;

        INSERT INTO BL_CL.MAP_CHANNELS (
            CHANNEL_ID,
            CHANNEL_SRCID,
            CHANNEL_SOURCE_SYSTEM,
            CHANNEL_SOURCE_ENTITY,
            CHANNEL_DESCRIPTION,
            CHANNEL_CLASS_ID,
            TA_UPDATE_DT,
            TA_INSERT_DT
        )
            SELECT
                SEQ_MAP_CHANNEL_ID.NEXTVAL,
                C.CHANNEL_ID,
                'company_sales',
                'src_channels',
                COALESCE(C.CHANNEL_DESC, 'N/A'),
                COALESCE(C2.CHANNEL_CLASS_ID, - 1),
                SYSDATE,
                SYSDATE
            FROM
                SA_SOURCE_SYSTEM_2.SRC_CHANNELS C
                LEFT JOIN BL_3NF.CE_CHANNEL_CLASSES       C2 ON C.CHANNEL_CLASS_ID = C2.CHANNEL_CLASS_SRCID
                LEFT JOIN BL_CL.MAP_CHANNELS              M ON M.CHANNEL_DESCRIPTION = C.CHANNEL_DESC
            WHERE
                M.CHANNEL_ID IS NULL;

    END PRC_MAP_CHANNELS;
    ----------------------------------------------------------------------
    -- Load CE_CHANNELS USING DEDUBLICATIONS
    ---------------------------------------------------------------------- 

    PROCEDURE PRC_LOAD_CE_CHANNELS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CHANNELS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_CHANNES';
        L_TABLE              VARCHAR2(100) := 'CE_CHANNELS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_CHANNELS;

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

---------Dedublicate logic------------------------------------------------------
        PRC_MAP_CHANNELS();
        EXECUTE IMMEDIATE 'truncate table BL_3NF.CE_CHANNELS';
--------------------------------------------------------------------------------
---------Merhe logic------------------------------------------------------------

INSERT INTO CE_CHANNELS(
            CHANNEL_ID,
            CHANNEL_SRCID,
            CHANNEL_SOURCE_SYSTEM,
            CHANNEL_SOURCE_ENTITY,
            CHANNEL_DESCRIPTION,
            CHANNEL_CLASS_ID,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        SELECT 
                   SEQ_CE_CHANNEL_ID.NEXTVAL,cr. CHANNEL_SRCID,cr. CHANNEL_SOURCE_SYSTEM,cr.CHANNEL_SOURCE_ENTITY,cr.CHANNEL_DESCRIPTION,cr. CHANNEL_CLASS_ID,SYSDATE, SYSDATE 
                   FROM (
                   Select Distinct
                   C.CHANNEL_ID                           AS CHANNEL_SRCID,
                  'mapping'                              AS CHANNEL_SOURCE_SYSTEM,
                  'map_channels'                         AS CHANNEL_SOURCE_ENTITY,
                  COALESCE(C.CHANNEL_DESCRIPTION, 'N/A') AS CHANNEL_DESCRIPTION,
                  COALESCE(C2.CHANNEL_CLASS_ID, - 1)     AS CHANNEL_CLASS_ID
                  
              FROM
                  BL_CL.MAP_CHANNELS        C
                  LEFT JOIN BL_3NF.CE_CHANNEL_CLASSES C2 ON C.CHANNEL_SRCID = C2.CHANNEL_CLASS_SRCID) cr;
                  
            

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
    END PRC_LOAD_CE_CHANNELS;

  
   ----------------------------------------------------------------------
    -- Load  PRC_LOAD_CE_PROMOTION_CATEGORIES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_PROMOTION_CATEGORIES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_PROMOTION_CATEGORIES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_PROMOTION_CATEGORIES';
        L_TABLE              VARCHAR2(100) := 'CE_PROMOTION_CATEGORIES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_PROMOTION_CATEGORIES;

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

        MERGE INTO CE_PROMOTION_CATEGORIES CH
        USING (
                  SELECT DISTINCT
                      PROMO_CATEGORY_ID               AS PROMOTION_CATEGORY_SRCID,
                      'personnel_sales'               AS PROMOTION_CATEGORY_SOURCE_SYSTEM,
                      'src_promotions'                AS PROMOTION_CATEGORY_SOURCE_ENTITY,
                      COALESCE(PROMO_CATEGORY, 'N/A') AS PROMOTION_CATEGORY
                  FROM
                      SA_SOURCE_SYSTEM_1.SRC_PROMOTIONS
              )
        T ON ( CH.PROMOTION_CATEGORY_SRCID = T.PROMOTION_CATEGORY_SRCID
               AND CH.PROMOTION_CATEGORY_SOURCE_SYSTEM = T.PROMOTION_CATEGORY_SOURCE_SYSTEM
               AND CH.PROMOTION_CATEGORY_SOURCE_ENTITY = T.PROMOTION_CATEGORY_SOURCE_ENTITY )
        WHEN MATCHED THEN UPDATE
        SET PROMOTION_CATEGORY = PROMOTION_CATEGORY,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.PROMOTION_CATEGORY, T.PROMOTION_CATEGORY, 0, 1)) >
            0
        WHEN NOT MATCHED THEN
        INSERT (
            PROMOTION_CATEGORY_ID,
            PROMOTION_CATEGORY_SRCID,
            PROMOTION_CATEGORY_SOURCE_SYSTEM,
            PROMOTION_CATEGORY_SOURCE_ENTITY,
            PROMOTION_CATEGORY,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( SEQ_CE_PROMOTION_CATEGORY_ID.NEXTVAL,
            T.PROMOTION_CATEGORY_SRCID,
            T.PROMOTION_CATEGORY_SOURCE_SYSTEM,
            T.PROMOTION_CATEGORY_SOURCE_ENTITY,
            T.PROMOTION_CATEGORY,
            SYSDATE,
            SYSDATE );

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
    END PRC_LOAD_CE_PROMOTION_CATEGORIES;
    
    
    
   ----------------------------------------------------------------------
    -- Load  PRC_LOAD_CE_PROMOTIONS_SCD load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_PROMOTIONS_SCD IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_PROMOTIONS_SCD%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_PROMOTIONS_SCD';
        L_TABLE              VARCHAR2(100) := 'CE_PROMOTIONS_SCD';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_PROMOTIONS_SCD;

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

        MERGE INTO CE_PROMOTIONS_SCD CH
        USING (
                  SELECT DISTINCT
                      C.PROMO_ID                                                                                              AS PROMOTION_SRCID,
                      'personnel_sales'                                                                                       AS PROMOTION_SOURCE_SYSTEM,
                      'src_promotions'                                                                                        AS PROMOTION_SOURCE_ENTITY,
                      COALESCE(C.PROMO_NAME, 'N/A')                                                                           AS PROMOTION_NAME,
                      COALESCE(C2.PROMOTION_CATEGORY_ID, - 1)                                                                 AS PROMOTION_CATEGORY_ID,
                      COALESCE(TO_DATE(SUBSTR(C.PROMO_BEGIN_DATE, 1, 10), 'yyyy-mm-dd'), TO_DATE('9999-12-31', 'yyyy-mm-dd')) AS START_DT,
                      COALESCE(TO_DATE(SUBSTR(C.PROMO_END_DATE, 1, 10), 'yyyy-mm-dd'), TO_DATE('9999-12-31', 'yyyy-mm-dd'))   AS END_DT,
                      COALESCE(C.PROMO_COST, '-1')                                                                            AS COST
                  FROM
                      SA_SOURCE_SYSTEM_1.SRC_PROMOTIONS C
                      LEFT JOIN BL_3NF.CE_PROMOTION_CATEGORIES    C2 ON C.PROMO_CATEGORY_ID = C2.PROMOTION_CATEGORY_SRCID
              )
        T ON ( CH.PROMOTION_SRCID = T.PROMOTION_SRCID
               AND CH.PROMOTION_SOURCE_SYSTEM = T.PROMOTION_SOURCE_SYSTEM
               AND CH.PROMOTION_SOURCE_ENTITY = T.PROMOTION_SOURCE_ENTITY )
        WHEN MATCHED THEN UPDATE
        SET PROMOTION_NAME = PROMOTION_NAME,
            PROMOTION_CATEGORY_ID = PROMOTION_CATEGORY_ID,
            COST = COST,
            TA_UPDATE_DT = SYSDATE
        WHEN NOT MATCHED THEN
        INSERT (
            PROMOTION_ID,
            PROMOTION_SRCID,
            PROMOTION_SOURCE_SYSTEM,
            PROMOTION_SOURCE_ENTITY,
            PROMOTION_NAME,
            PROMOTION_CATEGORY_ID,
            START_DT,
            END_DT,
            IS_ACTIVE,
            COST,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( SEQ_CE_PROMOTION_ID.NEXTVAL,
            T.PROMOTION_SRCID,
            T.PROMOTION_SOURCE_SYSTEM,
            T.PROMOTION_SOURCE_ENTITY,
            T.PROMOTION_NAME,
            T.PROMOTION_CATEGORY_ID,
            T.START_DT,
            T.END_DT,
            'inactive',
            T.COST,
            SYSDATE,
            SYSDATE );

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
    END PRC_LOAD_CE_PROMOTIONS_SCD;


   ----------------------------------------------------------------------
    -- Load  CE_BRANDS load from 2 sources without dedublication because of business requirenments
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_BRANDS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_BRANDS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_BRANDS';
        L_TABLE              VARCHAR2(100) := 'CE_BRANDS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_BRANDS;

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
MERGE INTO ce_brands  ch
    USING ((SELECT 
            brand_id AS product_brand_srcid, 
            'personnel_sales' AS product_brand_source_system, 
            'src_products' AS product_brand_source_entity, 
            COALESCE(brand,'N/A') as product_brand
    FROM  SA_SOURCE_SYSTEM_1.src_products)
    UNION (SELECT 
            brand_id AS product_brand_srcid, 
            'company_sales' AS product_brand_source_system, 
            'src_products' AS product_brand_source_entity, 
            COALESCE(brand,'N/A') as product_brand
    FROM  SA_SOURCE_SYSTEM_2.src_products)) t
         ON (ch.product_brand_srcid = t.product_brand_srcid
         AND ch.product_brand_source_system = t.product_brand_source_system
         AND ch.product_brand_source_entity = t.product_brand_source_entity)
    WHEN  MATCHED THEN
        Update set 
        product_brand=product_brand,ta_update_dt=SYSDATE
        Where ch.product_brand<>t.product_brand
    WHEN NOT MATCHED THEN 
         INSERT(product_brand_id,product_brand_srcid, product_brand_source_system, product_brand_source_entity, product_brand,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_brand_id.NEXTVAL,t.product_brand_srcid, t.product_brand_source_system, t.product_brand_source_entity, t.product_brand,SYSDATE,SYSDATE);   
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
    END PRC_LOAD_CE_BRANDS;



    ----------------------------------------------------------------------
    -- Load  CE_PRODUCT_TYPES load from 2 sources without dedublication because of business requirenments
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_PRODUCT_TYPES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_PRODUCT_TYPES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_PRODUCT_TYPES';
        L_TABLE              VARCHAR2(100) := 'CE_PRODUCT_TYPES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_PRODUCT_TYPES;

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
MERGE INTO ce_product_types  ch
    USING ((SELECT 
            product_type_id AS product_type_srcid, 
            'personnel_sales' AS product_type_source_system, 
            'src_products' AS product_type_source_entity, 
           COALESCE(product_type, 'N/A') as  product_type
    FROM  SA_SOURCE_SYSTEM_1.src_products)
    UNION (
    SELECT 
            product_type_id AS product_type_srcid, 
            'company_sales' AS product_type_source_system, 
            'src_products' AS product_type_source_entity, 
           COALESCE(product_type, 'N/A') as  product_type
    FROM  SA_SOURCE_SYSTEM_2.src_products)
    
    ) t
         ON (ch.product_type_srcid = t.product_type_srcid
         AND ch.product_type_source_system = t.product_type_source_system
         AND ch.product_type_source_entity = t.product_type_source_entity)
    WHEN  MATCHED THEN
        Update set 
        product_type=product_type,ta_update_dt=SYSDATE
        WHERE ch.product_type<>t.product_type
    WHEN NOT MATCHED THEN 
         INSERT(product_type_id,product_type_srcid, product_type_source_system, product_type_source_entity, product_type,ta_update_dt, ta_insert_dt)
        VALUES(SEQ_CE_PRODUCT_TYPE_ID.nextval,t.product_type_srcid, t.product_type_source_system, t.product_type_source_entity, t.product_type,SYSDATE,SYSDATE); 
        
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
    END PRC_LOAD_CE_PRODUCT_TYPES;
    
    

    ----------------------------------------------------------------------
    -- Load  CE_PRODUCTS load from 2 sources without dedublication because of business requirenments
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_PRODUCTS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_PRODUCTS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_PRODUCTS';
        L_TABLE              VARCHAR2(100) := 'CE_PRODUCTS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_PRODUCTS;

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
MERGE INTO ce_products ch
    USING (SELECT 
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
    on c.product_type_id=c3.product_type_srcid
    Where c2.product_brand_source_system='personnel_sales'
    and c3.product_type_source_system='personnel_sales'  
    UNION SELECT 
            c.product_id AS product_srcid, 
            'company_sales' AS product_source_system, 
            'src_products' AS product_source_entity, 
            COALESCE(c.product_name,'N/A') AS product,
            COALESCE(c.unit_price,'-1') AS unit_price,
            COALESCE(c.unit_cost,'-1') AS unit_cost,     
            COALESCE(c2.product_brand_id,-1) AS product_brand_id,
            COALESCE(c3.product_type_id,-1) AS product_type_id
            
    FROM  SA_SOURCE_SYSTEM_2.src_products c
    LEFT JOIN bl_3nf.ce_brands c2
    ON c.brand_id=c2.product_brand_srcid 
    LEFT JOIN bl_3nf.ce_product_types c3 
    on c.product_type_id=c3.product_type_srcid
    Where c2.product_brand_source_system='company_sales'
    and c3.product_type_source_system='company_sales' ) t
         ON (ch.product_srcid = t.product_srcid
         AND ch.product_source_system = t.product_source_system
         AND ch.product_source_entity = t.product_source_entity)
    WHEN  MATCHED THEN
        Update set 
        product=product, unit_price=unit_price, unit_cost=unit_cost, product_brand_id=product_brand_id, product_type_id=product_type_id,ta_update_dt=SYSDATE
        Where  ( DECODE(CH.product, T.product, 0, 1) + 
                DECODE(CH.product_brand_id, T.product_brand_id, 0, 1) +
                DECODE(CH.product_type_id, T.product_type_id, 0, 1) 
                ) >0 or  CH.unit_price<> T.unit_price or  CH.unit_cost<> T.unit_cost
    WHEN NOT MATCHED THEN 
         INSERT(product_id, product_srcid, product_source_system, product_source_entity, product, unit_price, unit_cost, product_brand_id, product_type_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_product_id.NEXTVAL,t.product_srcid, t.product_source_system, t.product_source_entity, t.product, t.unit_price, t.unit_cost, t.product_brand_id, t.product_type_id,SYSDATE,SYSDATE);

        
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
    END PRC_LOAD_CE_PRODUCTS;
    
    
    
    
    ----------------------------------------------------------------------
    -- Load  CE_COUNTRIES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_COUNTRIES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_COUNTRIES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_COUNTRIES';
        L_TABLE              VARCHAR2(100) := 'CE_COUNTRIES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_COUNTRIES;

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
     WHEN  MATCHED THEN
        Update set 
        country=country,ta_update_dt=SYSDATE
        Where ch.country<>t.country
    WHEN NOT MATCHED THEN 
         INSERT(country_id,country_srcid, country_source_system, country_source_entity, country,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_country_id.NEXTVAL,t.country_srcid, t.country_source_system, t.country_source_entity, t.country,SYSDATE,SYSDATE); 

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
    END PRC_LOAD_CE_COUNTRIES;
    
    
    ----------------------------------------------------------------------
    -- Load  CE_STATES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_STATES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_STATES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_STATES';
        L_TABLE              VARCHAR2(100) := 'CE_STATES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_STATES;

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
     WHEN  MATCHED THEN
        Update set 
        state_name=state_name, country_id=country_id,ta_update_dt=SYSDATE
        WHERE ( DECODE(CH.state_name, T.state_name, 0, 1) + DECODE(CH.country_id, T.country_id, 0, 1) ) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(state_id, state_srcid, state_source_system, state_source_entity,state_name, country_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_state_id.NEXTVAL,t.state_srcid, t.state_source_system, t.state_source_entity, t.state_name, t.country_id,SYSDATE,SYSDATE); 

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
    END PRC_LOAD_CE_STATES;
    
    
    ----------------------------------------------------------------------
    -- Load  CE_CITIES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_CITIES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CITIES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_CITIES';
        L_TABLE              VARCHAR2(100) := 'CE_CITIES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_CITIES;

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
    Where c3.state_source_system='personnel_sales'
    ) t
    
         ON (ch.city_srcid = t.city_srcid
         AND ch.city_source_system = t.city_source_system
         AND ch.city_source_entity = t.city_source_entity
         )
    WHEN  MATCHED THEN
        Update set 
        city=city, state_id=state_id,ta_update_dt=SYSDATE
        WHERE ( DECODE(CH.city, T.city, 0, 1) + DECODE(CH.state_id, T.state_id, 0, 1) ) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(city_id,city_srcid, city_source_system, city_source_entity,city, state_id,ta_update_dt, ta_insert_dt)
        VALUES(SEQ_CE_CITY_ID.nextval,t.city_srcid, t.city_source_system, t.city_source_entity,t.city, t.state_id,SYSDATE,SYSDATE);


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
            L_CONTEXT := 'LOADING CE_CITIES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_CITIES;

    ----------------------------------------------------------------------
    -- Load  CE_ADDRESSES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_ADDRESSES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_ADDRESSES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_ADDRESSES';
        L_TABLE              VARCHAR2(100) := 'CE_ADDRESSES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           CE_ADDRESSES;

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
      WHEN  MATCHED THEN
        Update set 
         street_address=street_address,postal_code=postal_code,city_id=city_id,ta_update_dt=SYSDATE
         WHERE ( DECODE(CH.street_address, T.street_address, 0, 1) + DECODE(CH.postal_code, T.postal_code, 0, 1) + DECODE(CH.city_id, T.city_id, 0, 1)) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(address_id,address_srcid, address_source_system, address_source_entity,street_address,postal_code,city_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_address_id.NEXTVAL,t.address_srcid, t.address_source_system, t.address_source_entity,t.street_address,t.postal_code,t.city_id,SYSDATE,SYSDATE);



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
            L_CONTEXT := 'LOADING CE_CITIES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_ADDRESSES;


   ----------------------------------------------------------------------
    -- Load  CE_STORES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_STORES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_STORES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_STORES';
        L_TABLE              VARCHAR2(100) := 'CE_STORES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           CE_STORES;

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
    WHEN  MATCHED THEN
        Update set 
         phone=phone,address_id=address_id,ta_update_dt=SYSDATE
         WHERE ( DECODE(CH.PHONE, T.PHONE, 0, 1) + DECODE(CH.address_id, T.address_id, 0, 1) ) > 
            0
         
    WHEN NOT MATCHED THEN 
         INSERT(store_id,store_srcid, store_source_system, store_source_entity,phone,address_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_store_id.NEXTVAL,t.store_srcid, t.store_source_system, t.store_source_entity,t.phone,t.address_id,SYSDATE,SYSDATE);


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
            L_CONTEXT := 'LOADING CE_CITIES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_STORES;
    
    ----------------------------------------------------------------------
    -- Load  CE_CUSTOMERS load from 2 sources withou dedublication because business guarantees that there is no equal customers in different systems
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_CUSTOMERS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CUSTOMERS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_CUSTOMERS';
        L_TABLE              VARCHAR2(100) := 'CE_CUSTOMERS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           CE_CUSTOMERS;

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
MERGE INTO ce_customers ch
    USING ((SELECT 
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
    SELECT 
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
     WHEN  MATCHED THEN
        Update set 
         first_name=first_name, last_name=last_name,company_name=company_name, company_number=company_number,phone=phone, gender=gender,year_of_birthday=year_of_birthday,  email=email, address=address, country_id=country_id,ta_update_dt=SYSDATE
         WHERE ( DECODE(CH.first_name, T.first_name, 0, 1) + DECODE(CH.last_name, T.last_name, 0, 1)
         + DECODE(CH.company_name, T.company_name, 0, 1)+ DECODE(CH.company_number, T.company_number, 0, 1)
         + DECODE(CH.phone, T.phone, 0, 1)+ DECODE(CH.gender, T.gender, 0, 1)
         + DECODE(CH.year_of_birthday, T.year_of_birthday, 0, 1)+ DECODE(CH.email, T.email, 0, 1)
         + DECODE(CH.address, T.address, 0, 1)+ DECODE(CH.country_id, T.country_id, 0, 1)
         ) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(customer_id, customer_srcid, customer_source_system, customer_source_entity,first_name, last_name,company_name, company_number,phone, gender,year_of_birthday,  email, address, country_id,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_customer_id.NEXTVAL,t.customer_srcid, t.customer_source_system, t.customer_source_entity,t.first_name, t.last_name,t.company_name, t.company_number,t.phone, t.gender,t.year_of_birthday, t.email, t.address, t.country_id,SYSDATE,SYSDATE);



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
            L_CONTEXT := 'LOADING CE_CITIES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_CUSTOMERS;
    
    
       ----------------------------------------------------------------------
    -- Load  CE_POSITIONS load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_POSITIONS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_POSITIONS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_POSITIONS';
        L_TABLE              VARCHAR2(100) := 'CE_POSITIONS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           CE_POSITIONS;

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
     WHEN  MATCHED THEN
        Update set 
         position=position,ta_update_dt=SYSDATE
         WHERE ch.position<>t.position
    WHEN NOT MATCHED THEN 
         INSERT(position_id,position_srcid, position_source_system, position_source_entity, position,ta_update_dt, ta_insert_dt)
        VALUES(seq_ce_position_id.NEXTVAL,t.position_srcid, t.position_source_system, t.position_source_entity, t.position,SYSDATE,SYSDATE); 



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
            L_CONTEXT := 'LOADING CE_POSITIONS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_POSITIONS;
    
 
    ----------------------------------------------------------------------
    -- Load  CE_EMPLOYEES load only from one sourse because business guarantees consistent of data in this tables in both sources
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_EMPLOYEES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_EMPLOYEES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_EMPLOYEES';
        L_TABLE              VARCHAR2(100) := 'CE_EMPLOYEES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
           CE_EMPLOYEES;

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
    WHEN  MATCHED THEN
        Update set 
         first_name=first_name, last_name=last_name, day_of_birthday=day_of_birthday,position_id=position_id, phone=phone, email=email, address=address, country_id=country_id,ta_update_dt=SYSDATE
         Where ( DECODE(CH.first_name, T.first_name, 0, 1) + DECODE(CH.last_name, T.last_name, 0, 1) +
         DECODE(CH.day_of_birthday, T.day_of_birthday, 0, 1) + DECODE(CH.position_id, T.position_id, 0, 1) +
         DECODE(CH.phone, T.phone, 0, 1) + DECODE(CH.email, T.email, 0, 1) +
         DECODE(CH.address, T.address, 0, 1) + DECODE(CH.country_id, T.country_id, 0, 1) 
         ) > 
            0
    WHEN NOT MATCHED THEN 
         INSERT(employee_id, employee_srcid, employee_source_system, employee_source_entity,first_name, last_name, day_of_birthday,position_id, phone, email, address, country_id,ta_update_dt, ta_insert_dt)
        VALUES(SEQ_CE_EMPLOYEE_ID.NEXTVAL,t.employee_srcid, t.employee_source_system, t.employee_source_entity,t.first_name, t.last_name, t.day_of_birthday,t.position_id, t.phone, t.email, t.address, t.country_id,SYSDATE,SYSDATE);



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
            L_CONTEXT := 'LOADING CE_EMPLOYEES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_EMPLOYEES;


END PKG_LOAD_3NF_TABLES;