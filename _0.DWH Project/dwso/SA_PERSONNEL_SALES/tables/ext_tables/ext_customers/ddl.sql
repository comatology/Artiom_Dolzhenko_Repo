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