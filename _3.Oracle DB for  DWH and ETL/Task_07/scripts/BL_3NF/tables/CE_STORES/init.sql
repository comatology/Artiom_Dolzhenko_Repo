INSERT INTO CE_STORES (
    STORE_ID,
    STORE_SRCID,
    STORE_SOURCE_SYSTEM,
    STORE_SOURCE_ENTITY,
    PHONE,
    ADDRESS_ID,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_stores',
    'N/A',
    - 1,
    SYSDATE,
    SYSDATE
);
COMMIT;