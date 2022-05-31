DROP TABLE SA_SOURCE_SYSTEM_2.SRC_CHANNELS ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_CHANNELS(
    channel_id  VARCHAR2(100),
    channel_desc  VARCHAR2(100),
    channel_class  VARCHAR2(100),
    channel_class_id  VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);
DROP TABLE SA_SOURCE_SYSTEM_2.SRC_COUNTIRES ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_COUNTIRES(
   country_id VARCHAR2(100),
   country_iso_code VARCHAR2(100),
   country_name VARCHAR2(100),
   country_subregion VARCHAR2(100),
   country_subregion_id VARCHAR2(100),
   country_region VARCHAR2(100),
   country_region_id VARCHAR2(100),
   country_total VARCHAR2(100),
   country_total_id VARCHAR2(100),
   country_name_hist VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL

);
DROP TABLE SA_SOURCE_SYSTEM_2.SRC_CUSTOMERS ;

CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_CUSTOMERS(
  customer_id VARCHAR2(100),
  customer_company_name VARCHAR2(100),
  customer_company_number VARCHAR2(100),
  customer_address VARCHAR2(100),
  customer_country_id VARCHAR2(100),
  customer_iso_code VARCHAR2(100),
  customer_country_name VARCHAR2(100),
  customer_phone VARCHAR2(100),
  customer_email VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);

DROP TABLE SA_SOURCE_SYSTEM_2.SRC_EMPLOYEES ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_EMPLOYEES(
  employee_id VARCHAR2(100),
  employee_name VARCHAR2(100),
  employee_last_name VARCHAR2(100),
  employee_birthday VARCHAR2(100),
  employee_position_id VARCHAR2(100),
  employee_position VARCHAR2(100),
  employee_phone  VARCHAR2(100),
  employee_email VARCHAR2(100),
  employee_address VARCHAR2(100),
  employee_country VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);
DROP TABLE SA_SOURCE_SYSTEM_2.SRC_PRODUCTS ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_PRODUCTS(
 product_id  VARCHAR2(100),
 product_name VARCHAR2(2000),
 brand_id VARCHAR2(100),
 brand VARCHAR2(100),
 product_type_id VARCHAR2(100),
 product_type VARCHAR2(100),
 unit_cost VARCHAR2(100),
 unit_price VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);

DROP TABLE SA_SOURCE_SYSTEM_2.SRC_PROMOTIONS ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_PROMOTIONS(
 promo_id VARCHAR2(100),
 promo_name VARCHAR2(100),
 promo_category VARCHAR2(100),
 promo_category_id VARCHAR2(100),
 promo_cost VARCHAR2(100),
 promo_begin_date VARCHAR2(100),
 promo_end_date VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);

DROP TABLE SA_SOURCE_SYSTEM_2.SRC_STORES ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_STORES(
 store_id  VARCHAR2(100),
 store_postal_code VARCHAR2(100),
 store_city VARCHAR2(100),
 store_city_id VARCHAR2(100),
 store_state VARCHAR2(100),
 store_state_id VARCHAR2(100),
 store_country VARCHAR2(100),
 store_country_id VARCHAR2(100),
 store_phone VARCHAR2(100),
 store_street_address_id VARCHAR2(100),
 store_street_address VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);

DROP TABLE SA_SOURCE_SYSTEM_2.SRC_SALES ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_SALES(
 product_id VARCHAR2(100),
 customer_id VARCHAR2(100),
 channel_id VARCHAR2(100),
 promo_id VARCHAR2(100),
 employee_id VARCHAR2(100),
 store_id VARCHAR2(100),
 quantity_sold VARCHAR2(100),
 time_id VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL
);




