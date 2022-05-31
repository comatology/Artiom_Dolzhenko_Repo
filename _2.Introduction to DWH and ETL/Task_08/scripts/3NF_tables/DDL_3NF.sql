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


DROP TABLE bl_3nf.ce_channels CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_channels (
    channel_id              NUMBER(38)          NOT NULL,
    channel_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    channel_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    channel_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    channel_description     VARCHAR2(50 CHAR)   NOT NULL,
    channel_class_id        NUMBER(38)          NOT NULL,
    TA_UPDATE_DT            DATE                NOT NULL,
    TA_INSERT_DT            DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_channels 
    ADD CONSTRAINT ce_channel_pk 
    PRIMARY KEY ( channel_id );
ALTER TABLE  bl_3nf.ce_channels
    ADD CONSTRAINT ce_channel_ce_channel_class_fk 
    FOREIGN KEY ( channel_class_id )
    REFERENCES bl_3nf.ce_channel_classes ( channel_class_id );
CREATE PUBLIC SYNONYM ce_channels
FOR bl_3nf.ce_channels;

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
    
DROP TABLE bl_3nf.ce_promotions_scd CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_promotions_scd (
    promotion_id              NUMBER(38)          NOT NULL,
    promotion_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    promotion_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    promotion_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    promotion_name            VARCHAR2(50 CHAR)   NOT NULL,
    promotion_category_id     NUMBER(38)          NOT NULL,
    begin_sop_DT              DATE                NOT NULL,
    end_eop_DT                DATE                NOT NULL,
    is_active                 VARCHAR2(50 char)   NOT NULL,
    cost                      NUMBER(15,2)        NOT NULL,
    TA_UPDATE_DT              DATE                NOT NULL,
    TA_INSERT_DT              DATE                NOT NULL
);
ALTER TABLE bl_3nf.ce_promotions_scd 
    ADD CONSTRAINT ce_promotions_scd_pk 
    PRIMARY KEY ( promotion_id, begin_sop_dt );
ALTER TABLE  bl_3nf.ce_promotions_scd
    ADD CONSTRAINT ce_promotions_scd_ce_promotion_class_fk 
    FOREIGN KEY ( promotion_category_id )
    REFERENCES bl_3nf.ce_promotion_categories ( promotion_category_id );

CREATE PUBLIC SYNONYM ce_promotions_scd
FOR bl_3nf.ce_promotions_scd;


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



DROP TABLE bl_3nf.ce_products CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_products (
    product_id              NUMBER(38)          NOT NULL,
    product_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    product_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    product_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    product                 VARCHAR2(1000 CHAR) NOT NULL,
    unit_price              NUMBER (15,2)       NOT NULL,
    unit_cost               NUMBER (15,2)       NOT NULL,
    product_brand_id        NUMBER(38)          NOT NULL,
    product_type_id         NUMBER(38)          NOT NULL,
    TA_UPDATE_DT            DATE                NOT NULL,
    TA_INSERT_DT            DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_products 
    ADD CONSTRAINT ce_product_pk 
    PRIMARY KEY ( product_id );
ALTER TABLE  bl_3nf.ce_products
    ADD CONSTRAINT ce_products_ce_brand_fk 
    FOREIGN KEY ( product_brand_id )
    REFERENCES bl_3nf.ce_brands (  product_brand_id );
    
ALTER TABLE  bl_3nf.ce_products
    ADD CONSTRAINT ce_products_ce_product_type_fk 
    FOREIGN KEY ( product_type_id )
    REFERENCES bl_3nf.ce_product_types (  product_type_id );
    
    
CREATE PUBLIC SYNONYM ce_products
FOR bl_3nf.ce_products;

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
    
DROP TABLE bl_3nf.ce_states CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_states (
    state_id              NUMBER(38)          NOT NULL,
    state_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    state_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    state_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    state_name            VARCHAR2(50 CHAR)   NOT NULL,
    country_id            NUMBER(38)          NOT NULL,
    TA_UPDATE_DT          DATE                NOT NULL,
    TA_INSERT_DT          DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_states
    ADD CONSTRAINT ce_state_pk 
    PRIMARY KEY ( state_id );
ALTER TABLE  bl_3nf.ce_states
    ADD CONSTRAINT ce_state_ce_country_fk 
    FOREIGN KEY ( country_id )
    REFERENCES bl_3nf.ce_countries ( country_id );
    
CREATE PUBLIC SYNONYM ce_states
FOR bl_3nf.ce_states;     
    
DROP TABLE bl_3nf.ce_cities CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_cities (
    city_id              NUMBER(38)          NOT NULL,
    city_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    city_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    city_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    city                 VARCHAR2(50 CHAR)   NOT NULL,
    state_id             NUMBER(38)          NOT NULL,
    TA_UPDATE_DT         DATE                NOT NULL,
    TA_INSERT_DT         DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_cities
    ADD CONSTRAINT ce_city_pk 
    PRIMARY KEY ( city_id );
ALTER TABLE  bl_3nf.ce_cities
    ADD CONSTRAINT ce_city_ce_states_fk 
    FOREIGN KEY (state_id )
    REFERENCES bl_3nf.ce_states ( state_id );
CREATE PUBLIC SYNONYM ce_citiess
FOR bl_3nf.ce_cities;     


DROP TABLE bl_3nf.ce_addresses CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_addresses (
    address_id              NUMBER(38)          NOT NULL,
    address_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    address_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    address_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    street_address          VARCHAR2(1000 CHAR) NOT NULL,
    postal_code             VARCHAR2(50 CHAR)   NOT NULL,
    city_id                 NUMBER(38)          NOT NULL,
    TA_UPDATE_DT            DATE                NOT NULL,
    TA_INSERT_DT            DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_addresses
    ADD CONSTRAINT ce_address_pk 
    PRIMARY KEY ( address_id );
ALTER TABLE  bl_3nf.ce_addresses
    ADD CONSTRAINT ce_addresses_ce_city_fk 
    FOREIGN KEY (city_id )
    REFERENCES bl_3nf.ce_cities ( city_id );
    
CREATE PUBLIC SYNONYM ce_addresses
FOR bl_3nf.ce_addresses;      
  
  
DROP TABLE bl_3nf.ce_stores CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_stores (
    store_id              NUMBER(38)            NOT NULL,
    store_srcid           VARCHAR2(50 CHAR)     NOT NULL,
    store_source_system   VARCHAR2(50 CHAR)     NOT NULL,
    store_source_entity   VARCHAR2(50 CHAR)     NOT NULL,
    phone                 VARCHAR2(50 CHAR)     NOT NULL,
    address_id            NUMBER(38)            NOT NULL,
    TA_UPDATE_DT          DATE                  NOT NULL,
    TA_INSERT_DT          DATE                  NOT NULL

);
ALTER TABLE bl_3nf.ce_stores
    ADD CONSTRAINT ce_store_pk 
    PRIMARY KEY ( store_id );
ALTER TABLE  bl_3nf.ce_stores
    ADD CONSTRAINT ce_store_ce_address_fk 
    FOREIGN KEY (address_id )
    REFERENCES bl_3nf.ce_addresses ( address_id );  
    
CREATE PUBLIC SYNONYM ce_stores
FOR bl_3nf.ce_stores;     


DROP TABLE bl_3nf.ce_customers CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_customers (
    customer_id              NUMBER(38)          NOT NULL,
    customer_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    customer_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    customer_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    first_name               VARCHAR2(50 CHAR)   NOT NULL,
    last_name                VARCHAR2(50 CHAR)   NOT NULL,
    company_name             VARCHAR2(50 CHAR)   NOT NULL,
    company_number           VARCHAR2(50 CHAR)   NOT NULL,
    phone                    VARCHAR2(50 CHAR)   NOT NULL,
    gender                   VARCHAR2(50 CHAR)   NOT NULL,
    year_of_birthday         NUMBER(38)          NOT NULL,
    email                    VARCHAR2(50 CHAR)   NOT NULL,
    address                  VARCHAR2(1000 CHAR) NOT NULL,
    country_id               NUMBER(38)          NOT NULL,
    TA_UPDATE_DT             DATE                NOT NULL,
    TA_INSERT_DT             DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_customers
    ADD CONSTRAINT ce_customer_pk 
    PRIMARY KEY ( customer_id );
ALTER TABLE  bl_3nf.ce_customers
    ADD CONSTRAINT ce_customer_ce_country_fk 
    FOREIGN KEY ( country_id )
    REFERENCES bl_3nf.ce_countries ( country_id );
    
CREATE PUBLIC SYNONYM ce_customers
FOR bl_3nf.ce_customers;     
    
    
DROP TABLE bl_3nf.ce_positions CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_positions (
    position_id              NUMBER(38)          NOT NULL,
    position_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    position_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    position_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    position                 VARCHAR2(50 CHAR)   NOT NULL,
    TA_UPDATE_DT             DATE                NOT NULL,
    TA_INSERT_DT             DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_positions
    ADD CONSTRAINT ce_positions_pk 
    PRIMARY KEY ( position_id );
 CREATE PUBLIC SYNONYM ce_positions
FOR bl_3nf.ce_positions;    


DROP TABLE bl_3nf.ce_employees CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_employees (
    employee_id              NUMBER(38)          NOT NULL,
    employee_srcid           VARCHAR2(50 CHAR)   NOT NULL,
    employee_source_system   VARCHAR2(50 CHAR)   NOT NULL,
    employee_source_entity   VARCHAR2(50 CHAR)   NOT NULL,
    first_name               VARCHAR2(50 CHAR)   NOT NULL,
    last_name                VARCHAR2(50 CHAR)   NOT NULL,
    day_of_birthday          DATE                NOT NULL,
    position_id              NUMBER (38)         NOT NULL,
    phone                    VARCHAR2(50 CHAR)   NOT NULL,
    email                    VARCHAR2(50 CHAR)   NOT NULL,
    address                  VARCHAR2(50 CHAR)   NOT NULL,
    country_id               NUMBER(38)          NOT NULL,
    TA_UPDATE_DT             DATE                NOT NULL,
    TA_INSERT_DT             DATE                NOT NULL

);
ALTER TABLE bl_3nf.ce_employees
    ADD CONSTRAINT ce_employee_pk 
    PRIMARY KEY ( employee_id );
ALTER TABLE  bl_3nf.ce_employees
    ADD CONSTRAINT ce_employee_ce_country_fk 
    FOREIGN KEY ( country_id )
    REFERENCES bl_3nf.ce_countries ( country_id );
ALTER TABLE  bl_3nf.ce_employees
    ADD CONSTRAINT ce_employee_ce_position_fk 
    FOREIGN KEY ( position_id )
    REFERENCES bl_3nf.ce_positions ( position_id );

 CREATE PUBLIC SYNONYM ce_employees
FOR bl_3nf.ce_employees;

DROP TABLE bl_3nf.ce_sales CASCADE CONSTRAINTS;
CREATE TABLE bl_3nf.ce_sales(
    sale_id                         NUMBER(38)          NOT NULL,
    sale_source_system              VARCHAR2(50 CHAR)   NOT NULL,
    sale_source_entity              VARCHAR2(50 CHAR)   NOT NULL,   
    product_id                      NUMBER(38)          NOT NULL,
    date_id                         DATE                NOT NULL,
    promotion_id                    NUMBER(38)          NOT NULL,
    channel_id                      NUMBER(38)          NOT NULL,
    store_id                        NUMBER(38)          NOT NULL,
    employee_id                     NUMBER(38)          NOT NULL,
    customer_id                     NUMBER(38)          NOT NULL,
    sale_cost                       NUMBER(15,3)        ,
    sale_price                      NUMBER(15,3)        ,
    sale_quantity                   NUMBER(38)          ,
    TA_UPDATE_DT                    DATE                NOT NULL,
    TA_INSERT_DT                    DATE                NOT NULL

);

ALTER TABLE  bl_3nf.ce_sales
    ADD CONSTRAINT ce_sales_ce_product_fk 
    FOREIGN KEY (product_id )
    REFERENCES bl_3nf.ce_products ( product_id );



ALTER TABLE  bl_3nf.ce_sales
    ADD CONSTRAINT ce_sales_ce_channel_fk 
    FOREIGN KEY (channel_id )
    REFERENCES bl_3nf.ce_channels ( channel_id );
    
ALTER TABLE  bl_3nf.ce_sales
    ADD CONSTRAINT ce_sales_ce_store_fk 
    FOREIGN KEY (store_id )
    REFERENCES bl_3nf.ce_stores ( store_id );
ALTER TABLE  bl_3nf.ce_sales
    ADD CONSTRAINT ce_sales_ce_employee_fk 
    FOREIGN KEY (employee_id )
    REFERENCES bl_3nf.ce_employees ( employee_id );
ALTER TABLE  bl_3nf.ce_sales
    ADD CONSTRAINT ce_sales_ce_customer_fk 
    FOREIGN KEY (customer_id )
    REFERENCES bl_3nf.ce_customers ( customer_id );

 CREATE PUBLIC SYNONYM ce_sales
FOR bl_3nf.ce_sales;



