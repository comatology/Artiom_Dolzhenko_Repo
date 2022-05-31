INSERT INTO DIM_CUSTOMERS (
    CUSTOMER_SURR_ID,
    CUSTOMER_SRCID,
    SOURCE_SYSTEM,
    SOURCE_ENTITY,
    FIRST_NAME,
    LAST_NAME,
    COMPANY_NAME,
    PHONE,
    COMPANY_NUMBER,
    GENDER,
    YEART_OF_BIRTH,
    EMAIL,
    COUNTRY,
    COUNTRY_ID,
    ADDRESS,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    '3nf',
    'ce_customers',
    'N/A',
    'N/A',
    'N/A',
    'N/A',
    'N/A',
    'N/A',
    - 1,
    'N/A',
    'N/A',
    - 1,
    'N/A',
    SYSDATE,
    SYSDATE
);

COMMIT;