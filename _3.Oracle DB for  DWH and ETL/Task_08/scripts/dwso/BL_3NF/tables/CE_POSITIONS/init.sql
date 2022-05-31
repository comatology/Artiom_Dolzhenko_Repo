INSERT INTO CE_POSITIONS (
    POSITION_ID,
    POSITION_SRCID,
    POSITION_SOURCE_SYSTEM,
    POSITION_SOURCE_ENTITY,
    POSITION,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_employees',
    'N/A',
    SYSDATE,
    SYSDATE
);
COMMIT;      