DROP TABLE bl_3nf.ce_channel_classes CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_channel_classes (
    channel_class_id              NUMBER(38)          NOT NULL,
    channel_class_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    channel_class_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    channel_class_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    channel_class                 VARCHAR2(50 CHAR)   NOT NULL,
    TA_UPDATE_DT                  DATE                NOT NULL,
    TA_INSERT_DT                  DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_channel_classes 
    ADD CONSTRAINT ce_channel_class_pk 
    PRIMARY KEY ( channel_class_id );
CREATE PUBLIC SYNONYM ce_channel_classes
FOR bl_3nf.ce_channel_classes;


    

DROP TABLE  bl_3nf.ce_promotion_categories CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_promotion_categories (
    promotion_category_id               NUMBER(38)          NOT NULL,
    promotion_category_srcid            VARCHAR2(50 CHAR)   NOT NULL,
    promotion_category_source_system    VARCHAR2(50 CHAR)   NOT NULL,
    promotion_category_source_entity    VARCHAR2(50 CHAR)   NOT NULL,
    promotion_category                  VARCHAR2(50 CHAR)   NOT NULL,
    TA_UPDATE_DT                        DATE                NOT NULL,
    TA_INSERT_DT                        DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_promotion_categories 
    ADD CONSTRAINT ce_promotion_category_pk 
    PRIMARY KEY (promotion_category_id );
  
CREATE PUBLIC SYNONYM ce_promotion_categories
FOR bl_3nf.ce_promotion_categories;


DROP TABLE bl_3nf.ce_brands CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_brands (
    product_brand_id              NUMBER(38)          NOT NULL,
    product_brand_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    product_brand_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    product_brand_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    product_brand                 VARCHAR2(50 CHAR)   NOT NULL,
    TA_UPDATE_DT                  DATE                NOT NULL,
    TA_INSERT_DT                  DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_brands 
    ADD CONSTRAINT ce_product_brand_pk 
    PRIMARY KEY ( product_brand_id );

CREATE PUBLIC SYNONYM ce_brands
FOR bl_3nf.ce_brands;



DROP TABLE bl_3nf.ce_product_types CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_product_types (
    product_type_id              NUMBER(38)          NOT NULL,
    product_type_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    product_type_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    product_type_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    product_type                 VARCHAR2(50 CHAR)   NOT NULL,
    TA_UPDATE_DT                 DATE                NOT NULL,
    TA_INSERT_DT                 DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_product_types 
    ADD CONSTRAINT ce_product_type_pk 
    PRIMARY KEY ( product_type_id );
CREATE PUBLIC SYNONYM ce_product_types
FOR bl_3nf.ce_product_types;



DROP TABLE bl_3nf.ce_countries CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_countries (
    country_id              NUMBER(38)          NOT NULL,
    country_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    country_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    country_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    country                 VARCHAR2(50 CHAR)   NOT NULL,
    TA_UPDATE_DT            DATE                NOT NULL,
    TA_INSERT_DT            DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_countries
    ADD CONSTRAINT ce_countries_pk 
    PRIMARY KEY ( country_id );
    
    
CREATE PUBLIC SYNONYM ce_countries
FOR bl_3nf.ce_countries;   
    
    
    
    

    







