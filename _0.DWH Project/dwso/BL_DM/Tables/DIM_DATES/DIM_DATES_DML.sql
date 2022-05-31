INSERT INTO DIM_DATES
    SELECT
        TO_CHAR(DATE_D, 'YYYY-MM-DD')                                    AS DATE_ID_DT,
        TRIM(TO_CHAR(DATE_D, 'Day', 'nls_date_language=english'))        AS DAY_NAME,
        TO_NUMBER(TO_CHAR(DATE_D, 'D'))                                  AS DAY_NUMBER_IN_WEEK,
        TO_NUMBER(TO_CHAR(DATE_D, 'DD'))                                 AS DAY_NUMBER_IN_MONTH,
        TO_NUMBER(TO_CHAR(DATE_D, 'iw'))                                 AS CALENDAR_WEEK_NUMBER,
        ( TRUNC(DATE_D, 'D') + 6 )                                       AS WEEK_ENDING_DAY,
        TO_CHAR(TRUNC(DATE_D, 'D') + 6)                                  AS WEEK_ENDING_DAY_ID,
        TO_NUMBER(TO_CHAR(DATE_D, 'mm'))                                 AS CALENDAR_MONTH_NUMBER,
        TRIM(TO_CHAR(DATE_D, 'Month', 'nls_date_language=english'))      AS CALENDAR_MONTH_DESCRIPTION,
        TO_CHAR(DATE_D, 'mm')                                            AS CALENDAR_MONTH_ID,
        TO_NUMBER(ADD_MONTHS(DATE_D, 1) - DATE_D)                        AS DAYS_IN_CALEND_MONTH,
        TO_CHAR(LAST_DAY(DATE_D))                                        AS END_OF_CALENDAR_MONTH,
        TRIM(TO_CHAR(DATE_D, 'Month', 'nls_date_language=english'))      AS CALENDAR_MONTH_NAME,
        TO_CHAR(DATE_D, 'Q')                                             AS CALENDAR_QUATER_DESCRIPTION,
        TO_CHAR(DATE_D, 'Q')                                             AS CALENDAR_QUATER_ID,
        LAST_DAY(ADD_MONTHS(TRUNC(DATE_D, 'Q'), 2)) - TRUNC(DATE_D, 'Q') AS DAYS_IN_CALEND_QUATER,
        LAST_DAY(ADD_MONTHS(TRUNC(DATE_D, 'Q'), 2))                      AS END_OF_CALENDAR_QUATER,
        TO_NUMBER(TO_CHAR(DATE_D, 'Q'))                                  AS CALENDAR_QUATER_NUMBER,
        TO_NUMBER(TO_CHAR(DATE_D, 'YYYY'))                               AS CALENDAR_YEAR,
        TO_CHAR(DATE_D, 'YYYY')                                          AS CALENDAR_YEAR_ID,
        ADD_MONTHS(TRUNC(DATE_D, 'YEAR'), 12) - TRUNC(DATE_D, 'YEAR')    AS DAYS_IN_CALEND_YEAR,
        ADD_MONTHS(TRUNC(DATE_D, 'YEAR'), 12) - 1                        AS END_OF_CALENDAR_YEAR
    FROM
        (
            SELECT
                TO_DATE('1970-01-01', 'YYYY-MM-DD') + ROWNUM AS DATE_D
            FROM
                SYS.DUAL
            CONNECT BY
                LEVEL <= TO_DATE('2030-12-31', 'YYYY-MM-DD') - TO_DATE('1970-01-01', 'YYYY-MM-DD')
        ) "CALENDAR";

COMMIT;