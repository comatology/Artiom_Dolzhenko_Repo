DROP TABLE SA_SOURCE_SYSTEM_1.SRC_CHANNELS ;
CREATE TABLE SA_SOURCE_SYSTEM_1.SRC_CHANNELS(
    channel_id  VARCHAR2(100),
    channel_desc  VARCHAR2(100),
    channel_class  VARCHAR2(100),
    channel_class_id  VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL,
 TA_INSERT_DT DATE NOT NULL
);
