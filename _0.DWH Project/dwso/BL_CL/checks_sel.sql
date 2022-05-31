select * from bl_cl.log_table;

SELECT * FROM CE_SALES;
SELECT * FROM FCT_SALES;



truncate table bl_cl.log_table;

select * from DIM_PROMOTIONS_SCD;

select * from SA_SOURCE_SYSTEM_1.SRC_CHANNELS;
select * from SA_SOURCE_SYSTEM_1.SRC_Countries;
select * from SA_SOURCE_SYSTEM_1.SRC_Customers;
select * from SA_SOURCE_SYSTEM_1.SRC_EMPLOYEES;
select * from SA_SOURCE_SYSTEM_1.SRC_PRODUCTS;
select * from SA_SOURCE_SYSTEM_1.SRC_PROMOTIONS;
select * from SA_SOURCE_SYSTEM_1.SRC_STORES;
select * from SA_SOURCE_SYSTEM_1.SRC_SALES;

truncate table SA_SOURCE_SYSTEM_1.SRC_SALES

select * from SA_SOURCE_SYSTEM_2.SRC_CHANNELS;
select * from SA_SOURCE_SYSTEM_2.SRC_Countries;
select * from SA_SOURCE_SYSTEM_2.SRC_Customers;
select * from SA_SOURCE_SYSTEM_2.SRC_EMPLOYEES;
select * from SA_SOURCE_SYSTEM_2.SRC_PRODUCTS;
select * from SA_SOURCE_SYSTEM_2.SRC_PROMOTIONS;
select * from SA_SOURCE_SYSTEM_2.SRC_STORES;
select * from SA_SOURCE_SYSTEM_2.SRC_SALES;
select * from bl_cl.WORK_PROMOTIONS_SCD
select * from ce_promotions_scd;
seLECT * FROM BL_3NF.ce_promotion_categories

delete from SA_SOURCE_SYSTEM_1.SRC_PROMOTIONS;
delete from bl_cl.WORK_PROMOTIONS_SCD

delete from CE_CHANNELS where channel_id!=-1;
delete from CE_CHANNEL_CLASSES where channel_class_id!=-1;
delete from CE_PROMOTIONS_SCD where promotion_id!=-1; 
delete from CE_PROMOTION_CATEGORIES where PROMOTION_CATEGORy_id!=-1;
delete from CE_PRODUCTS where product_id!=-1;
delete from CE_BRANDS where brand_id !=-1;
delete from CE_PRODUCT_TYPES where product_type_id!=-1;
truncate table bl_3nf.ce_sales

delete from CE_CUSTOMERS where customer_id!=-1;
delete from CE_EMPLOYEES where employee_id!=-1;
delete from CE_POSITIONS where position_id!=-1;
delete from CE_STORES where store_id!=-1;
delete from CE_ADDRESSES where address_id!=-1;
delete from CE_CITIES where city_id!=-1;
delete from CE_STATES where state_id!=-1;
delete from CE_COUNTRIES where country_id!=-1;


delete from dim_channels

select * from CE_CHANNEL_CLASSES;
select * from CE_CHANNELS; 
select * from CE_PROMOTION_CATEGORIES;
select count(*) from CE_sales;
select * from CE_BRANDS;
select * from CE_PRODUCT_TYPES;
select count(*) from CE_PRODUCTS;
select * from CE_COUNTRIES;
select * from CE_STATES;
select * from CE_CITIES;
select * from CE_ADDRESSES;
select count(*) from CE_STORES;
select count(*) from CE_CUSTOMERS;
select * from dim_promotions_scd;
select count(*) from CE_EMPLOYEES
SELECT * FROM CE_SALES

SELECT * FROM  bl_cl.WORK_PROMOTIONS_SCD; --441-445

SELECT * FROM BL_3NF.ce_promotion_categories



SELECT * FROM fct_SALES

truncate table bl_cl.WORK_PROMOTIONS_SCD; 
truncate table bl_dm.fct_sales;
truncate table bl_dm.dim_stores;
truncate table BL_DM.dim_promotions_scd;
truncate table BL_DM.dim_products;
truncate table BL_DM.dim_employees;
truncate table bl_dm.dim_customers;
truncate table bl_dm.dim_channels;

truncate table bl_3nf.ce_sales;
truncate table bl_3nf.ce_stores;
truncate table bl_3nf.ce_promotions_scd;
truncate table bl_3nf.ce_products;
truncate table bl_3nf.ce_employees;
truncate table bl_3nf.ce_customers;
truncate table bl_3nf.ce_channels;

truncate table BL_3NF.ce_addresses;
truncate table BL_3NF.ce_cities;
truncate table bl_3nf.ce_states;
truncate table BL_3NF.ce_countries;
truncate table bl_3nf.ce_brands;
truncate table bl_3nf.ce_positions;
truncate table bl_3nf.ce_product_types;
truncate table bl_3nf.ce_promotion_categories;
truncate table bl_3nf.ce_channel_classes;

truncate table BL_CL.prm_mta_incremental_load

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


