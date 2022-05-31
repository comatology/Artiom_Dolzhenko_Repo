INSERT INTO CE_STATES (
    STATE_ID,
    STATE_SRCID,
    STATE_SOURCE_SYSTEM,
    STATE_SOURCE_ENTITY,
    STATE_NAME,
    COUNTRY_ID,
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