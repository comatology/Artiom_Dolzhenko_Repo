CREATE TABLE BL_DM.fct_sales (
    source_system     VARCHAR2(50) NOT NULL,
    source_entity     VARCHAR2(50) NOT NULL,
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
)PARTITION BY RANGE (DATE_ID)
(
    PARTITION sales_before_2000 VALUES LESS THAN (to_date('2000-01-01','yyyy-mm-dd'))
);
