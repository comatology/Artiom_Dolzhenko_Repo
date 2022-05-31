DROP TABLE SA_SOURCE_SYSTEM_1.SRC_EMPLOYEES ;
CREATE TABLE SA_SOURCE_SYSTEM_1.SRC_EMPLOYEES(
  employee_id VARCHAR2(100),
  employee_name VARCHAR2(100),
  employee_last_name VARCHAR2(100),
  employee_birthday VARCHAR2(100),
  employee_position_id VARCHAR2(100),
  employee_position VARCHAR2(100),
  employee_phone  VARCHAR2(100),
  employee_email VARCHAR2(100),
  employee_address VARCHAR2(100),
  employee_country VARCHAR2(100),
 TA_UPDATE_DT DATE NOT NULL,
 TA_INSERT_DT DATE NOT NULL
);