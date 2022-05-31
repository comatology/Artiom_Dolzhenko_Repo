ALTER SESSION SET nls_date_format='yyyy-mm-dd hh24:mi:ss';

INSERT INTO BL_CL.prm_mta_incremental_load ( sa_table_name, target_table_name, package, procedure, previous_loaded_date)
VALUES ( 'SRC_SALES', 'CE_SALES', 'PKG_LOAD_3NF_TABLES', 'PRC_LOAD_CE_SALES', TO_DATE('1900-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'));

INSERT INTO BL_CL.prm_mta_incremental_load ( sa_table_name, target_table_name, package, procedure, previous_loaded_date)
VALUES ( 'CE_SALES', 'FCT_SALES', 'PKG_LOAD_BL_DM_TABLES', 'PRC_LOAD_DIM_SALES', TO_DATE('1900-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'));

INSERT INTO BL_CL.prm_mta_incremental_load ( sa_table_name, target_table_name, package, procedure, previous_loaded_date)
VALUES ( 'SRC_PROMOTIONS', 'CE_PROMOTIONS_SCD', 'PKG_LOAD_3NF_TABLES', 'PRC_LOAD_CE_PROMOTIONS_SCD', TO_DATE('1900-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'));

INSERT INTO BL_CL.prm_mta_incremental_load ( sa_table_name, target_table_name, package, procedure, previous_loaded_date)
VALUES ( 'CE_PROMOTIONS_SCD', 'DIM_PROMOTIONS_SCD2', 'PKG_LOAD_BL_DM_TABLES', 'PRC_LOAD_DIM_PROMOTIONS_SCD', TO_DATE('1900-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'));

COMMIT;
