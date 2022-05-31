DROP TABLE SA_SOURCE_SYSTEM_1.EMPLOYEES;
CREATE TABLE SA_SOURCE_SYSTEM_1.EMPLOYEES(
  employee_id VARCHAR2(100),
  employee_name VARCHAR2(100),
  employee_last_name VARCHAR2(100),
  employee_birthday VARCHAR2(100),
  employee_position_id VARCHAR2(100),
  employee_position VARCHAR2(100),
  employee_phone  VARCHAR2(100),
  employee_email VARCHAR2(100),
  employee_address VARCHAR2(100),
  employee_cointry VARCHAR2(100)
 


)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
  DEFAULT DIRECTORY SOURCE_1
  ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL (
                    employee_id CHAR(100),
  employee_name CHAR(100),
  employee_last_name CHAR(100),
  employee_birthday CHAR(100),
  employee_position_id CHAR(100),
  employee_position CHAR(100),
  employee_phone  CHAR(100),
  employee_email CHAR(100),
  employee_address CHAR(100),
  employee_cointry CHAR(100)))

  LOCATION (SOURCE_1:'employees.csv')  
) ;