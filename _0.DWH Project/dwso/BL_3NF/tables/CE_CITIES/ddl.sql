CREATE TABLE BL_3NF.CE_CITIES (
    CITY_ID            NUMBER(38) NOT NULL,
    CITY_SRCID         VARCHAR2(50 CHAR) NOT NULL,
    CITY_SOURCE_SYSTEM VARCHAR2(50 CHAR) NOT NULL,
    CITY_SOURCE_ENTITY VARCHAR2(50 CHAR) NOT NULL,
    CITY               VARCHAR2(50 CHAR) NOT NULL,
    STATE_ID           NUMBER(38) NOT NULL,
    TA_UPDATE_DT       DATE NOT NULL,
    TA_INSERT_DT       DATE NOT NULL
);

ALTER TABLE BL_3NF.CE_CITIES ADD CONSTRAINT CE_CITY_PK PRIMARY KEY ( CITY_ID );

ALTER TABLE BL_3NF.CE_CITIES
    ADD CONSTRAINT CE_CITY_CE_STATES_FK FOREIGN KEY ( STATE_ID )
        REFERENCES BL_3NF.CE_STATES ( STATE_ID );