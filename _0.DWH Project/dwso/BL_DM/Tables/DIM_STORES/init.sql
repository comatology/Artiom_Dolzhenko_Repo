INSERT INTO DIM_STORES (
    STORE_SURR_ID,
    STORE_SRCID,
    SOURCE_SYSTEM,
    SOURCE_ENTITY,
    PHONE,
    STREET_ADDRESS,
    POSTAL_CODE,
    CITY_ID,
    CITY,
    STATE_ID,
    STATE,
    COUNTRY_ID,
    COUNTRY,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    '3nf',
    'ce_stores',
    'N/A',
    'N/A',
    'N/A',
    - 1,
    'N/A',
    - 1,
    'N/A',
    - 1,
    'N/A',
    SYSDATE,
    SYSDATE
);

COMMIT;