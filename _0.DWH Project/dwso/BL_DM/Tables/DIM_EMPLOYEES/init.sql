INSERT INTO DIM_EMPLOYEES (
    EMPLOYEE_SURR_ID,
    EMPLOYEE_SRCID,
    SOURCE_SYSTEM,
    SOURCE_ENTITY,
    FIRST_NAME,
    LAST_NAME,
    DAY_OF_BIRTHDAY_DT,
    POSITION_ID,
    POSITION,
    PHONE,
    EMAIL,
    ADDRESS,
    COUNTRY_ID,
    COUNTRY,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    '3nf',
    'ce_employees',
    'N/A',
    'N/A',
    TO_DATE('9999-12-31', 'yyyy-mm-dd'),
    - 1,
    'N/A',
    'N/A',
    'N/A',
    'N/A',
    - 1,
    'N/A',
    SYSDATE,
    SYSDATE
);

COMMIT;