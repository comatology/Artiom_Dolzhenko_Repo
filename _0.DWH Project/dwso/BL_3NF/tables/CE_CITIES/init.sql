INSERT INTO CE_CITIES (
    CITY_ID,
    CITY_SRCID,
    CITY_SOURCE_SYSTEM,
    CITY_SOURCE_ENTITY,
    CITY,
    STATE_ID,
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