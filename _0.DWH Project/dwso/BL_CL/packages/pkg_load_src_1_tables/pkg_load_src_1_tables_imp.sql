CREATE OR REPLACE PACKAGE BODY PKG_LOAD_SRC_1_TABLES IS
    ----------------------------------------------------------------------
    -- Load SRC_CHANNELS 
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_CHANNELS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_CHANNELS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_CHANNELS';
        L_TABLE              VARCHAR2(100) := 'SRC_CHANNELS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_CHANNELS;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.SRC_CHANNELS CH
        USING (
                    SELECT DISTINCT 
                    channel_id  ,
                    channel_desc ,
                    channel_class  ,
                    channel_class_id  ,
                    SYSDATE as ta_update_dt,
                     SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.CHANNELS
              )
        T ON ( CH.CHANNEL_id= T.CHANNEL_ID )
        WHEN MATCHED THEN UPDATE
        SET 
        CHANNEL_desc = t.CHANNEL_desc,
        CHANNEL_CLASS = t.CHANNEL_CLASS,
        CHANNEL_CLASS_id = t.CHANNEL_CLASS_id,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.CHANNEL_desc, T.CHANNEL_desc, 0, 1)
            +DECODE(CH.CHANNEL_CLASS, T.CHANNEL_CLASS, 0, 1)
            +DECODE(CH.CHANNEL_CLASS_id, T.CHANNEL_CLASS_id, 0, 1)) >
            0
        WHEN NOT MATCHED THEN
        INSERT (
            CHANNEL_ID,
            CHANNEL_DESC,
            CHANNEL_CLASS,
            CHANNEL_CLASS_ID,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( 
            T.CHANNEL_ID,
            T.CHANNEL_DESC,
            T.CHANNEL_CLASS,
            T.CHANNEL_CLASS_ID,
            T.TA_UPDATE_DT,
            T.TA_INSERT_DT );

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
            L_CONTEXT := 'LOADING SRC_CHANNELS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_CHANNELS;
    
   ----------------------------------------------------------------------
    -- Load SRC_COUNTRIES 
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_Countries IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_COUNTRIES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_COUNTRIES';
        L_TABLE              VARCHAR2(100) := 'SRC_COUNTRIES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_COUNTRIES;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.src_countries CH
        USING (
                    SELECT distinct 
       country_id ,
       country_iso_code,
       country_name,
       country_subregion,
       country_subregion_id ,
       country_region,
       country_region_id ,
       country_total ,
       country_total_id ,
       country_name_hist,
       SYSDATE as ta_update_dt,
       SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.COUNTRIES
              )
        T ON ( CH.country_id= T.country_id )
        WHEN MATCHED THEN UPDATE
        SET 
       country_iso_code=t.country_iso_code,
       country_name=t.country_name,
       country_subregion=t.country_subregion,
       country_subregion_id =t.country_subregion_id,
       country_region=t.country_region,
       country_region_id =t.country_region_id,
       country_total =t.country_total,
       country_total_id =t.country_total_id,
       country_name_hist= t.country_name_hist,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.country_iso_code, T.country_iso_code, 0, 1)
            +DECODE(CH.country_name, T.country_name, 0, 1)
            +DECODE(CH.country_subregion, T.country_subregion, 0, 1)
            +DECODE(CH.country_subregion_id, T.country_subregion_id, 0, 1)
            +DECODE(CH.country_region, T.country_region, 0, 1)
            +DECODE(CH.country_region_id, T.country_region_id, 0, 1)
            +DECODE(CH.country_total, T.country_total, 0, 1)
            +DECODE(CH.country_total_id, T.country_total_id, 0, 1)) >
            0
        WHEN NOT MATCHED THEN
        INSERT (
               country_id ,
               country_iso_code,
               country_name,
               country_subregion,
               country_subregion_id ,
               country_region,
               country_region_id ,
               country_total ,
               country_total_id ,
               country_name_hist,
               TA_UPDATE_DT,
               TA_INSERT_DT )
        VALUES
            ( 
               t.country_id ,
               t.country_iso_code,
               t.country_name,
               t.country_subregion,
               t.country_subregion_id ,
               t.country_region,
               t.country_region_id ,
               t.country_total ,
               t.country_total_id ,
               t.country_name_hist,
               t.TA_UPDATE_DT,
               t.TA_INSERT_DT);

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
            L_CONTEXT := 'LOADING SRC_COUNTRIES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_Countries;
    
    
   ----------------------------------------------------------------------
    -- Load SRC_CUSTOMERS
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_CUSTOMERS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_CUSTOMERS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_CUSTOMERS';
        L_TABLE              VARCHAR2(100) := 'SRC_CUSTOMERS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_CUSTOMERS;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.src_customers CH
        USING (
                    SELECT distinct 
          customer_id ,
          customer_first_name ,
          customer_last_name ,
          customer_gender ,
          customer_year_of_birth ,
          customer_address ,
          customer_country_id ,
          customer_iso_code ,
          customer_country_name ,
          customer_phone ,
          customer_email,
       SYSDATE as ta_update_dt,
       SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.customers
              )
        T ON ( CH.customer_id= T.customer_id )
        WHEN MATCHED THEN UPDATE
        SET 
       customer_first_name=t.customer_first_name,
       customer_last_name=t.customer_last_name,
       customer_gender=t.customer_gender,
       customer_year_of_birth =t.customer_year_of_birth,
       customer_address=t.customer_address,
       customer_country_id =t.customer_country_id,
       customer_iso_code =t.customer_iso_code,
       customer_country_name =t.customer_country_name,
       customer_phone= t.customer_phone,
       customer_email= t.customer_email,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.customer_first_name, T.customer_first_name, 0, 1)
            +DECODE(CH.customer_last_name, T.customer_last_name, 0, 1)
            +DECODE(CH.customer_gender, T.customer_gender, 0, 1)
            +DECODE(CH.customer_year_of_birth, T.customer_year_of_birth, 0, 1)
            +DECODE(CH.customer_address, T.customer_address, 0, 1)
            +DECODE(CH.customer_country_id, T.customer_country_id, 0, 1)
            +DECODE(CH.customer_iso_code, T.customer_iso_code, 0, 1)
            +DECODE(CH.customer_country_name, T.customer_country_name, 0, 1)
            +DECODE(CH.customer_phone, T.customer_phone, 0, 1)
            +DECODE(CH.customer_email, T.customer_email, 0, 1)  ) >
            0
        WHEN NOT MATCHED THEN
        INSERT (
               customer_id ,
              customer_first_name ,
              customer_last_name ,
              customer_gender ,
              customer_year_of_birth ,
              customer_address ,
              customer_country_id ,
              customer_iso_code ,
              customer_country_name ,
              customer_phone ,
              customer_email,
               TA_UPDATE_DT,
               TA_INSERT_DT )
        VALUES
            ( 
               t.customer_id ,
              t.customer_first_name ,
              t.customer_last_name ,
              t.customer_gender ,
              t.customer_year_of_birth ,
              t.customer_address ,
              t.customer_country_id ,
              t.customer_iso_code ,
              t.customer_country_name ,
              t.customer_phone ,
              t.customer_email,
               t.TA_UPDATE_DT,
               t.TA_INSERT_DT);

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
            L_CONTEXT := 'LOADING SRC_CUSTOMERS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_CUSTOMERS;
    
    
    
    ----------------------------------------------------------------------
    -- Load SRC_EMPLOYEES
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_EMPLOYEES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_EMPLOYEES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_EMPLOYEES';
        L_TABLE              VARCHAR2(100) := 'SRC_EMPLOYEES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_EMPLOYEES;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.src_EMPLOYEES CH
        USING (
        SELECT DISTINCT
              employee_id ,
              employee_name ,
              employee_last_name ,
              employee_birthday ,
              employee_position_id ,
              employee_position ,
              employee_phone  ,
              employee_email ,
              employee_address ,
              employee_cointry ,
              SYSDATE as ta_update_dt,
              SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.EMPLOYEES
              )
        T ON ( CH.employee_id= T.employee_id )
        WHEN MATCHED THEN UPDATE
        SET 
       employee_name=t.employee_name,
       employee_last_name=t.employee_last_name,
       employee_birthday=t.employee_birthday,
       employee_position_id =t.employee_position_id,
       employee_position=t.employee_position,
       employee_phone =t.employee_phone,
       employee_email =t.employee_email,
       employee_address =t.employee_address,
       EMPLOYEE_COUNTRY = t.employee_cointry ,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.employee_name, T.employee_name, 0, 1)
            +DECODE(CH.employee_last_name, T.employee_last_name, 0, 1)
            +DECODE(CH.employee_birthday, T.employee_birthday, 0, 1)
            +DECODE(CH.employee_position_id, T.employee_position_id, 0, 1)
            +DECODE(CH.employee_position, T.employee_position, 0, 1)
            +DECODE(CH.employee_phone, T.employee_phone, 0, 1)
            +DECODE(CH.employee_email, T.employee_email, 0, 1)
            +DECODE(CH.employee_address, T.employee_address, 0, 1)
            +DECODE(CH.employee_country, T.employee_cointry, 0, 1)
           ) >
            0
        WHEN NOT MATCHED THEN
        INSERT (
              employee_id ,
              employee_name ,
              employee_last_name ,
              employee_birthday ,
              employee_position_id ,
              employee_position ,
              employee_phone  ,
              employee_email ,
              employee_address ,
              employee_country,
              TA_UPDATE_DT,
              TA_INSERT_DT )
        VALUES
            ( 
              t.employee_id ,
              t.employee_name ,
              t.employee_last_name ,
              t.employee_birthday ,
              t.employee_position_id ,
              t.employee_position ,
              t.employee_phone  ,
              t.employee_email ,
              t.employee_address ,
              t.employee_cointry,
              t.TA_UPDATE_DT,
              t.TA_INSERT_DT);

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
            L_CONTEXT := 'LOADING SRC_EMPLOYEES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_EMPLOYEES;
    
    
     ----------------------------------------------------------------------
    -- Load SRC_PRODUCTS
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_PRODUCTS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_PRODUCTS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_PRODUCTS';
        L_TABLE              VARCHAR2(100) := 'SRC_PRODUCTS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_PRODUCTS;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.src_PRODUCTS CH
        USING (
        SELECT DISTINCT
              product_id  ,
             product_name,
             brand_id ,
             brand ,
             product_type_id ,
             product_type ,
             unit_cost ,
             unit_price ,
              SYSDATE as ta_update_dt,
              SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.PRODUCTS
              )
        T ON ( CH.PRODUCT_id= T.PRODUCT_id )
        WHEN MATCHED THEN UPDATE
        SET 
       product_name=t.product_name,
       brand_id=t.brand_id,
       brand=t.brand,
       product_type_id =t.product_type_id,
       product_type=t.product_type,
       unit_cost =t.unit_cost,
       unit_price =t.unit_price,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.product_name, T.product_name, 0, 1)
            +DECODE(CH.brand_id, T.brand_id, 0, 1)
            +DECODE(CH.brand, T.brand, 0, 1)
            +DECODE(CH.product_type_id, T.product_type_id, 0, 1)
            +DECODE(CH.product_type, T.product_type, 0, 1) ) > 0
            OR CH.UNIT_COST<>T.UNIT_COST OR CH.UNIT_PRICE<>T.UNIT_PRICE
        WHEN NOT MATCHED THEN
        INSERT (
              product_id  ,
             product_name ,
             brand_id ,
             brand ,
             product_type_id ,
             product_type ,
             unit_cost ,
             unit_price ,
              TA_UPDATE_DT,
              TA_INSERT_DT )
        VALUES
            ( 
              t.product_id  ,
             t.product_name ,
             t.brand_id ,
             t.brand ,
             t.product_type_id ,
             t.product_type ,
             t.unit_cost ,
             t.unit_price ,
              t.TA_UPDATE_DT,
              T.TA_INSERT_DT);

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
            L_CONTEXT := 'LOADING SRC_PRODUCTS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_PRODUCTS;
    


     ----------------------------------------------------------------------
    -- Load SRC_PROMOTIONS
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_PROMOTIONS IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_PROMOTIONS%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_PROMOTIONS';
        L_TABLE              VARCHAR2(100) := 'SRC_PROMOTIONS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_PROMOTIONS;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.src_PROMOTIONS CH
        USING (
        SELECT DISTINCT
              promo_id ,
             promo_name ,
             promo_category ,
             promo_category_id ,
             promo_cost ,
             promo_begin_date ,
             promo_end_date ,
              SYSDATE as ta_update_dt,
              SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.PROMOTIONS
              )
        T ON ( CH.promo_id= T.promo_id)
        WHEN MATCHED THEN UPDATE
        SET 
       promo_name=t.promo_name,
       promo_category=t.promo_category,
       promo_category_id=t.promo_category_id,
       promo_cost =t.promo_cost,
       promo_begin_date =t.promo_begin_date,
       promo_end_date =t.promo_end_date,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.promo_name, T.promo_name, 0, 1)
            +DECODE(CH.promo_category, T.promo_category, 0, 1)
            +DECODE(CH.promo_category_id, T.promo_category_id, 0, 1)
            +DECODE(CH.promo_cost, T.promo_cost, 0, 1)
            +DECODE(CH.promo_begin_date, T.promo_begin_date, 0, 1) 
            +DECODE(CH.promo_end_date, T.promo_end_date, 0, 1)) > 0

        WHEN NOT MATCHED THEN
        INSERT (
              promo_id ,
             promo_name ,
             promo_category ,
             promo_category_id ,
             promo_cost ,
             promo_begin_date ,
             promo_end_date,
              TA_UPDATE_DT,
              TA_INSERT_DT )
        VALUES
            ( 
             T.promo_id ,
             T.promo_name ,
             T.promo_category ,
             T.promo_category_id ,
             T.promo_cost ,
             T.promo_begin_date ,
             T.promo_end_date,
              T.TA_UPDATE_DT,
              T.TA_INSERT_DT);

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
            L_CONTEXT := 'LOADING SRC_PROMOTIONS: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_PROMOTIONS;
    
    
        ----------------------------------------------------------------------
    -- Load SRC_STORES
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_STORES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_STORES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_STORES';
        L_TABLE              VARCHAR2(100) := 'SRC_PROMOTIONS';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_STORES;

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

        MERGE INTO SA_SOURCE_SYSTEM_1.src_STORES CH
        USING (
        SELECT DISTINCT
                 store_id  ,
                 store_postal_code ,
                 store_city ,
                 store_city_id ,
                 store_state ,
                 store_state_id ,
                 store_country ,
                 store_country_id ,
                 store_phone ,
                 store_street_address_id,
                 store_street_address ,
                 SYSDATE as ta_update_dt,
                 SYSDATE as ta_insert_dt
FROM SA_SOURCE_SYSTEM_1.STORES
              )
        T ON ( CH.STORE_id= T.STORE_id)
        WHEN MATCHED THEN UPDATE
        SET 
       store_postal_code=t.store_postal_code,
       store_city=t.store_city,
       store_city_id=t.store_city_id,
       store_state =t.store_state,
       store_state_id =t.store_state_id,
       store_country=t.store_country,
       store_country_id=t.store_country_id,
       store_phone=t.store_phone,
       store_street_address_id=t.store_street_address_id,
       store_street_address=t.store_street_address,
            TA_UPDATE_DT = SYSDATE
        WHERE
            ( DECODE(CH.store_postal_code, T.store_postal_code, 0, 1)
            +DECODE(CH.store_city, T.store_city, 0, 1)
            +DECODE(CH.store_city_id, T.store_city_id, 0, 1)
            +DECODE(CH.store_state, T.store_state, 0, 1)
            +DECODE(CH.store_state_id, T.store_state_id, 0, 1) 
            +DECODE(CH.store_country, T.store_country, 0, 1)
            +DECODE(CH.store_country_id, T.store_country_id, 0, 1)
            +DECODE(CH.store_phone, T.store_phone, 0, 1)
            +DECODE(CH.store_street_address_id, T.store_street_address_id, 0, 1) 
            +DECODE(CH.store_street_address, T.store_street_address, 0, 1)
            
            ) > 0

        WHEN NOT MATCHED THEN
        INSERT (
             store_id  ,
             store_postal_code ,
             store_city ,
             store_city_id ,
             store_state ,
             store_state_id ,
             store_country ,
             store_country_id ,
             store_phone ,
             store_street_address_id, 
             store_street_address,
             TA_UPDATE_DT,
             TA_INSERT_DT )
        VALUES
            ( 
             T.store_id  ,
             T.store_postal_code ,
             T.store_city ,
             T.store_city_id ,
             T.store_state ,
             T.store_state_id ,
             T.store_country ,
             T.store_country_id ,
             T.store_phone ,
             T.store_street_address_id, 
             T.store_street_address,
             T.TA_UPDATE_DT,
             T.TA_INSERT_DT);

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
            L_CONTEXT := 'LOADING SRC_STORES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_STORES;


        ----------------------------------------------------------------------
    -- Load SRC_PROMOTIONS
    ----------------------------------------------------------------------
    PROCEDURE   PRC_LOAD_SRC_1_SALES IS

        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER;
        ROW_CH_CL            SA_SOURCE_SYSTEM_1.SRC_SALES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_SRC_1_SALES';
        L_TABLE              VARCHAR2(100) := 'SRC_SALES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
            SA_SOURCE_SYSTEM_1.SRC_SALES;

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

---------insert logic-----------------------------------------------------------
--EXECUTE IMMEDIATE 'truncate table SA_SOURCE_SYSTEM_1.SRC_SALES';



 MERGE INTO SA_SOURCE_SYSTEM_1.src_sales CH
        USING (
        SELECT 
 product_id  as product_id,
 customer_id  as customer_id,
 channel_id  as channel_id,
 promo_id as promo_id,
 employee_id as employee_id ,
 store_id as store_id,
 quantity_sold as quantity_sold ,
 time_id as time_id ,
SYSDATE as TA_UPDATE_DT,
SYSDATE as TA_INSERT_DT
FROM SA_SOURCE_SYSTEM_1.SALES
              )
        T ON ( CH.product_id= T.product_id
        and CH.product_id= T.product_id
        and CH.customer_id= T.customer_id
        and CH.channel_id= T.channel_id
        and CH.promo_id= T.promo_id
        and CH.employee_id= T.employee_id
        and CH.store_id= T.store_id
        and CH.time_id= T.time_id
        )

        WHEN NOT MATCHED THEN
        INSERT (
            product_id ,
             customer_id ,
             channel_id ,
             promo_id ,
             employee_id ,
             store_id ,
             quantity_sold ,
             time_id,
            TA_UPDATE_DT,
            TA_INSERT_DT )
        VALUES
            ( 
 t.product_id ,
 t.customer_id ,
 t.channel_id ,
 t.promo_id ,
 t.employee_id ,
 t.store_id ,
 t.quantity_sold ,
 t.time_id ,
t.TA_UPDATE_DT,
t.TA_INSERT_DT);



/*

 INSERT INTO SA_SOURCE_SYSTEM_1.SRC_SALES (
 product_id ,
 customer_id ,
 channel_id ,
 promo_id ,
 employee_id ,
 store_id ,
 quantity_sold ,
 time_id,
TA_UPDATE_DT,
TA_INSERT_DT
)
(SELECT 
 product_id ,
 customer_id ,
 channel_id ,
 promo_id ,
 employee_id ,
 store_id ,
 quantity_sold ,
 time_id ,
    SYSDATE,SYSDATE
FROM SA_SOURCE_SYSTEM_1.SALES);*/
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
            L_CONTEXT := 'LOADING SRC_SALES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
    END   PRC_LOAD_SRC_1_SALES;
END PKG_LOAD_SRC_1_TABLES;