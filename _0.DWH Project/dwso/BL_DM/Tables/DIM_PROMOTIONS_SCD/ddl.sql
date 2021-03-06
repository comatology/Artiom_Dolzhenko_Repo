CREATE TABLE BL_DM.DIM_PROMOTIONS_SCD (
    PROMOTION_SURR_ID     NUMBER(38)   NOT NULL,
    PROMOTION_SRCID       VARCHAR2(50) NOT NULL,
    SOURCE_SYSTEM         VARCHAR2(50) NOT NULL,
    SOURCE_ENTITY         VARCHAR2(50) NOT NULL,
    PROMOTION_NAME        VARCHAR2(50) NOT NULL,
    PROMOTION_CATEGORY_ID NUMBER(38)   NOT NULL,
    PROMOTION_CATEGORY    VARCHAR2(50) NOT NULL,
    START_DT              DATE         NOT NULL,
    END_DT                DATE         NOT NULL,
    IS_ACTIVE             VARCHAR2(50) NOT NULL,
    COST                  NUMBER(15, 2)NOT NULL,
    TA_UPDATE_DT          DATE         NOT NULL,
    TA_INSERT_DT          DATE         NOT NULL
);

ALTER TABLE BL_DM.DIM_PROMOTIONS_SCD ADD CONSTRAINT DIM_PROMOTIONS_SCD_PK PRIMARY KEY ( PROMOTION_SURR_ID );