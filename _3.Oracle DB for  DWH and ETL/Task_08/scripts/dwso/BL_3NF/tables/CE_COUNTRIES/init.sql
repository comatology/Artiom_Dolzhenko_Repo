INSERT INTO CE_COUNTRIES (
    COUNTRY_ID,
    COUNTRY_SRCID,
    COUNTRY_SOURCE_SYSTEM,
    COUNTRY_SOURCE_ENTITY,
    COUNTRY,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_countries',
    'N/A',
    SYSDATE,
    SYSDATE
);
COMMIT;
