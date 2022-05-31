
INSERT INTO DIM_DATES
SELECT  TO_CHAR(DATE_D,'YYYY-MM-DD') AS DATE_ID_DT,
                 TRIM(TO_CHAR(DATE_D,'Day','nls_date_language=english')) AS DAY_NAME,
                 TO_NUMBER(TO_CHAR(DATE_D,'D')) AS DAY_NUMBER_IN_WEEK,
                 TO_NUMBER(TO_CHAR(DATE_D,'DD')) AS DAY_NUMBER_IN_MONTH,
                 TO_NUMBER(TO_CHAR(DATE_D,'iw')) AS CALENDAR_WEEK_NUMBER,
                (trunc(DATE_D,'D') + 6)  as WEEK_ENDING_DAY,
                 TO_CHAR(trunc(DATE_D,'D') + 6)  as WEEK_ENDING_DAY_ID,
                 TO_NUMBER(TO_CHAR(DATE_D,'mm')) AS CALENDAR_MONTH_NUMBER,
                 TRIM(TO_CHAR(DATE_D,'Month','nls_date_language=english')) AS CALENDAR_MONTH_DESCRIPTION,
                 TO_CHAR(DATE_D,'mm') as CALENDAR_MONTH_ID,
                 TO_NUMBER(add_months(DATE_D, 1)-DATE_D) as DAYS_IN_CALEND_MONTH,
                 to_char(LAST_DAY(DATE_D))  as END_OF_CALENDAR_MONTH,
                 TRIM(TO_CHAR(DATE_D,'Month','nls_date_language=english')) AS CALENDAR_MONTH_NAME,
                 to_char(DATE_D, 'Q') as CALENDAR_QUATER_description,
                 to_char(DATE_D, 'Q') as CALENDAR_QUATER_ID,
                 last_day(add_months(TRUNC(DATE_D, 'Q'),2))- TRUNC(DATE_D, 'Q')as  DAYS_IN_CALEND_QUATER,
                 last_day(add_months(TRUNC(DATE_D, 'Q'),2)) AS END_OF_CALENDAR_QUATER,
                 TO_NUMBER(to_char(DATE_D, 'Q')) as CALENDAR_QUATER_NUMBER,
                 TO_NUMBER(TO_CHAR(DATE_D,'YYYY')) AS CALENDAR_YEAR,
                 TO_CHAR(DATE_D,'YYYY') AS CALENDAR_YEAR_ID,
                 ADD_MONTHS(TRUNC(DATE_D,'YEAR'),12)-TRUNC(DATE_D,'YEAR') as   DAYS_IN_CALEND_YEAR,
                 ADD_MONTHS(TRUNC (DATE_D, 'YEAR'), 12) - 1 as END_OF_CALENDAR_YEAR
                                
   FROM 
             (
                 SELECT TO_DATE('1970-01-01','YYYY-MM-DD') + ROWNUM AS DATE_D
                 FROM SYS.dual
                  CONNECT BY LEVEL <= TO_DATE('2030-12-31','YYYY-MM-DD')-TO_DATE('1970-01-01','YYYY-MM-DD')
             ) "Calendar";
                  

COMMIT;
       

