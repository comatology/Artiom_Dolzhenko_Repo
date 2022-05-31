CREATE TABLE BL_CL.LOG_TABLE (
    STEP_NUMBER    NUMBER,
    SESSION_ID     VARCHAR2(200),
    SESSION_USER   VARCHAR2(200),
    DB_NAME        VARCHAR2(200),
    OS_USER        VARCHAR2(200),
    TERMINAL       VARCHAR(200),
    PACKAGE_NAME   VARCHAR2(200),
    PROCEDURE_NAME VARCHAR2(200),
    TABLE_NAME     VARCHAR2(200),
    "CONTEXT"      VARCHAR2(200),
    ROWS_PROCESSED NUMBER,
    "TIMESTAMP"    timestamp,
    MESSAGE        VARCHAR2(200),
    ERROR_CODE     NUMBER
)