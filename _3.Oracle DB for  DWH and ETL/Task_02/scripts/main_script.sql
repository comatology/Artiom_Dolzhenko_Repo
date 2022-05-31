--System_block
alter session set "_oracle_script"=true;
create tablespace tbs_lab datafile 'db_lab_001.dat' size 5M autoextend ON next 5M
MAXSIZE 100M;
create user OR_DEF identified by admin default tablespace tbs_lab;
grant connect to OR_DEF;
grant resource to OR_DEF;
grant select on scott.dept to OR_DEF;
grant select on scott.emp to OR_DEF;
ALTER USER OR_DEF QUOTA 100M ON tbs_lab;
SELECT name,value
  FROM v$parameter
 WHERE name = 'db_block_size';
--
create table t
 ( a int,
 b varchar2(4000) default rpad('*',4000,'*'),
 c varchar2(3000) default rpad('*',3000,'*')
 );
insert into t (a) values ( 1);
insert into t (a) values ( 2);
insert into t (a) values ( 3);
commit;
delete from t where a = 2 ;
commit;
insert into t (a) values ( 4);
commit;
select a from t;
drop table t;
---------------------------------------------------------

create table t2 ( x int primary key, y clob, z blob );
select segment_name, segment_type from user_segments;
Create table t (
x int primary key,
y clob,
z blob
);
SEGMENT CREATION IMMEDIATE;
select segment_name, segment_type from user_segments;
insert into t2 (x) values ( 1);
commit;
select segment_name, segment_type from user_segments;
SELECT DBMS_METADATA.GET_DDL('TABLE','T') FROM dual;

--------------------------------------------------
CREATE TABLE emp AS
SELECT
 object_id empno
, object_name ename
, created hiredate
, owner job
FROM
 all_objects;
alter table emp add constraint emp_pk primary key(empno);

begin
 dbms_stats.gather_table_stats( user, 'EMP', cascade=>true );
end;

CREATE TABLE heap_addresses
 (
 empno REFERENCES emp(empno) ON DELETE CASCADE,
 addr_type VARCHAR2(10),
 street VARCHAR2(20),
 city VARCHAR2(20),
 state VARCHAR2(2),
 zip NUMBER,
 PRIMARY KEY (empno,addr_type)
 );
 
 CREATE TABLE iot_addresses
 (
 empno REFERENCES emp(empno) ON DELETE CASCADE,
 addr_type VARCHAR2(10),
 street VARCHAR2(20),
 city VARCHAR2(20),
 state VARCHAR2(2),
 zip NUMBER,
 PRIMARY KEY (empno,addr_type)
 )
 ORGANIZATION INDEX


INSERT INTO heap_addresses
SELECT empno, 'WORK' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO iot_addresses
SELECT empno , 'WORK' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO heap_addresses
SELECT empno, 'HOME' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO iot_addresses
SELECT empno, 'HOME' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO heap_addresses
SELECT empno, 'PREV' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO iot_addresses
SELECT empno, 'PREV' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO heap_addresses
SELECT empno, 'SCHOOL' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
INSERT INTO iot_addresses
SELECT empno, 'SCHOOL' , '123 main street' , 'Washington' , 'DC' , 20123 FROM emp;
Commit;


exec dbms_stats.gather_table_stats( 'OR_DEF', 'HEAP_ADDRESSES');
exec dbms_stats.gather_table_stats( 'OR_DEF', 'IOT_ADDRESSES' );


SELECT *
 FROM emp ,
 heap_addresses
 WHERE emp.empno = heap_addresses.empno
 AND emp.empno = 42;
 

SELECT *
 FROM emp ,
 iot_addresses
 WHERE emp.empno = iot_addresses.empno
 AND emp.empno = 42;



select * from table(dbms_xplan.display_cursor(sql_id=>'null', format=>'ALLSTATS LAST'))

select * from table(dbms_xplan.display_cursor(sql_id=>'2r2nsckxt70qm', format=>'ALLSTATS LAST'));


---------------------------------------
CREATE TABLE row_mig_chain_demo (
  x int PRIMARY KEY,
  a CHAR(1000),
  b CHAR(1000),
  c CHAR(1000),
  d CHAR(1000),
  e CHAR(1000),
  f CHAR(1000),
  j CHAR(1000),
  i CHAR(1000),
  k CHAR(1000));
  
INSERT INTO row_mig_chain_demo (x) VALUES (1);
INSERT INTO row_mig_chain_demo (x) VALUES (2);
INSERT INTO row_mig_chain_demo (x) VALUES (3);
COMMIT;

SELECT * FROM row_mig_chain_demo;
  
  


  --Check for chained rows:

 SELECT a.name, b.value
  FROM v$statname a, v$mystat b
 WHERE a.statistic# = b.statistic#
   AND lower(a.name) = 'table fetch continued row';
   
   
UPDATE row_mig_chain_demo SET a = 'z1', b = 'z2', c = 'z3' WHERE x = 3;
COMMIT;
UPDATE row_mig_chain_demo SET a = 'y1', b = 'y2', c = 'y3' WHERE x = 2;
COMMIT;
UPDATE row_mig_chain_demo SET a = 'w1', b = 'w2', c = 'w3' WHERE x = 1;
COMMIT;

SELECT * FROM row_mig_chain_demo WHERE x = 1;