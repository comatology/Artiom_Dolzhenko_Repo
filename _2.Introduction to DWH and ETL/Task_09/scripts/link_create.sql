--Before check
-- All DB links defined in the database, from system user
Select * from DBA_DB_LINKS ;

-- All DB links the current user has access to
Select * from ALL_DB_LINKS ;

-- All DB links owned by current user
Select * from USER_DB_LINKS ;

SELECT * FROM BL_3nf.ce_stores;

--privileges from system user
GRANT CREATE DATABASE LINK TO SA_SOURCE_SYSTEM_1;
-- create link
CREATE DATABASE LINK mydblink
CONNECT TO "BL_3NF" IDENTIFIED BY "BL_3NF"
USING '(DESCRIPTION =
(ADDRESS_LIST =
  (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
)
(CONNECT_DATA =
  (SERVICE_NAME = XE)
)
)';
-- After check
-- All DB links defined in the database, from system user
Select * from DBA_DB_LINKS ;

-- All DB links the current user has access to
Select * from ALL_DB_LINKS ;

-- All DB links owned by current user
Select * from USER_DB_LINKS ;

SELECT * FROM BL_3nf.ce_stores@mydblink;


