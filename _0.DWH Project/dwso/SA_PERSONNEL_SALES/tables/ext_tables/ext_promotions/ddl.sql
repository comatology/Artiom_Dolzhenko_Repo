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
