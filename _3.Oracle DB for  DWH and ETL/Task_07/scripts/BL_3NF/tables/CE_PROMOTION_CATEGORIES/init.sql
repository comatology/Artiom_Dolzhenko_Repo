INSERT INTO CE_PROMOTION_CATEGORIES (
    PROMOTION_CATEGORY_ID,
    PROMOTION_CATEGORY_SRCID,
    PROMOTION_CATEGORY_SOURCE_SYSTEM,
    PROMOTION_CATEGORY_SOURCE_ENTITY,
    PROMOTION_CATEGORY,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_promotions',
    'N/A',
    SYSDATE,
    SYSDATE
);
COMMIT;