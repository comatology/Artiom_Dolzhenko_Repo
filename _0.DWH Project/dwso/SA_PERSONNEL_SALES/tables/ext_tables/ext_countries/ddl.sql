DROP TABLE SA_SOURCE_SYSTEM_1.COUNTRIES;
CREATE TABLE SA_SOURCE_SYSTEM_1.COUNTRIES(
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