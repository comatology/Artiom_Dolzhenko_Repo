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
 TA_UPDATE_DT DATE NOT NULL,
 TA_INSERT_DT DATE NOT NULL
);