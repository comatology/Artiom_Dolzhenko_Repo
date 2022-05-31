INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_ADDRESSES','insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_ADDRESSES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_ADDRESSES GROUP BY STREET_ADDRESS, POSTAL_CODE HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_BRANDS','insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_BRANDS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_BRANDS GROUP BY PRODUCT_BRAND, PRODUCT_BRAND_SOURCE_SYSTEM HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_CHANNEL_CLASSES','insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_CHANNEL_CLASSES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_CHANNEL_CLASSES GROUP BY CHANNEL_CLASS HAVING count(*) > 1))');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_CHANNELS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_CHANNELS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_CHANNELS GROUP BY CHANNEL_DESCRIPTION HAVING count(*) > 1)) ');


INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_CITIES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_CITIES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_CITIES GROUP BY CITY,STATE_ID HAVING count(*) > 1)) ');

INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_COUNTRIES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_COUNTRIES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_COUNTRIES GROUP BY COUNTRY HAVING count(*) > 1)) ');

INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_CUSTOMERS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_CUSTOMERS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_CUSTOMERS GROUP BY CUSTOMER_SRCID, CUSTOMER_SOURCE_SYSTEM HAVING count(*) > 1)) ');

INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_EMPLOYEES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_EMPLOYEES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_EMPLOYEES GROUP BY EMPLOYEE_SRCID, EMPLOYEE_SOURCE_SYSTEM HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_POSITIONS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_POSITIONS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_POSITIONS GROUP BY POSITION_SRCID, POSITION_SOURCE_SYSTEM HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_PRODUCT_TYPES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_PRODUCT_TYPES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_PRODUCT_TYPES GROUP BY PRODUCT_TYPE_SRCID, PRODUCT_TYPE_SOURCE_SYSTEM HAVING count(*) > 1)) ');

INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_PRODUCTS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_PRODUCTS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_PRODUCTS GROUP BY PRODUCT_SRCID, PRODUCT_SOURCE_SYSTEM HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_PROMOTION_CATEGORIES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_PROMOTION_CATEGORIES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_PROMOTION_CATEGORIES GROUP BY PROMOTION_CATEGORY_SRCID, PROMOTION_CATEGORY_SOURCE_SYSTEM HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_PROMOTIONS_SCD', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_PROMOTIONS_SCD'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_PROMOTIONS_SCD GROUP BY PROMOTION_SRCID, PROMOTION_SOURCE_SYSTEM,START_DT HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_STATES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_STATES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_STATES GROUP BY STATE_SRCID, STATE_SOURCE_SYSTEM HAVING count(*) > 1)) ');

INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_STORES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_STORES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_STORES GROUP BY STORE_SRCID, STORE_SOURCE_SYSTEM HAVING count(*) > 1)) ');

INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('CE_SALES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''CE_SALES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM CE_SALES GROUP BY PRODUCT_ID,DATE_ID,PROMOTION_ID,CHANNEL_ID,STORE_ID,EMPLOYEE_ID,CUSTOMER_ID HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('DIM_CHANNELS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''DIM_CHANNELS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM DIM_CHANNELS GROUP BY CHANNEL_SRCID, SOURCE_SYSTEM, SOURCE_ENTITY HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('DIM_CUSTOMERS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''DIM_CUSTOMERS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM DIM_CUSTOMERS GROUP BY CUSTOMER_SRCID, SOURCE_SYSTEM, SOURCE_ENTITY HAVING count(*) > 1)) ');
INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('DIM_EMPLOYEES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''DIM_EMPLOYEES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM DIM_EMPLOYEES GROUP BY EMPLOYEE_SRCID, SOURCE_SYSTEM, SOURCE_ENTITY HAVING count(*) > 1)) ');


INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('DIM_PRODUCTS', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''DIM_PRODUCTS'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM DIM_PRODUCTS GROUP BY PRODUCT_SRCID, SOURCE_SYSTEM, SOURCE_ENTITY HAVING count(*) > 1)) ');


INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('DIM_PROMOTIONS_SCD', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''DIM_PROMOTIONS_SCD'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM DIM_PROMOTIONS_SCD GROUP BY PROMOTION_SRCID, SOURCE_SYSTEM, SOURCE_ENTITY,START_DT HAVING count(*) > 1)) ');


INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('DIM_STORES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''DIM_STORES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM DIM_STORES GROUP BY STORE_SRCID, SOURCE_SYSTEM, SOURCE_ENTITY HAVING count(*) > 1)) ');


INSERT INTO BL_CL.WRK_TABLES_FOR_TESTS(NAME_OF_TABLE, DUBLICATES_TEST)
VALUES 
    ('FCT_SALES', 'insert into bl_cl.test_results_dubles  (name_of_table,date_of_test,number_of_dublicates_vals)  select ''FCT_SALES'',SYSDATE, nvl(M,0) FROM (SELECT MAX(COUNT)AS M FROM (SELECT count(*)AS COUNT FROM FCT_SALES GROUP BY SOURCE_SYSTEM,SOURCE_ENTITY,PRODUCT_SURR_ID,PROMOTION_SURR_ID, CHANNEL_SURR_ID,STORE_SURR_ID, EMPLOYEE_SURR_ID, CUSTOMER_SURR_ID, DATE_ID HAVING count(*) > 1)) ');

COMMIT;

    
    

   