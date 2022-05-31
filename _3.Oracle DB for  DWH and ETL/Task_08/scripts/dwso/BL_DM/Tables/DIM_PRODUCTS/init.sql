INSERT INTO DIM_PRODUCTS (
    PRODUCT_SURR_ID,
    PRODUCT_SRCID,
    SOURCE_SYSTEM,
    SOURCE_ENTITY,
    PRODUCT_NAME,
    PRODUCT_BRAND_ID,
    PRODUCT_BRAND,
    PRODUCT_TYPE_ID,
    PRODUCT_TYPE,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    '3nf',
    'ce_products',
    'N/A',
    - 1,
    'N/A',
    - 1,
    'N/A',
    SYSDATE,
    SYSDATE
);

COMMIT;