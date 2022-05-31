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
