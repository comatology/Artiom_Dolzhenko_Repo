INSERT INTO CE_EMPLOYEES (
    EMPLOYEE_ID,
    EMPLOYEE_SRCID,
    EMPLOYEE_SOURCE_SYSTEM,
    EMPLOYEE_SOURCE_ENTITY,
    FIRST_NAME,
    LAST_NAME,
    DAY_OF_BIRTHDAY,
    POSITION_ID,
    PHONE,
    EMAIL,
    ADDRESS,
    COUNTRY_ID,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_employees',
    'N/A',
    'N/A',
    TO_DATE('9999-12-31', 'yyyy-mm-dd'),
    - 1,
    'N/A',
    'N/A',
    'N/A',
    - 1,
    SYSDATE,
    SYSDATE
);
COMMIT; 