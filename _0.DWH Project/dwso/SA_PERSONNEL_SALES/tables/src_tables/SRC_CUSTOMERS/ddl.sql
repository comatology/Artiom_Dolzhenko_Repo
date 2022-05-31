DROP TABLE SA_SOURCE_SYSTEM_1.SRC_CUSTOMERS ;
CREATE TABLE SA_SOURCE_SYSTEM_1.SRC_CUSTOMERS(
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
  customer_email VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL,
 TA_INSERT_DT DATE NOT NULL
);