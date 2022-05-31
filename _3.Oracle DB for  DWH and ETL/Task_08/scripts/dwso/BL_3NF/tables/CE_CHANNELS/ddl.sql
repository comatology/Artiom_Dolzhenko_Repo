CREATE TABLE BL_3NF.CE_CHANNELS (
    CHANNEL_ID            NUMBER(38) NOT NULL,
    CHANNEL_SRCID         VARCHAR2(50 CHAR) NOT NULL,
    CHANNEL_SOURCE_SYSTEM VARCHAR2(50 CHAR) NOT NULL,
    CHANNEL_SOURCE_ENTITY VARCHAR2(50 CHAR) NOT NULL,
    CHANNEL_DESCRIPTION   VARCHAR2(50 CHAR) NOT NULL,
    CHANNEL_CLASS_ID      NUMBER(38) NOT NULL,
    TA_UPDATE_DT          DATE NOT NULL,
    TA_INSERT_DT          DATE NOT NULL
);

ALTER TABLE BL_3NF.CE_CHANNELS ADD CONSTRAINT CE_CHANNEL_PK PRIMARY KEY ( CHANNEL_ID );

ALTER TABLE BL_3NF.CE_CHANNELS
    ADD CONSTRAINT CE_CHANNEL_CE_CHANNEL_CLASS_FK FOREIGN KEY ( CHANNEL_CLASS_ID )
        REFERENCES BL_3NF.CE_CHANNEL_CLASSES ( CHANNEL_CLASS_ID );