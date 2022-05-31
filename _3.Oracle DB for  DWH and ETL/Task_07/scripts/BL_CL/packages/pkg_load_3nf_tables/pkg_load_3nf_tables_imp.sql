CREATE OR REPLACE PACKAGE BODY PKG_LOAD_3NF_TABLES IS
    ----------------------------------------------------------------------
    -- Load CE_CHANNEL_CLASSES load only from one sourse, also can use manual load
    ----------------------------------------------------------------------

    PROCEDURE PRC_LOAD_CE_CHANNEL_CLASSES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CHANNEL_CLASSES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_CHANNEL_CLASSES';
        L_TABLE              VARCHAR2(100) := 'CE_CHANNEL_CLASSES';
        L_CONTEXT            VARCHAR2(100) := 'LOADING CE_CHANNEL_CLASSES: started';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_CHANNEL_CLASSES;

    BEGIN

--example of  Explicit Cursor 
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               NULL, SYSDATE, 'START', NULL);

        L_CONTEXT := 'count of row before';
        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_BEFORE, SYSDATE, 'START', NULL);

        CLOSE CH_CL;
-- 
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
        L_CONTEXT := 'LOADING CE_CHANNEL_CLASSES: merge statement';
        L_CONTEXT := 'LOADING CE_PROMOTION_CATEGORIES: merge statement';
        LOGGING(2, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               L_ROWS, SYSDATE, 'PROCEED', NULL);

        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        L_CONTEXT := 'count of row after';
        LOGGING(3, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL);

        CLOSE CH_CL;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Data logging
            L_CONTEXT := 'LOADING CE_CHANNEL_CLASSES: exseption';
            LOGGING(-1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
                   NULL, SYSDATE, 'ROLLBACK', SQLCODE);

            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_CHANNEL_CLASSES;

  
    ----------------------------------------------------------------------
    -- Load CE_CHANNELS
    ----------------------------------------------------------------------

    PROCEDURE PRC_LOAD_CE_CHANNELS IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;
        --!!!!!!!!!!!later
    END PRC_LOAD_CE_CHANNELS;
     ----------------------------------------------------------------------
    -- Load CE_PROMOTION_CATEGORIES
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_PROMOTION_CATEGORIES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CHANNEL_CLASSES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_PROMOTION_CATEGORIES';
        L_TABLE              VARCHAR2(100) := 'CE_PROMOTION_CATEGORIES';
        L_CONTEXT            VARCHAR2(100) := 'LOADING CE_PROMOTION_CATEGORIES: started';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_PROMOTION_CATEGORIES;

    BEGIN

--example of  Explicit Cursor 
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               NULL, SYSDATE, 'START', NULL);

        L_CONTEXT := 'count of row before';
        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_BEFORE, SYSDATE, 'START', NULL);

        CLOSE CH_CL;
-- 
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
            CH.PROMOTION_CATEGORY <> T.PROMOTION_CATEGORY
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
        L_CONTEXT := 'LOADING CE_PROMOTION_CATEGORIES: merge statement';
        LOGGING(2, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               L_ROWS, SYSDATE, 'PROCEED', NULL);

        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        L_CONTEXT := 'count of row after';
        LOGGING(3, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL);

        CLOSE CH_CL;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Data logging
            L_CONTEXT := 'LOADING CE_PROMOTION_CATEGORIES: exseption';
            LOGGING(-1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
                   NULL, SYSDATE, 'ROLLBACK', SQLCODE);

            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_PROMOTION_CATEGORIES;
    ----------------------------------------------------------------------
    -- Load CE_PROMOTIONS_SCD --!!!!LATER
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_PROMOTIONS_SCD IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
    --later
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_PROMOTIONS_SCD;
    ----------------------------------------------------------------------
    -- Load CE_BRANDS
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_BRANDS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CHANNEL_CLASSES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_BRANDS';
        L_TABLE              VARCHAR2(100) := 'CE_BRANDS';
        L_CONTEXT            VARCHAR2(100) := 'LOADING CE_BRANDS: started';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_BRANDS;

    BEGIN

--example of  Explicit Cursor 
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               NULL, SYSDATE, 'START', NULL);

        L_CONTEXT := 'count of row before';
        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_BEFORE, SYSDATE, 'START', NULL);

        CLOSE CH_CL;
-- 
        MERGE INTO CE_BRANDS CH
        USING (
                  SELECT DISTINCT
                      BRAND_ID               AS PRODUCT_BRAND_SRCID,
                      'personnel_sales'      AS PRODUCT_BRAND_SOURCE_SYSTEM,
                      'src_products'         AS PRODUCT_BRAND_SOURCE_ENTITY,
                      COALESCE(BRAND, 'N/A') AS PRODUCT_BRAND
                  FROM
                      SA_SOURCE_SYSTEM_1.SRC_PRODUCTS
              )
        T ON ( CH.PRODUCT_BRAND_SRCID = T.PRODUCT_BRAND_SRCID
               AND CH.PRODUCT_BRAND_SOURCE_SYSTEM = T.PRODUCT_BRAND_SOURCE_SYSTEM
               AND CH.PRODUCT_BRAND_SOURCE_ENTITY = T.PRODUCT_BRAND_SOURCE_ENTITY )
        WHEN MATCHED THEN UPDATE
        SET PRODUCT_BRAND = PRODUCT_BRAND,
            TA_UPDATE_DT = SYSDATE
        WHERE
            CH.PRODUCT_BRAND <> T.PRODUCT_BRAND
        WHEN NOT MATCHED THEN
        INSERT (
            PRODUCT_BRAND_ID,
            PRODUCT_BRAND_SRCID,
            PRODUCT_BRAND_SOURCE_SYSTEM,
            PRODUCT_BRAND_SOURCE_ENTITY,
            PRODUCT_BRAND,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( SEQ_CE_BRAND_ID.NEXTVAL,
            T.PRODUCT_BRAND_SRCID,
            T.PRODUCT_BRAND_SOURCE_SYSTEM,
            T.PRODUCT_BRAND_SOURCE_ENTITY,
            T.PRODUCT_BRAND,
            SYSDATE,
            SYSDATE );

        L_ROWS := SQL%ROWCOUNT;
        L_CONTEXT := 'LOADING CE_PRODUCT_BRANDS: merge statement';
        LOGGING(2, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               L_ROWS, SYSDATE, 'PROCEED', NULL);

        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        L_CONTEXT := 'count of row after';
        LOGGING(3, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL);

        CLOSE CH_CL;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Data logging
            L_CONTEXT := 'LOADING CE_CHANNEL_CLASSES: exseption';
            LOGGING(-1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
                   NULL, SYSDATE, 'ROLLBACK', SQLCODE);

            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_BRANDS;
    ----------------------------------------------------------------------
    -- Load CE_PRODUCT_TYPES
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_PRODUCT_TYPES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            CE_CHANNEL_CLASSES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_PRODUCT_TYPES';
        L_TABLE              VARCHAR2(100) := 'CE_PRODUCT_TYPES';
        L_CONTEXT            VARCHAR2(100) := 'LOADING CE_PRODUCT_TYPES: started';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            CE_PRODUCT_TYPES;

    BEGIN

--example of  Explicit Cursor 
        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_BEFORE := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               NULL, SYSDATE, 'START', NULL);

        L_CONTEXT := 'count of row before';
        LOGGING(1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_BEFORE, SYSDATE, 'START', NULL);

        CLOSE CH_CL;
-- 
        MERGE INTO CE_PRODUCT_TYPES CH
        USING (
                  SELECT DISTINCT
                      PRODUCT_TYPE_ID               AS PRODUCT_TYPE_SRCID,
                      'personnel_sales'             AS PRODUCT_TYPE_SOURCE_SYSTEM,
                      'src_products'                AS PRODUCT_TYPE_SOURCE_ENTITY,
                      COALESCE(PRODUCT_TYPE, 'N/A') AS PRODUCT_TYPE
                  FROM
                      SA_SOURCE_SYSTEM_1.SRC_PRODUCTS
              )
        T ON ( CH.PRODUCT_TYPE_SRCID = T.PRODUCT_TYPE_SRCID
               AND CH.PRODUCT_TYPE_SOURCE_SYSTEM = T.PRODUCT_TYPE_SOURCE_SYSTEM
               AND CH.PRODUCT_TYPE_SOURCE_ENTITY = T.PRODUCT_TYPE_SOURCE_ENTITY )
        WHEN MATCHED THEN UPDATE
        SET PRODUCT_TYPE = PRODUCT_TYPE,
            TA_UPDATE_DT = SYSDATE
        WHERE
            CH.PRODUCT_TYPE <> T.PRODUCT_TYPE
        WHEN NOT MATCHED THEN
        INSERT (
            PRODUCT_TYPE_ID,
            PRODUCT_TYPE_SRCID,
            PRODUCT_TYPE_SOURCE_SYSTEM,
            PRODUCT_TYPE_SOURCE_ENTITY,
            PRODUCT_TYPE,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( SEQ_CE_PRODUCT_TYPE_ID.NEXTVAL,
            T.PRODUCT_TYPE_SRCID,
            T.PRODUCT_TYPE_SOURCE_SYSTEM,
            T.PRODUCT_TYPE_SOURCE_ENTITY,
            T.PRODUCT_TYPE,
            SYSDATE,
            SYSDATE );

        L_ROWS := SQL%ROWCOUNT;
        L_CONTEXT := 'LOADING CE_PRODUCT_TYPES: merge statement';
        LOGGING(2, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               L_ROWS, SYSDATE, 'PROCEED', NULL);

        OPEN CH_CL;
        LOOP
            FETCH CH_CL INTO ROW_CH_CL;
            COUNT_OF_ROWS_AFTER := CH_CL%ROWCOUNT;
            IF CH_CL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;

        L_CONTEXT := 'count of row after';
        LOGGING(3, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
               COUNT_OF_ROWS_AFTER, SYSDATE, 'END', NULL);

        CLOSE CH_CL;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Data logging
            L_CONTEXT := 'LOADING CE_PRODUCT_TYPES: exseption';
            LOGGING(-1, L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT,
                   NULL, SYSDATE, 'ROLLBACK', SQLCODE);

            ROLLBACK;
            RAISE;
    END PRC_LOAD_CE_PRODUCT_TYPES;
    ----------------------------------------------------------------------
    -- Load CE_PRODUCTS
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_PRODUCTS IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
    --later
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_PRODUCTS;
    ----------------------------------------------------------------------
    -- Load CE_COUNTRIES
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_COUNTRIES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_COUNTRIES;
    ----------------------------------------------------------------------
    -- Load CE_STATES
    ----------------------------------------------------------------------  
    PROCEDURE PRC_LOAD_CE_STATES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_STATES;
    ----------------------------------------------------------------------
    -- Load CE__CITIES
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_CITIES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_CITIES;
    ----------------------------------------------------------------------
    -- Load CE_ADDRESSES
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_ADDRESSES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_ADDRESSES;
    ----------------------------------------------------------------------
    -- Load CE_STORES
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_STORES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_STORES;
    ----------------------------------------------------------------------
    -- Load CE_USTOMERS
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_CUSTOMERS IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_CUSTOMERS;
    ----------------------------------------------------------------------
    -- Load CE_POSITIONS
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_POSITIONS IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_POSITIONS;
    ----------------------------------------------------------------------
    -- Load CE_EMPLOYEES
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_EMPLOYEES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_EMPLOYEES;
    ----------------------------------------------------------------------
    -- Load CE_SALES
    ----------------------------------------------------------------------
    PROCEDURE PRC_LOAD_CE_SALES IS
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO COUNT_OF_ROWS_BEFORE
        FROM
            CE_CHANNELS;

    END PRC_LOAD_CE_SALES;

END PKG_LOAD_3NF_TABLES;