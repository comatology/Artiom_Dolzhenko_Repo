INSERT INTO CE_PRODUCTS (
    PRODUCT_ID,
    PRODUCT_SRCID,
    PRODUCT_SOURCE_SYSTEM,
    PRODUCT_SOURCE_ENTITY,
    PRODUCT,
    UNIT_PRICE,
    UNIT_COST,
    PRODUCT_BRAND_ID,
    PRODUCT_TYPE_ID,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_products',
    'N/A',
    '-1',
    '-1',
    - 1,
    - 1,
    SYSDATE,
    SYSDATE
);
COMMIT;