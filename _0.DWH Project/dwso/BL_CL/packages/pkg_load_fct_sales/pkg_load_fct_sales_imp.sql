   
   CREATE OR REPLACE PACKAGE BODY pkg_load_fct_sales IS
   ----------------------------------------------------------------------
    -- Load CE_SALES 
    ----------------------------------------------------------------------
    PROCEDURE prc_load_ce_sales(
        p_start_dt          DATE,
        p_end_dt            DATE)
 IS
        partition_name      VARCHAR2(50);
        count_of_loops      NUMBER;
        start_dt            DATE;
        end_dt              DATE;
        p_last_update_dt DATE;
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER:=0;
        ROW_CH_CL            CE_SALES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_CE_SALES';
        L_TABLE              VARCHAR2(100) := ' CE_SALES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
             CE_SALES;

    BEGIN
    SELECT 
            previous_loaded_date
        INTO 
            p_last_update_dt 
        FROM 
            BL_CL.PRM_MTA_INCREMENTAL_LOAD 
        WHERE
            sa_table_name = 'SRC_SALES';
    
select  ceil(months_between(p_end_dt,p_start_dt))  into count_of_loops from dual;
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

--------------------Main logic--------------------------------------------------

FOR counter IN 0..count_of_loops LOOP

            -- Truncate wrk_sales
            EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.wrk_ce_sales';

            start_dt := add_months(p_start_dt, counter);
            end_dt := add_months(p_start_dt, counter + 1);

            -- Form partition name
            partition_name := 'ce_sales_' ||
                extract(year from start_dt) || '_' ||
                lpad(extract(month from start_dt), 2, '0');

            -- Insert into wrk_sales
            
            Insert
    INTO bl_cl.wrk_ce_sales (

        sale_source_system,
        sale_source_entity,
        product_id,
        date_id,
        promotion_id,
        channel_id,
        store_id,
        employee_id,
        customer_id,
        sale_cost,
        sale_price,
        sale_quantity,
        ta_update_dt,
        ta_insert_dt
    )
   
    SElect
    'pesonnel_sales' AS sale_source_system, 
    'src_sales' AS sale_source_entity, 
    COALESCE(p.product_id,-1) as product_id,
    COALESCE((TO_DATE(c.time_id ,'yyyy-mm-dd')),(TO_DATE('9999-12-31' ,'yyyy-mm-dd'))) as date_id,
    COALESCE(p2.promotion_id,-1) as promotion_id,
    COALESCE(c3.channel_id,-1) as channel_id,
    COALESCE(s.store_id,-1) as store_id,
    COALESCE(e.employee_id,-1) as employee_id ,
    COALESCE(c2.customer_id,-1) as customer_id,
    p.unit_cost*c.quantity_sold as sale_cost,
    p.unit_price*c.quantity_sold as sale_price,
    c.quantity_sold as sale_quantity,
    SYSDATE as TA_UPDATE_DT ,
    SYSDATE  as TA_INSERT_DT
            FROM  SA_SOURCE_SYSTEM_1.src_sales c
    LEFT JOIN bl_3nf.ce_products p
    ON c.product_id=p.product_srcid
    and p.product_source_system='personnel_sales'
    LEFT JOIN bl_3nf.ce_customers c2
    ON c.customer_id=c2.customer_srcid
    and c2.customer_source_system='personnel_sales'
    Left Join bl_cl.map_channels mc
    on mc.channel_srcid=c.channel_id
    and mc.channel_source_system='personnel_sales'
    LEFT JOIN bl_3nf.ce_channels c3
    ON mc.channel_id=c3.channel_srcid
    and c3.channel_source_system='mapping'
    LEFT JOIN bl_3nf.ce_promotions_scd p2
    ON c.promo_id=p2.promotion_srcid
    and p2.promotion_source_system='personnel_sales'
    and p2.start_dt<=TO_DATE(c.time_id ,'yyyy-mm-dd') and p2.end_dt>TO_DATE(c.time_id ,'yyyy-mm-dd')
    LEFT JOIN bl_3nf.ce_employees e
    ON c.employee_id=e.employee_srcid
    and e.employee_source_system='personnel_sales'
    LEFT JOIN bl_3nf.ce_stores s
    ON c.store_id=s.store_srcid
    and s.store_source_system='personnel_sales'
    WHERE TO_DATE(c.time_id ,'yyyy-mm-dd') >= add_months(p_start_dt, counter)
            AND TO_DATE(c.time_id ,'yyyy-mm-dd') < add_months(p_start_dt, counter + 1)
  and c.ta_update_dt > p_last_update_dt
            UNION 
            SElect 
    'company_sales' AS sale_source_system, 
    'src_sales' AS sale_source_entity, 
    COALESCE(p.product_id,-1) as product_id,
    COALESCE((TO_DATE(c.time_id ,'yyyy-mm-dd')),(TO_DATE('9999-12-31' ,'yyyy-mm-dd'))) as date_id,
    COALESCE(p2.promotion_id,-1) as promotion_id,
    COALESCE(c3.channel_id,-1) as channel_id,
    COALESCE(s.store_id,-1) as store_id,
    COALESCE(e.employee_id,-1) as employee_id ,
    COALESCE(c2.customer_id,-1) as customer_id,
    p.unit_cost*c.quantity_sold as sale_cost,
    p.unit_price*c.quantity_sold as sale_price,
    c.quantity_sold as sale_quantity,
    SYSDATE as TA_UPDATE_DT ,
    SYSDATE  as TA_INSERT_DT
            FROM  SA_SOURCE_SYSTEM_2.src_sales c
    LEFT JOIN bl_3nf.ce_products p
    ON c.product_id=p.product_srcid
    and p.product_source_system='personnel_sales'
    LEFT JOIN bl_3nf.ce_customers c2
    ON c.customer_id=c2.customer_srcid
    and c2.customer_source_system='company_sales'
    Left Join bl_cl.map_channels mc
    on mc.channel_srcid=c.channel_id
    and mc.channel_source_system='company_sales'
    LEFT JOIN bl_3nf.ce_channels c3
    ON mc.channel_id=c3.channel_srcid
    and c3.channel_source_system='mapping'
    LEFT JOIN bl_3nf.ce_promotions_scd p2
    ON c.promo_id=p2.promotion_srcid
    and p2.promotion_source_system='personnel_sales'
    and p2.start_dt<=TO_DATE(c.time_id ,'yyyy-mm-dd') and p2.end_dt>TO_DATE(c.time_id ,'yyyy-mm-dd')
    LEFT JOIN bl_3nf.ce_employees e
    ON c.employee_id=e.employee_srcid
    and e.employee_source_system='personnel sales'
    LEFT JOIN bl_3nf.ce_stores s
    ON c.store_id=s.store_srcid
    and s.store_source_system='personnel_sales'
            WHERE TO_DATE(c.time_id ,'yyyy-mm-dd') >= add_months(p_start_dt, counter)
            AND TO_DATE(c.time_id ,'yyyy-mm-dd') < add_months(p_start_dt, counter + 1)
            and c.ta_update_dt > p_last_update_dt
            ;
             L_ROWS := L_ROWS + SQL%ROWCOUNT;

            COMMIT;

            -- Exchange partitions
            EXECUTE IMMEDIATE
                'ALTER TABLE bl_3nf.ce_sales
                EXCHANGE PARTITION ' || partition_name ||
                ' WITH TABLE bl_cl.wrk_ce_sales';


            EXIT WHEN add_months(p_start_dt, counter + 1) >= p_end_dt;

        END LOOP;

        -- Truncate wrk_sales
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.wrk_ce_sales';


UPDATE BL_CL.PRM_MTA_INCREMENTAL_LOAD
        SET 
            previous_loaded_date = sysdate
        WHERE sa_table_name = 'SRC_SALES';


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
            L_CONTEXT := 'LOADING z_SALES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
END prc_load_ce_sales;
    
    
    PROCEDURE prc_load_fct_sales(
        p_start_dt          DATE,
        p_end_dt            DATE)
 IS
        partition_name      VARCHAR2(50);
        count_of_loops      NUMBER;
        start_dt            DATE;
        end_dt              DATE;
        COUNT_OF_ROWS_BEFORE NUMBER;
        COUNT_OF_ROWS_AFTER  NUMBER;
        L_ROWS               NUMBER:=0;
        p_last_update_dt DATE;
        ROW_CH_CL            FCT_SALES%ROWTYPE;
        L_PROCEDURE_NAME     VARCHAR2(100) := 'prc_load_fct_SALES';
        L_TABLE              VARCHAR2(100) := ' fct_SALES';
        L_CONTEXT            VARCHAR2(100) := 'Merge result';
        CURSOR CH_CL IS
        SELECT
            *
        FROM
             FCT_SALES;

    BEGIN
    SELECT 
            previous_loaded_date
        INTO 
            p_last_update_dt 
        FROM 
            BL_CL.PRM_MTA_INCREMENTAL_LOAD 
        WHERE
            sa_table_name = 'CE_SALES';
select  ceil(months_between(p_end_dt,p_start_dt))  into count_of_loops from dual;
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

--------------------Main logic--------------------------------------------------

FOR counter IN 0..count_of_loops LOOP

            -- Truncate wrk_sales
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.wrk_fct_sales';

            start_dt := add_months(p_start_dt, counter);
            end_dt := add_months(p_start_dt, counter + 1);

            -- Form partition name
            partition_name := 'fct_sales_' ||
                extract(year from start_dt) || '_' ||
                lpad(extract(month from start_dt), 2, '0');

            -- Insert into wrk_sales
            Insert
    INTO bl_cl.wrk_fct_sales (

    source_system    ,
    source_entity     ,
    product_surr_id   ,
    promotion_surr_id ,
    channel_surr_id   ,
    store_surr_id     ,
    employee_surr_id  ,
    customer_surr_id  ,
    date_id           ,
    unit_cost         ,
    unit_price       ,
    sales_quantity    ,
    ta_update_dt      ,
    ta_insert_dt      
    )
    

   
    SElect 
    '3nf' AS sale_source_system, 
    'ce_sales' AS sale_source_entity, 
    COALESCE(p.PRODUCT_SURR_ID,-1) as product_id,
    COALESCE(p2.promotion_surr_id,-1) as promotion_id,
    COALESCE(c3.channel_surr_id,-1) as channel_id,
    COALESCE(s.store_surr_id,-1) as store_id,
    COALESCE(e.employee_surr_id,-1) as employee_id ,
    COALESCE(c2.customer_surr_id,-1) as customer_id,
    COALESCE(c.date_id,(TO_DATE('9999-12-31' ,'yyyy-mm-dd'))) as date_id,
    c.sale_cost as sale_cost,
    c.sale_price as sale_price,
    c.SALE_QUANTITY as sale_quantity,
    SYSDATE as TA_UPDATE_DT ,
    SYSDATE  as TA_INSERT_DT
    FROM  ce_sales c
    LEFT JOIN dim_products p
    ON c.product_id=p.product_srcid   
    LEFT JOIN dim_customers c2
    ON c.customer_id=c2.customer_srcid
    --Left Join bl_cl.map_channels mc
    --on mc.channel_srcid=c.channel_id   
    LEFT JOIN dim_channels c3
    ON c.channel_id=c3.channel_srcid
    LEFT JOIN dim_promotions_scd p2
    ON c.promotion_id=p2.promotion_srcid
    and p2.start_dt<=c.date_id  and  p2.end_dt>=c.date_id
    LEFT JOIN dim_employees e
    ON c.employee_id=e.employee_srcid
    LEFT JOIN dim_stores s
    ON c.store_id=s.store_srcid
           WHERE c.date_id  >= add_months(p_start_dt, counter)
            AND c.date_id  < add_months(p_start_dt, counter + 1)
            and c.ta_update_dt > p_last_update_dt;
             L_ROWS := L_ROWS + SQL%ROWCOUNT;
            COMMIT;
            -- Exchange partitions
          EXECUTE IMMEDIATE
                'ALTER TABLE bl_dm.fct_sales
                EXCHANGE PARTITION ' || partition_name ||
                ' WITH TABLE bl_cl.wrk_fct_sales';
            EXIT WHEN add_months(p_start_dt, counter + 1) >= p_end_dt;
        END LOOP;
        -- Truncate wrk_sales
       EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.wrk_fct_sales';
       UPDATE BL_CL.PRM_MTA_INCREMENTAL_LOAD
        SET 
            previous_loaded_date = sysdate
        WHERE sa_table_name = 'CE_SALES';

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
            L_CONTEXT := 'LOADING fct_SALES: exseption';
            PRC_LOG(L_PACKAGE_NAME, L_PROCEDURE_NAME, L_TABLE, L_CONTEXT, NULL,
                   NULL, NULL, SYSDATE, 'ROLLBACK', SQLCODE);
--------------------------------------------------------------------------------
            ROLLBACK;
            RAISE;
END prc_load_fct_sales;
  
END pkg_load_fct_sales;
