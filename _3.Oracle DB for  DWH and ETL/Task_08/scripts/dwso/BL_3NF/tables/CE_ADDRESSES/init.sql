INSERT INTO CE_ADDRESSES (
    ADDRESS_ID,
    ADDRESS_SRCID,
    ADDRESS_SOURCE_SYSTEM,
    ADDRESS_SOURCE_ENTITY,
    STREET_ADDRESS,
    POSTAL_CODE,
    CITY_ID,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_stores',
    '-1',
    '-1',
    - 1,
    SYSDATE,
    SYSDATE
);
COMMIT;