   
drop table dim_channels  CASCADE CONSTRAINTS;
CREATE TABLE dim_channels (
    channel_surr_id     NUMBER(38) NOT NULL,
    channel_id          VARCHAR2(50) NOT NULL,
    source_system       VARCHAR2(50) NOT NULL,
    source_entity       VARCHAR2(50) NOT NULL,
    channel_description VARCHAR2(50) NOT NULL,
    channel_class_id    NUMBER(38) NOT NULL,
    channel_class       VARCHAR2(50) NOT NULL,
    ta_update_dt        DATE  NOT NULL,
    ta_insert_dt        DATE NOT NULL
);

ALTER TABLE dim_channels ADD CONSTRAINT dim_channels_pk PRIMARY KEY ( channel_surr_id );
drop table dim_customers  CASCADE CONSTRAINTS;
CREATE TABLE dim_customers (
    customer_surr_id NUMBER(38) NOT NULL,
    customer_id      VARCHAR2(50) NOT NULL,
    source_system    VARCHAR2(50) NOT NULL,
    source_entity    VARCHAR2(50) NOT NULL,
    first_name       VARCHAR2(50) NOT NULL,
    last_name        VARCHAR2(50) NOT NULL,
    company_name     VARCHAR2(50) NOT NULL,
    phone            VARCHAR2(50) NOT NULL,
    company_number   VARCHAR2(50) NOT NULL,
    gender           VARCHAR2(50) NOT NULL,
    yeart_of_birth   NUMBER(38)   NOT NULL,
    email            VARCHAR2(50) NOT NULL,
    country          VARCHAR2(50) NOT NULL,
    country_id       NUMBER(38)   NOT NULL,
    address          VARCHAR2(50) NOT NULL,
    ta_update_dt     DATE  NOT NULL,
    ta_insert_dt     DATE NOT NULL
);

ALTER TABLE dim_customers ADD CONSTRAINT dim_customers_pk PRIMARY KEY ( customer_surr_id );

drop table dim_employees  CASCADE CONSTRAINTS;
CREATE TABLE dim_employees (
    employee_surr_id   NUMBER(38)  NOT NULL,
    employee_id        VARCHAR2(50) NOT NULL,
    source_system      VARCHAR2(50) NOT NULL,
    source_entity      VARCHAR2(50) NOT NULL,
    first_name         VARCHAR2(50) NOT NULL,
    last_name          VARCHAR2(50) NOT NULL,
    day_of_birthday_dt DATE NOT NULL,
    position_id        NUMBER(38) NOT NULL,
    position           VARCHAR2(50) NOT NULL,
    phone              VARCHAR2(50) NOT NULL,
    email              VARCHAR2(50) NOT NULL,
    address            VARCHAR2(50) NOT NULL,
    country_id         NUMBER(38) NOT NULL,
    country            VARCHAR2(50) NOT NULL,
    ta_update_dt       DATE  NOT NULL,
    ta_insert_dt       DATE NOT NULL
);

ALTER TABLE dim_employees ADD CONSTRAINT dim_employees_scd_pk PRIMARY KEY ( employee_surr_id );
drop table dim_products  CASCADE CONSTRAINTS;
CREATE TABLE dim_products (
    product_surr_id  NUMBER(38) NOT NULL,
    product_id       VARCHAR2(50) NOT NULL,
    source_system    VARCHAR2(50) NOT NULL,
    source_entity    VARCHAR2(50) NOT NULL,
    product_name     VARCHAR2(50) NOT NULL,
    product_brand_id NUMBER(38) NOT NULL,
    product_brand    VARCHAR2(50) NOT NULL,
    product_type_id  NUMBER(38) NOT NULL,
    product_type     VARCHAR2(50) NOT NULL,
    ta_update_dt     DATE  NOT NULL,
    ta_insert_dt     DATE  NOT NULL
);

ALTER TABLE dim_products ADD CONSTRAINT dim_products_pk PRIMARY KEY ( product_surr_id );
drop table dim_promotions_scd  CASCADE CONSTRAINTS;
CREATE TABLE dim_promotions_scd (
    promotion_surr_id     NUMBER(38)  NOT NULL,
    promotion_id          VARCHAR2(50) NOT NULL,
    source_system         VARCHAR2(50) NOT NULL,
    source_entity         VARCHAR2(50) NOT NULL,
    promotion_name        VARCHAR2(50) NOT NULL,
    promotion_category_id NUMBER(38) NOT NULL,
    promotion_categoty    VARCHAR2(50) NOT NULL,
    begin_sop_dt          DATE NOT NULL,
    end_eop_dt            DATE NOT NULL,
    is_active             VARCHAR2(50) NOT NULL,
    cost                  NUMBER(15, 2) NOT NULL,
    ta_update_dt          DATE  NOT NULL,
    ta_insert_dt          DATE NOT NULL
);

ALTER TABLE dim_promotions_scd ADD CONSTRAINT dim_promotions_scd_pk PRIMARY KEY ( promotion_surr_id );
drop table dim_stores  CASCADE CONSTRAINTS;
CREATE TABLE dim_stores (
    store_surr     NUMBER(38)  NOT NULL,
    store_id       VARCHAR2(50) NOT NULL,
    source_system  VARCHAR2(50) NOT NULL,
    source_entity  VARCHAR2(50) NOT NULL,
    phone          VARCHAR2(50) NOT NULL,
    street_address VARCHAR2(50) NOT NULL,
    postal_code    VARCHAR2(50) NOT NULL,
    city_id        NUMBER(38) NOT NULL,
    city           VARCHAR2(50) NOT NULL,
    state_id       NUMBER(38) NOT NULL,
    state          VARCHAR2(50) NOT NULL,
    country_id     NUMBER(38) NOT NULL,
    country        VARCHAR2(50) NOT NULL,
    ta_update_dt   DATE  NOT NULL,
    ta_insert_dt   DATE  NOT NULL
);

ALTER TABLE dim_stores ADD CONSTRAINT dim_stores_pk PRIMARY KEY ( store_surr );
drop table fct_sales  CASCADE CONSTRAINTS;
CREATE TABLE fct_sales (
    source_system     VARCHAR2(50) NOT NULL,
    soutce_entity     VARCHAR2(50) NOT NULL,
    product_surr_id   NUMBER(38) NOT NULL,
    promotion_surr_id NUMBER(38) NOT NULL,
    channel_surr_id   NUMBER(38) NOT NULL,
    store_surr_id     NUMBER(38) NOT NULL,
    employee_surr_id  NUMBER(38) NOT NULL,
    customer_surr_id  NUMBER(38) NOT NULL,
    date_id           DATE NOT NULL,
    unit_cost         NUMBER(15, 2),
    unit_price        NUMBER(15, 2),
    sales_quantity    NUMBER(38),
    ta_update_dt      DATE  NOT NULL,
    ta_insert_dt      DATE  NOT NULL
);

