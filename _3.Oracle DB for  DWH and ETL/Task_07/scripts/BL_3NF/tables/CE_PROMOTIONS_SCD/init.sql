INSERT INTO CE_PROMOTIONS_SCD (
    PROMOTION_ID,
    PROMOTION_SRCID,
    PROMOTION_SOURCE_SYSTEM,
    PROMOTION_SOURCE_ENTITY,
    PROMOTION_NAME,
    PROMOTION_CATEGORY_ID,
    START_DT,
    END_DT,
    IS_ACTIVE,
    COST,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_promotions',
    'N/A',
    - 1,
    TO_DATE('9999-12-31', 'yyyy-mm-dd'),
    TO_DATE('9999-12-31', 'yyyy-mm-dd'),
    'inactive',
    - 1,
    SYSDATE,
    SYSDATE
);
COMMIT;