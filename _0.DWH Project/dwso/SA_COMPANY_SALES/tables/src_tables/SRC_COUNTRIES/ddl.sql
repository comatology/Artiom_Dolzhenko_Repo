DROP TABLE SA_SOURCE_SYSTEM_2.SRC_COUNTRIES ;
CREATE TABLE SA_SOURCE_SYSTEM_2.SRC_COUNTRIES(
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
 TA_UPDATE_DT DATE NOT NULL,
 TA_INSERT_DT DATE NOT NULL

);