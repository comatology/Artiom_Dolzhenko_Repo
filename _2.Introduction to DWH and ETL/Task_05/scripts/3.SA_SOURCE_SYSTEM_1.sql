
--CHANNEL TABLE
DROP TABLE SA_SOURCE_SYSTEM_1.CHANNELS;
CREATE TABLE SA_SOURCE_SYSTEM_1.CHANNELS(
    channel_id  VARCHAR2(100),
    channel_desc  VARCHAR2(100),
    channel_class  VARCHAR2(100),
    channel_class_id  VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
            channel_id  CHAR(100),
            channel_desc  CHAR(100),
            channel_class  CHAR(100),
            channel_class_id  CHAR(100)))

  LOCATION (SOURCE_1:'chanels.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.CHANNELS;
--COUNTRIES
DROP TABLE SA_SOURCE_SYSTEM_1.COUNTIRES;
CREATE TABLE SA_SOURCE_SYSTEM_1.COUNTIRES(
   country_id VARCHAR2(100),
   country_iso_code VARCHAR2(100),
   country_name VARCHAR2(100),
   country_subregion VARCHAR2(100),
   country_subregion_id VARCHAR2(100),
   country_region VARCHAR2(100),
   country_region_id VARCHAR2(100),
   country_total VARCHAR2(100),
   country_total_id VARCHAR2(100),
   country_name_hist VARCHAR2(100)

)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
               country_id CHAR(100),
               country_iso_code CHAR(100),
               country_name CHAR(100),
               country_subregion CHAR(100),
               country_subregion_id CHAR(100),
               country_region CHAR(100),
               country_region_id CHAR(100),
               country_total CHAR(100),
               country_total_id CHAR(100),
               country_name_hist CHAR(100)))

  LOCATION (SOURCE_1:'counties.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.COUNTIRES;


--CUSTOMERS
DROP TABLE SA_SOURCE_SYSTEM_1.CUSTOMERS;
CREATE TABLE SA_SOURCE_SYSTEM_1.CUSTOMERS(
  customer_id VARCHAR2(100),
  customer_first_name VARCHAR2(100),
  customer_last_name VARCHAR2(100),
  customer_gender VARCHAR2(100),
  customer_year_of_birth VARCHAR2(100),
  customer_address VARCHAR2(100),
  customer_country_id VARCHAR2(100),
  customer_iso_code VARCHAR2(100),
  customer_country_name VARCHAR2(100),
  customer_phone VARCHAR2(100),
  customer_email VARCHAR2(100)


)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
                customer_id CHAR(100),
                customer_first_name CHAR(100),
                customer_last_name CHAR(100),
                customer_gender CHAR(100),
                customer_year_of_birth CHAR(100),
                customer_address CHAR(100),
                customer_country_id CHAR(100),
                customer_iso_code CHAR(100),
                customer_country_name CHAR(100),
                customer_phone CHAR(100),
                customer_email CHAR(100)))

  LOCATION (SOURCE_1:'customers.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.CUSTOMERS;



--EMPLOYEES
DROP TABLE SA_SOURCE_SYSTEM_1.EMPLOYEES;
CREATE TABLE SA_SOURCE_SYSTEM_1.EMPLOYEES(
  employee_id VARCHAR2(100),
  employee_name VARCHAR2(100),
  employee_last_name VARCHAR2(100),
  employee_birthday VARCHAR2(100),
  employee_position VARCHAR2(100),
  employee_phone  VARCHAR2(100),
  employee_email VARCHAR2(100),
  employee_address VARCHAR2(100),
  employee_cointry VARCHAR2(100)
 


)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
                    employee_id CHAR(100),
  employee_name CHAR(100),
  employee_last_name CHAR(100),
  employee_birthday CHAR(100),
  employee_position CHAR(100),
  employee_phone  CHAR(100),
  employee_email CHAR(100),
  employee_address CHAR(100),
  employee_cointry CHAR(100)))

  LOCATION (SOURCE_1:'employees.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.EMPLOYEES;




--PRODUCTS
DROP TABLE SA_SOURCE_SYSTEM_1.PRODUCTS;
CREATE TABLE SA_SOURCE_SYSTEM_1.PRODUCTS(
 product_id  VARCHAR2(100),
 product_name VARCHAR2(2000),
 brand_id VARCHAR2(100),
 brand VARCHAR2(100),
 product_type_id VARCHAR2(100),
 product_type VARCHAR2(100),
 unit_cost VARCHAR2(100),
 unit_price VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
product_id  CHAR(100),
 product_name CHAR(2000),
 brand_id CHAR(100),
 brand CHAR(100),
 product_type_id CHAR(100),
 product_type CHAR(100),
 unit_cost CHAR(100),
 unit_price CHAR(100)))

  LOCATION (SOURCE_1:'products.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.PRODUCTS;

--PROMOTIONS
DROP TABLE SA_SOURCE_SYSTEM_1.PROMOTIONS;
CREATE TABLE SA_SOURCE_SYSTEM_1.PROMOTIONS(
 promo_id VARCHAR2(100),
 promo_name VARCHAR2(100),
 promo_category VARCHAR2(100),
 promo_category_id VARCHAR2(100),
 promo_cost VARCHAR2(100),
 promo_begin_date VARCHAR2(100),
 promo_end_date VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
promo_id CHAR(100),
 promo_name CHAR(100),
 promo_category CHAR(100),
 promo_category_id CHAR(100),
 promo_cost CHAR(100),
 promo_begin_date CHAR(100),
 promo_end_date CHAR(100)))

  LOCATION (SOURCE_1:'promotions.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.PROMOTIONS;

--STORES
DROP TABLE SA_SOURCE_SYSTEM_1.STORES;
CREATE TABLE SA_SOURCE_SYSTEM_1.STORES(
 store_id  VARCHAR2(100),
 store_postal_code VARCHAR2(100),
 store_city VARCHAR2(100),
 store_city_id VARCHAR2(100),
 store_state VARCHAR2(100),
 store_state_id VARCHAR2(100),
 store_country VARCHAR2(100),
 store_country_id VARCHAR2(100),
 store_phone VARCHAR2(100),
 store_street_address VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
store_id  CHAR(100),
 store_postal_code CHAR(100),
 store_city CHAR(100),
 store_city_id CHAR(100),
 store_state CHAR(100),
 store_state_id CHAR(100),
 store_country CHAR(100),
 store_country_id CHAR(100),
 store_phone CHAR(100),
 store_street_address CHAR(100)))

  LOCATION (SOURCE_1:'stores.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.STORES;


--SALES
DROP TABLE SA_SOURCE_SYSTEM_1.SALES;
CREATE TABLE SA_SOURCE_SYSTEM_1.SALES(
 product_id VARCHAR2(100),
 customer_id VARCHAR2(100),
 channel_id VARCHAR2(100),
 promo_id VARCHAR2(100),
 employee_id VARCHAR2(100),
 store_id VARCHAR2(100),
 quantity_sold VARCHAR2(100),
 time_id VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
product_id CHAR(100),
 customer_id CHAR(100),
 channel_id CHAR(100),
 promo_id CHAR(100),
 employee_id CHAR(100),
 store_id CHAR(100),
 quantity_sold CHAR(100),
 time_id CHAR(100)))

  LOCATION (SOURCE_1:'sales.csv')  
) ;

SELECT * FROM SA_SOURCE_SYSTEM_1.SALES;



