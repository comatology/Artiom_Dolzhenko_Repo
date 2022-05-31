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
 store_street_address_id VARCHAR2(100),
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
 store_street_address_id CHAR(100),
 store_street_address CHAR(100)))

  LOCATION (SOURCE_1:'stores.csv')  
) ;