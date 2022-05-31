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
                              LOADED_CHANNELS(CHANEL).CHANNEL_SRCID       AS CHANNEL_SRCID,
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
    
    

END PKG_LOAD_BL_DM_TABLES;