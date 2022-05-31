-------------------------------------------
----------------create schema--------------
-------------------------------------------
drop schema user_dilab_student5;

create schema  user_dilab_student5;
Commit;


------------------------CREATING CUSTOMERS IN RS FROM S3

CREATE TABLE user_dilab_student5.dim_customers 
(   customer_surr_id    integer NOT NULL,
    source_system       VARCHAR(50) NOT NULL,
    source_entity       VARCHAR(50) NOT NULL,
    customer_src_id     VARCHAR(50) NOT NULL,
    customer_first_name VARCHAR(50) NOT NULL,
    customer_last_name  VARCHAR(50) NOT NULL,
    customer_gender     VARCHAR(50) NOT NULL,
    customer_birthday   DATE NOT NULL,
    customer_phone      VARCHAR(50) NOT NULL,
    update_dt           DATE NOT NULL,
    insert_dt           DATE NOT NULL
);
Commit;

copy user_dilab_student5.dim_customers (CUSTOMER_SURR_ID,SOURCE_SYSTEM,SOURCE_ENTITY,CUSTOMER_SRC_ID,CUSTOMER_FIRST_NAME,CUSTOMER_LAST_NAME,CUSTOMER_GENDER,CUSTOMER_BIRTHDAY,CUSTOMER_PHONE,UPDATE_DT,INSERT_DT)
from 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/dim_customers/dim_customers.scv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'DD-MON-YY'
IGNOREHEADER 1;
Commit;



------------------------------------------------------------------------------------
-----------------check compression types, distribution keys, sort keys--------------
------------------------------------------------------------------------------------
select 	pg_table_def.schemaname, pg_table_def.tablename, pg_table_def.column, pg_table_def.type, 
		pg_table_def.encoding, pg_table_def.distkey,pg_table_def.sortkey
from pg_table_def
where schemaname='user_dilab_student5'
and tablename ='dim_customers';

-------------------------------------------------------------------------------------
---------------------------------check distribution style----------------------------
-------------------------------------------------------------------------------------
select "schema", "table", diststyle 
from SVV_TABLE_INFO
where  "schema"='user_dilab_student5'
and "table" ='dim_customers';


CREATE TABLE user_dilab_student5.dim_dates (
    date_id                  	varchar (50)  ,
    day_name                    VARCHAR(20) ,
    day_number_in_week          integer ,
    day_number_in_month         integer ,
    calendar_week_number        integer NOT NULL,
    week_ending_day             DATE NOT NULL,
    week_ending_day_id          VARCHAR(20) NOT NULL,
    calendar_month_number       integer NOT NULL,
    calendar_month_description  VARCHAR(20) NOT NULL,
    calendar_month_id           integer NOT NULL,
    days_in_calend_month        integer NOT NULL,
    end_of_calendar_month       DATE NOT NULL,
    calendar_month_name         VARCHAR(20) NOT NULL,
    calendar_quater_description VARCHAR(20) NOT NULL,
    calendar_quater_id          VARCHAR(20) NOT NULL,
    days_in_calend_quater       integer NOT NULL,
    end_of_calendar_quater      DATE NOT NULL,
    calendar_quater_number      VARCHAR(20) NOT NULL,
    calendar_year               integer NOT NULL,
    calendar_year_id            integer NOT NULL,
    days_in_calend_year         integer NOT NULL,
    end_of_calendar_year        DATE NOT NULL
);
Commit;

select * from
stl_load_errors
limit 20;

copy user_dilab_student5.dim_dates (DATE_ID,DAY_NAME,DAY_NUMBER_IN_WEEK,DAY_NUMBER_IN_MONTH,CALENDAR_WEEK_NUMBER,WEEK_ENDING_DAY,WEEK_ENDING_DAY_ID,CALENDAR_MONTH_NUMBER,CALENDAR_MONTH_DESCRIPTION,CALENDAR_MONTH_ID,DAYS_IN_CALEND_MONTH,END_OF_CALENDAR_MONTH,CALENDAR_MONTH_NAME,CALENDAR_QUATER_DESCRIPTION,CALENDAR_QUATER_ID,DAYS_IN_CALEND_QUATER,END_OF_CALENDAR_QUATER,CALENDAR_QUATER_NUMBER,CALENDAR_YEAR,CALENDAR_YEAR_ID,DAYS_IN_CALEND_YEAR,END_OF_CALENDAR_YEAR)
from 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/dim_dates/dim_dates.scv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'DD-MON-YY'
IGNOREHEADER 1;
Commit;









CREATE TABLE user_dilab_student5.dim_payment_types (
    payment_type_surr_id integer NOT NULL,
    payment_type_srcid   VARCHAR(50) NOT NULL,
    source_system        VARCHAR(50) NOT NULL,
    source_entity        VARCHAR(50) NOT NULL,
	PAYMENT_TYPE		 VARCHAR(50) NOT NULL,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);







copy user_dilab_student5.dim_payment_types (PAYMENT_TYPE_SURR_ID,PAYMENT_TYPE_SRCID,SOURCE_SYSTEM,SOURCE_ENTITY,PAYMENT_TYPE,UPDATE_DT,INSERT_DT)
from 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/dim_payment_types/dim_payment_types.scv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'DD-MON-YY'
IGNOREHEADER 1;
COMMIT;



CREATE TABLE user_dilab_student5.dim_employees (
    employees_surr_id    integer NOT NULL,
    source_system        VARCHAR(50) NOT NULL,
    source_entity        VARCHAR(50) NOT NULL,
    employees_src_id     VARCHAR(50) NOT NULL,
    employees_first_name VARCHAR(50) NOT NULL,
    employees_last_name  VARCHAR(50) NOT NULL,
    employees_gender     VARCHAR(50) NOT NULL,
    employees_birthday   DATE NOT NULL,
    employees_phone      VARCHAR(50) NOT NULL,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);

COMMIT;


copy user_dilab_student5.dim_employees (EMPLOYEES_SURR_ID,SOURCE_SYSTEM,SOURCE_ENTITY,EMPLOYEES_SRC_ID,EMPLOYEES_FIRST_NAME,EMPLOYEES_LAST_NAME,EMPLOYEES_GENDER,EMPLOYEES_BIRTHDAY,EMPLOYEES_PHONE,UPDATE_DT,INSERT_DT)
from 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/dim_employees/dim_employees.scv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'DD-MON-YY'
IGNOREHEADER 1;
COMMIT;





CREATE TABLE user_dilab_student5.dim_stores (
    store_surr_id INTEGER NOT NULL,
    store_srcid   VARCHAR(50) NOT NULL,
    store_name    VARCHAR(50) NOT NULL,
    source_system VARCHAR(50) NOT NULL,
    source_entity VARCHAR(50) NOT NULL,
    START_DT 	  DATE NOT NULL,
    END_DT 		  DATE NOT NULL,
    city_id       INTEGER NOT NULL,
    city_name     VARCHAR(50) NOT NULL,
    country_id    INTEGER NOT NULL,
    country_name  VARCHAR(50) NOT NULL,
    update_dt     DATE NOT NULL,
    insert_dt     DATE NOT NULL
);
COMMIT;




copy user_dilab_student5.dim_stores (STORE_SURR_ID,STORE_SRCID,STORE_NAME,SOURCE_SYSTEM,SOURCE_ENTITY,START_DT,END_DT,CITY_ID,CITY_NAME,COUNTRY_ID,COUNTRY_NAME,UPDATE_DT,INSERT_DT)
from 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/dim_stores/dim_stores.scv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'DD-MON-YY'
IGNOREHEADER 1;
COMMIT;





CREATE TABLE user_dilab_student5.fct_sales (
    source_system        VARCHAR(50) NOT NULL,
    source_entity        VARCHAR(50) NOT NULL,
    product_surr_id      INTEGER NOT NULL,
    payment_type_surr_id INTEGER NOT NULL,
    promotion_surr_id    INTEGER NOT NULL,
    store_surr_id        INTEGER NOT NULL,
    employee_surr_id     INTEGER NOT NULL,
    customer_surr_id     INTEGER NOT NULL,
    date_id              DATE NOT NULL,
    unit_cost            INTEGER,
    unit_price           INTEGER,
    sales_quantity       INTEGER,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);
COMMIT;


select * from stl_load_errors;





copy user_dilab_student5.FCT_SALES (SOURCE_SYSTEM,SOURCE_ENTITY,PRODUCT_SURR_ID,PAYMENT_TYPE_SURR_ID,PROMOTION_SURR_ID,STORE_SURR_ID,EMPLOYEE_SURR_ID,CUSTOMER_SURR_ID,DATE_ID,UNIT_COST,UNIT_PRICE,SALES_QUANTITY,UPDATE_DT,INSERT_DT)
from 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/fct_sales/fct_sales.scv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'DD-MON-YY'
IGNOREHEADER 1;
COMMIT;





------------------------------------------------------------------------------------
-----------------check compression types, distribution keys, sort keys--------------
------------------------------------------------------------------------------------
select 	pg.schemaname, 
		pg.tablename, 
		pg.column, 
		pg.type, 
		pg.encoding, 
		pg.distkey,
		pg.sortkey
from pg_table_def pg
where schemaname='user_dilab_student5'
and tablename ='fct_sales';

-------------------------------------------------------------------------------------
---------------------------------check distribution style----------------------------
-------------------------------------------------------------------------------------
select "schema", "table", diststyle 
from SVV_TABLE_INFO
where  "schema"='user_dilab_student5'
and "table" ='fct_sales';

--------------------------------------------------------------------------------------------------------
----------------------Identify compression types -------------------------------------------------------
--------------------------------------------------------------------------------------------------------
select 	pg.schemaname, 
		pg.tablename, 
		pg.column, 
		pg.type, 
		pg.encoding
from pg_table_def pg
where schemaname='user_dilab_student5'
and tablename ='dim_customers';



CREATE TABLE user_dilab_student5.dim_customers_no_comp 
(   customer_surr_id    integer encode raw,
    source_system       VARCHAR encode raw,
    source_entity       VARCHAR encode raw,
    customer_src_id     VARCHAR encode raw,
    customer_first_name VARCHAR encode raw,
    customer_last_name  VARCHAR encode raw,
    customer_gender     VARCHAR encode raw,
    customer_birthday   DATE    encode raw,
    customer_phone      VARCHAR encode raw,
    update_dt           DATE    encode raw,
    insert_dt           DATE    encode raw
);
Commit;

insert into user_dilab_student5.dim_customers_no_comp
select * from user_dilab_student5.dim_customers; 


select count(*)
from user_dilab_student5.dim_customers_no_comp
limit 20;


--------------------------------------------------------------------------------------------------------
----------------------Identify compression types -------------------------------------------------------
--------------------------------------------------------------------------------------------------------
select 	pg.schemaname, 
		pg.tablename, 
		pg.column, 
		pg.type, 
		pg.encoding
from pg_table_def pg
where schemaname='user_dilab_student5'
and tablename ='dim_customers_no_comp';


select count(*) 
from user_dilab_student5.dim_customers_no_comp;


Analyze compression user_dilab_student5.dim_customers_no_comp 
comprows 87662;



CREATE TABLE user_dilab_student5.dim_customers_analyzed_comp 
(   customer_surr_id    integer encode AZ64,
    source_system       VARCHAR(50) encode ZSTD,
    source_entity       VARCHAR(50) encode ZSTD,
    customer_src_id     VARCHAR(50) encode ZSTD,
    customer_first_name VARCHAR(50) encode ZSTD,
    customer_last_name  VARCHAR(50) encode ZSTD,
    customer_gender     VARCHAR(50) encode ZSTD,
    customer_birthday   DATE    encode AZ64,
    customer_phone      VARCHAR(50) encode ZSTD,
    update_dt           DATE    encode AZ64,
    insert_dt           DATE    encode AZ64
);
Commit;

insert into user_dilab_student5.dim_customers_analyzed_comp
select * from user_dilab_student5.dim_customers; 


select count(*)
from user_dilab_student5.dim_customers_no_comp
limit 20;


------------------Compare size of tables  with default compression, without compression and analyzed 

create view  user_dilab_student5.default_table_size as (
SELECT
  TRIM(name) as table_name,
  TRIM(a.attname) AS column_name,
  COUNT(1) AS size
from svv_diskusage d JOIN pg_attribute a on     
  	d.col = a.attnum-1 AND
    d.tbl = a.attrelid
where d.tbl in(
				select table_id
				from svv_table_info
				where "schema"='user_dilab_student5'
				and "table"='dim_customers')
group by d.name, a.attname 
order by table_name, column_name);



create view  user_dilab_student5.withoutcomp_table_size as (
SELECT
  TRIM(name) as table_name,
  TRIM(a.attname) AS column_name,
  COUNT(1) AS size
FROM
  	svv_diskusage d JOIN pg_attribute a on     
  	d.col = a.attnum-1 AND
    d.tbl = a.attrelid
where d.tbl in(
				select table_id
				from svv_table_info
				where "schema"='user_dilab_student5'
				and "table"='dim_customers_no_comp')
group by d.name, a.attname 
order by table_name, column_name);


create view user_dilab_student5.analyzedcomp_table_size as (
SELECT
  TRIM(name) as table_name,
  TRIM(a.attname) AS column_name,
  COUNT(1) AS size
FROM
  	svv_diskusage d JOIN pg_attribute a on     
  	d.col = a.attnum-1 AND
    d.tbl = a.attrelid
where d.tbl in(
				select table_id
				from svv_table_info
				where "schema"='user_dilab_student5'
				and "table"='dim_customers_analyzed_comp')
group by d.name, a.attname 
order by table_name, column_name);

commit;


select  dts.column_name,
		dts."size" as default_size,
		wits."size" as without_comp_size,
		atz."size" as analyzed_comp_size
from default_table_size dts
inner join withoutcomp_table_size wits
on dts.column_name=wits.column_name
inner join analyzedcomp_table_size atz
on dts.column_name=atz.column_name
order by dts.column_name;


ALTER USER dilab_student5 SET enable_result_cache_for_session TO off;
commit;

---------------------------------------------------------------------
----------------------check diststyle and sort keys------------------
---------------------------------------------------------------------
select  "schema", 
		"table", 
		diststyle, 
		sortkey1 
from SVV_TABLE_INFO
where  "schema"='user_dilab_student5'
and ("table" ='fct_sales'
or "table" ='dim_dates'
or "table" ='dim_payment_types'
or "table" ='dim_stores'
or "table" ='dim_customers'
or "table" ='dim_employees');



commit;


---------------------------------------------------------------------
----------------------check diststyle and sort keys------------------
---------------------------------------------------------------------
select  "schema", 
		"table", 
		diststyle, 
		sortkey1 
from SVV_TABLE_INFO
where  "schema"='user_dilab_student5'
and ("table" ='fct_sales'
or "table" ='dim_dates'
or "table" ='dim_payment_types'
or "table" ='dim_stores'
or "table" ='dim_customers'
or "table" ='dim_employees');



commit;


--------------------------------------------------------------------
---------------------select for procedure---------------------------
--------------------------------------------------------------------





explain
select distinct ds.store_name, f.date_id, 
dpt.payment_type,
sum (f.sales_quantity) as quantity_sold,
sum (f.unit_price) as price_per_unit, 
sum (f.unit_price* f.sales_quantity)  as total_revenue
from user_dilab_student5.fct_sales f 
left join user_dilab_student5.dim_payment_types dpt  on dpt.payment_type_surr_id = f.payment_type_surr_id 
left join user_dilab_student5.dim_stores ds  on f.store_surr_id = ds.store_surr_id
where  date_id >= '2022-03-17'
group by f.date_id, f.product_surr_id, dpt.payment_type, ds.store_name
order by total_revenue desc;

--------------------------------------------------------------------------------------
---------------------check result cache off-------------------------------------------
--------------------------------------------------------------------------------------
select * from SVL_QLOG where elapsed  =114036;


alter table user_dilab_student5.fct_sales alter sortkey (unit_price,sales_quantity);
alter table user_dilab_student5.dim_stores  alter sortkey (store_name);


drop table user_dilab_student5.report;

create table user_dilab_student5.report(
store_name varchar,
date_id date,
payment_type varchar,
quantity_sold numeric(10,2),
price_per_unit numeric(10,2),
total_revenue numeric(10,2));
commit;

create or replace procedure user_dilab_student5.update_report(
store_name varchar,
date_id date,
payment_type varchar,
quantity_sold numeric(10,2),
price_per_unit numeric(10,2),
total_revenue numeric(10,2)
)
as $$
declare 
integer_val integer:=0;
begin 
raise info 'Procedure update_report started';
insert into user_dilab_student5.report (store_name,
										date_id, 
										payment_type,
										quantity_sold, 
										price_per_unit, 
										total_revenue)
select distinct ds.store_name, 
				f.date_id, 
				dpt.payment_type,
				sum (f.sales_quantity) as quantity_sold,
				sum (f.unit_price) as price_per_unit, 
				sum (f.unit_price* f.sales_quantity)  as total_revenue
from user_dilab_student5.fct_sales f 
left join user_dilab_student5.dim_payment_types dpt  
on dpt.payment_type_surr_id = f.payment_type_surr_id 
left join user_dilab_student5.dim_stores ds  
on f.store_surr_id = ds.store_surr_id
where  date_id >= '2022-03-17'
group by 	f.date_id, 
			f.product_surr_id, 
			dpt.payment_type, 
			ds.store_name
order by total_revenue desc
get diagnostics integer_val := row_count;
raise notice 'Table report inserted, rows: %',integer_val ;
exception
when others then raise exception 'errow message: %, error code: %',sqlerrm, sqlstate;
end;
$$ language plpgsql;


select *
from user_dilab_student5.report;







------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------COPY TASK-----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-----------------------create tables----------------------
----------------------------------------------------------
CREATE TABLE lineorder_1
(
 lo_orderkey bigint NOT null ,
 lo_linenumber bigint NOT NULL,
 lo_custkey bigint NOT NULL,
 lo_partkey bigint NOT NULL,
 lo_suppkey bigint NOT NULL,
 lo_orderdate bigint NOT NULL,
 lo_orderpriority VARCHAR(20) NOT NULL,
 lo_shippriority VARCHAR(5) NOT NULL,
 lo_quantity bigint NOT NULL,
 lo_extendedprice bigint NOT NULL,
 lo_ordertotalprice bigint NOT NULL,
 lo_discount bigint NOT NULL,
 lo_revenue bigint NOT NULL,
 lo_supplycost bigint NOT NULL,
 lo_tax bigint NOT NULL,
 lo_commitdate bigint NOT NULL,
 lo_shipmode VARCHAR(15) NOT NULL
);

CREATE TABLE lineorder_2
(
 lo_orderkey bigint NOT null ,
 lo_linenumber bigint NOT NULL,
 lo_custkey bigint NOT NULL,
 lo_partkey bigint NOT NULL,
 lo_suppkey bigint NOT NULL,
 lo_orderdate bigint NOT NULL,
 lo_orderpriority VARCHAR(20) NOT NULL,
 lo_shippriority VARCHAR(5) NOT NULL,
 lo_quantity bigint NOT NULL,
 lo_extendedprice bigint NOT NULL,
 lo_ordertotalprice bigint NOT NULL,
 lo_discount bigint NOT NULL,
 lo_revenue bigint NOT NULL,
 lo_supplycost bigint NOT NULL,
 lo_tax bigint NOT NULL,
 lo_commitdate bigint NOT NULL,
 lo_shipmode VARCHAR(15) NOT NULL
);


--------------------------------------------------------------
--------------------------copy data to tables-----------------
--------------------------------------------------------------
copy lineorder_1
from 's3://dilabbucket/files/lineorder_file/'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
gzip
DATEFORMAT AS 'auto'
IGNOREHEADER 1;
copy lineorder_2
from 's3://dilabbucket/files/lineorders/'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
format as parquet;


--------------------------------------------------
-----------------------log time of queries--------
--------------------------------------------------
insert into temp_table_times  (querytxt, starttime, endtime,diff)
	select querytxt, starttime, endtime,datediff(millisecond,starttime,endtime)
	from stl_query where userid=107
	and querytxt like 'copy lineorder_1%'
	order by starttime desc limit 20;
insert into temp_table_times  (querytxt, starttime, endtime,diff)
	select querytxt, starttime, endtime,datediff(millisecond,starttime,endtime)
	from stl_query where userid=107
	and querytxt like 'copy lineorder_2%'
	order by starttime desc limit 20;


-----------------------------------------------------------------------------
-------------------check results---------------------------------------------
-----------------------------------------------------------------------------
select * from temp_table_times order by starttime desc;
select count (*) from lineorder_1;
select count (*) from lineorder_2;

































------------------------------------------------------------------------------
------------------------create external schema--------------------------------
------------------------------------------------------------------------------
create external schema if not exists user_dilab_student5_ext
from data catalog
database 'artiom_dolzhenko_database'
IAM_ROLE 'arn:aws:iam::260586643565:role/dilab-redshift-role'
commit;

-------------------------------------------------------------------------------
-----------------------check external schema-----------------------------------
-------------------------------------------------------------------------------
select * from pg_catalog.svv_external_schemas 
where schemaname ='user_dilab_student5_ext';



--------------------------------------------------------------------------------
------------------------------upload data to s3---------------------------------
--------------------------------------------------------------------------------
unload ('Select * from fct_sales
			Where extract (year from date_id)=2022
			and extract (MONTH from date_id)=1;')   
to 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/sales_2022-01/' 
iam_role 'arn:aws:iam::260586643565:role/dilab-redshift-role';
unload ('Select * from fct_sales
			Where extract (year from date_id)=2022
			and extract (MONTH from date_id)=2;')   
to 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/sales_2022-02/' 
iam_role 'arn:aws:iam::260586643565:role/dilab-redshift-role';
unload ('Select * from fct_sales
			Where extract (year from date_id)=2022
			and extract (MONTH from date_id)=3')   
to 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/sales_2022-03/' 
iam_role 'arn:aws:iam::260586643565:role/dilab-redshift-role';

----------------------------------------------------------------------------
-------------------------------create external table------------------------
----------------------------------------------------------------------------
CREATE external TABLE  user_dilab_student5_ext.FCT_SALES_EXT_PART
   ("source_system"        VARCHAR(50) ,
    "source_entity"        VARCHAR(50) ,
    "product_surr_id"      INTEGER ,
    "payment_type_surr_id" INTEGER ,
    "promotion_surr_id"    INTEGER ,
    "store_surr_id"        INTEGER ,
    "employee_surr_id"    INTEGER ,
    "customer_surr_id"     INTEGER ,
    "date_id"              DATE ,
    "unit_cost"            numeric(10,2),
    "unit_price"           numeric(10,2),
    "sales_quantity"       numeric,
    "update_dt"           DATE ,
    "insert_dt"            DATE 
   )
partitioned by (DATE_ID varchar)
row format delimited
fields terminated by '|'
stored as textfile
location 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/fct_sales/';

commit;
--------------------------------------------------------------------------
--------------------add partitions----------------------------------------
--------------------------------------------------------------------------

alter table user_dilab_student5_ext.FCT_SALES_EXT_PART add 
partition (DATE_ID='2022-01')
location 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/sales_2022-01/'
partition (DATE_ID='2022-02')
location 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/sales_2022-02/'
partition (DATE_ID='2022-03')
location 's3://artiom-dolzhenko-aws-bucket/stores/bl_dm/sales_2022-03/';


-----------------------------------------------------------
--------------------------show partition------------------- 
----------------------------------------------------------- 
select * from user_dilab_student5_ext.FCT_SALES_EXT_PART
where DATE_ID='2022-01'
limit 30;
select * from user_dilab_student5_ext.FCT_SALES_EXT_PART
where DATE_ID='2022-02'
limit 30;
select * from user_dilab_student5_ext.FCT_SALES_EXT_PART
where DATE_ID='2022-03'
limit 30;

------------------------------------------------------------------
---------------------comparation of tables------------------------
------------------------------------------------------------------
select 	extern.row_count as ex_count,
		intern.row_count as in_count,
CASE 
	 WHEN extern.row_count=intern.row_count
	 THEN '0' 
	 ELSE 'error'
	 end as status 
from 
		(select 1 as "key",
		'external' as table_type,
		count(*)  as row_count 
		from user_dilab_student5_ext.FCT_SALES_EXT_PART
		where  DATE_ID='2022-01') extern
inner join (Select  1 as "key",
			'internal' as table_type,
			count (*) as row_count
			from fct_sales
			Where extract (year from date_id)=2022
			and extract (MONTH from date_id)=1) intern
on extern."key"=intern."key";

select 	extern.row_count as ex_count,
		intern.row_count as in_count,
	CASE 
	 WHEN extern.row_count=intern.row_count
	 THEN '0' 
	 ELSE 'error'
	 end as status 
from 
		(select 1 as "key",
		'external' as table_type,
		count(*)  as row_count 
		from user_dilab_student5_ext.FCT_SALES_EXT_PART
		where  DATE_ID='2022-02') extern
inner join (Select  1 as "key",
			'internal' as table_type,
			count (*) as row_count
			from fct_sales
			Where extract (year from date_id)=2022
			and extract (MONTH from date_id)=2) intern
on extern."key"=intern."key";

select 	extern.row_count as ex_count,	
		intern.row_count as in_count,
	CASE 
	 WHEN extern.row_count=intern.row_count
	 THEN '0' 
	 ELSE 'error'
	 end as status 
from 
		(select 1 as "key",
		'external' as table_type,
		count(*)  as row_count 	
		from user_dilab_student5_ext.FCT_SALES_EXT_PART
		where  DATE_ID='2022-03') extern
inner join (Select  1 as "key",
			'internal' as table_type,
			count (*) as row_count
			from fct_sales
			Where extract (year from date_id)=2022
			and extract (MONTH from date_id)=3) intern
on extern."key"=intern."key";


-------------------------------------------------------------------------------------------------
------------------------------------------query plans--------------------------------------------
-------------------------------------------------------------------------------------------------
explain
Select  * from  user_dilab_student5_ext.FCT_SALES_EXT_PART Where extract (year from date_id)=2022
and extract (MONTH from date_id)=1;
explain
Select  * from  user_dilab_student5_ext.FCT_SALES_EXT_PART where  DATE_ID='2022-01';





-------------------------------------------------------
-------------check time of query execution-------------
-------------------------------------------------------
select * from temp_table_times order by starttime desc;
