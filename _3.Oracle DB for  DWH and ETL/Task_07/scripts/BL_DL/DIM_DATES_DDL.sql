
CREATE TABLE DIM_DATES
  (DATE_ID_DT VARCHAR2(20) PRIMARY KEY,  
  DAY_NAME VARCHAR2(20) NOT NULL ,  
  DAY_NUMBER_IN_WEEK NUMBER  NOT NULL,
  DAY_NUMBER_IN_MONTH NUMBER   NOT NULL,
  CALENDAR_WEEK_NUMBER NUMBER  NOT NULL, 
  WEEK_ENDING_DAY DATE  NOT NULL ,
  WEEK_ENDING_DAY_ID VARCHAR2(20) NOT NULL ,
  CALENDAR_MONTH_NUMBER NUMBER  NOT NULL , 
  CALENDAR_MONTH_DESCRIPTION VARCHAR2(20)  NOT NULL, 
  CALENDAR_MONTH_ID NUMBER  NOT NULL,
  DAYS_IN_CALEND_MONTH NUMBER  NOT NULL,
  END_OF_CALENDAR_MONTH DATE  NOT NULL,
  CALENDAR_MONTH_NAME VARCHAR2(20)  NOT NULL,
  CALENDAR_QUATER_DESCRIPTION VARCHAR2(20)  NOT NULL, 
  CALENDAR_QUATER_ID VARCHAR2(20)  NOT NULL,  
  DAYS_IN_CALEND_QUATER NUMBER  NOT NULL,
  END_OF_CALENDAR_QUATER DATE  NOT NULL,
  CALENDAR_QUATER_NUMBER VARCHAR2(20)  NOT NULL,
  CALENDAR_YEAR NUMBER  NOT NULL,
  CALENDAR_YEAR_ID NUMBER  NOT NULL,
  DAYS_IN_CALEND_YEAR NUMBER  NOT NULL,
  END_OF_CALENDAR_YEAR DATE  NOT NULL
    ); 