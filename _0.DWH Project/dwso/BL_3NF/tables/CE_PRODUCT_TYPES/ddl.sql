CREATE TABLE BL_3NF.CE_PRODUCT_TYPES (
    PRODUCT_TYPE_ID            NUMBER(38) NOT NULL,
    PRODUCT_TYPE_SRCID         VARCHAR2(50 CHAR) NOT NULL,
    PRODUCT_TYPE_SOURCE_SYSTEM VARCHAR2(50 CHAR) NOT NULL,
    PRODUCT_TYPE_SOURCE_ENTITY VARCHAR2(50 CHAR) NOT NULL,
    PRODUCT_TYPE               VARCHAR2(50 CHAR) NOT NULL,
    TA_UPDATE_DT               DATE NOT NULL,
    TA_INSERT_DT               DATE NOT NULL
);

ALTER TABLE BL_3NF.CE_PRODUCT_TYPES ADD CONSTRAINT CE_PRODUCT_TYPE_PK PRIMARY KEY ( PRODUCT_TYPE_ID );
