INSERT INTO CE_BRANDS (
    PRODUCT_BRAND_ID,
    PRODUCT_BRAND_SRCID,
    PRODUCT_BRAND_SOURCE_SYSTEM,
    PRODUCT_BRAND_SOURCE_ENTITY,
    PRODUCT_BRAND,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_products',
    'N/A',
    SYSDATE,
    SYSDATE
);
COMMIT;