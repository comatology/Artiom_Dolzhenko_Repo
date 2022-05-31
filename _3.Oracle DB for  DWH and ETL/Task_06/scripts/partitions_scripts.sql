
drop table BL_3NF.CE_SALES cascade constraints;
create table BL_3NF.CE_SALES(
    SALE_ID                         number(38)          not null,
    SALE_SOURCE_SYSTEM              varchar2(50 char)   not null,
    SALE_SOURCE_ENTITY              varchar2(50 char)   not null,   
    PRODUCT_ID                      number(38)          not null,
    DATE_ID                         date                not null,
    PROMOTION_ID                    number(38)          not null,
    CHANNEL_ID                      number(38)          not null,
    STORE_ID                        number(38)          not null,
    EMPLOYEE_ID                     number(38)          not null,
    CUSTOMER_ID                     number(38)          not null,
    SALE_COST                       number(15,3)        ,
    SALE_PRICE                      number(15,3)        ,
    SALE_QUANTITY                   number(38)          ,
    TA_UPDATE_DT                    date                not null,
    TA_INSERT_DT                    date                not null

)
partition by range (DATE_ID)
(
partition PART_1 values less than (to_date ('01/02/2020','dd/mm/yyyy')),
partition PART_2 values less than (to_date ('01/03/2020','dd/mm/yyyy')),
partition PART_3 values less than (to_date ('01/04/2020','dd/mm/yyyy')),
partition PART_4 values less than (to_date ('01/05/2020','dd/mm/yyyy')),
partition PART_5 values less than (to_date ('01/06/2020','dd/mm/yyyy')),
partition PART_6 values less than (to_date ('01/07/2020','dd/mm/yyyy')),
partition PART_7 values less than (to_date ('01/08/2020','dd/mm/yyyy')),
partition PART_8 values less than (to_date ('01/09/2020','dd/mm/yyyy')),
partition PART_9 values less than (to_date ('01/10/2020','dd/mm/yyyy')),
partition PART_10 values less than (to_date ('01/11/2020','dd/mm/yyyy')),
partition PART_11 values less than (to_date ('01/12/2020','dd/mm/yyyy')),
partition PART_12 values less than (to_date ('01/01/2021','dd/mm/yyyy')),
partition PART_13 values less than (to_date ('01/02/2021','dd/mm/yyyy')),
partition PART_14 values less than (to_date ('01/03/2021','dd/mm/yyyy')),
partition PART_15 values less than (to_date ('01/04/2021','dd/mm/yyyy')),
partition PART_16 values less than (to_date ('01/05/2021','dd/mm/yyyy')),
partition PART_17 values less than (to_date ('01/06/2021','dd/mm/yyyy')),
partition PART_18 values less than (to_date ('01/07/2021','dd/mm/yyyy')),
partition PART_19 values less than (to_date ('01/08/2021','dd/mm/yyyy')),
partition PART_20 values less than (to_date ('01/09/2021','dd/mm/yyyy')),
partition PART_21 values less than (to_date ('01/10/2021','dd/mm/yyyy')),
partition PART_22 values less than (to_date ('01/11/2021','dd/mm/yyyy')),
partition PART_23 values less than (to_date ('01/12/2021','dd/mm/yyyy')),
partition PART_24 values less than (to_date ('01/01/2022','dd/mm/yyyy'))
);

select * 
from CE_SALES
Partition (PART_1);

ALTER TABLE CE_SALES
      ADD PARTITION PART_21 VALUES LESS THAN (to_date ('31/12/2099','dd/mm/yyyy'));
      
select * 
  from ALL_TAB_PARTITIONS
where TABLE_NAME = 'CE_SALES';

Create table hash_example 
(hash_key_col date,
data varchar2(20))
Partition by hash (hash_key_col)
(
partition part_1,
partition part_2,
partition part_3
);
select * 
from ALL_TAB_PARTITIONS
where TABLE_NAME = 'HASH_EXAMPLE';

ALTER TABLE HASH_EXAMPLE COALESCE PARTITION;

select * 
from ALL_TAB_PARTITIONS
where TABLE_NAME = 'HASH_EXAMPLE';

ALTER TABLE CE_SALES DROP PARTITION PART_21
     UPDATE INDEXES;
select * 
from ALL_TAB_PARTITIONS
where TABLE_NAME = 'CE_SALES';

ALTER TABLE CE_SALES MERGE PARTITIONS PART_1,PART_2, PART_3 INTO PARTITION  Quater_1_2020;
ALTER TABLE CE_SALES MERGE PARTITIONS PART_4,PART_5, PART_6 INTO PARTITION  Quater_2_2020;
ALTER TABLE CE_SALES MERGE PARTITIONS PART_7,PART_8, PART_9 INTO PARTITION  Quater_3_2020;
ALTER TABLE CE_SALES MERGE PARTITIONS PART_10,PART_11, PART_12 INTO PARTITION  Quater_4_2020;
ALTER TABLE CE_SALES MERGE PARTITIONS PART_13,PART_14, PART_15 INTO PARTITION  Quater_1_2021;
ALTER TABLE CE_SALES MERGE PARTITIONS PART_16,PART_17, PART_18 INTO PARTITION  Quater_2_2021;
ALTER TABLE CE_SALES MERGE PARTITIONS PART_19,PART_20 INTO PARTITION  Quater_3_2021;
select * 
from ALL_TAB_PARTITIONS
where TABLE_NAME = 'CE_SALES';


CREATE TABLESPACE tbs_01 
   DATAFILE 'tbs_f2.dat' SIZE 100M 
   ONLINE;
   Select tablespace_name, file_name,bytes  from dba_data_files
   Where tablespace_name='TBS_01';
Select * from user_tab_partitions where table_name='CE_SALES'
   
Select table_name, partition_name, tablespace_name from user_tab_partitions where table_name='CE_SALES'
ALTER TABLE CE_SALES MOVE PARTITION Quater_3_2021
     TABLESPACE tbs_01 NOLOGGING COMPRESS;
   
   
ALTER TABLE CE_SALES SPLIT PARTITION Quater_1_2020 INTO 
  ( partition PART_1 values less than (to_date ('01/02/2020','dd/mm/yyyy')),
    partition PART_2 values less than (to_date ('01/03/2020','dd/mm/yyyy')),
    partition PART_3 );
    

Create table temp_part as
select * 
from CE_SALES Where date_id  > to_date ('01/09/2021','dd/mm/yyyy')

select * 
from CE_SALES
Partition (PART_21);

ALTER TABLE CE_SALES TRUNCATE PARTITION PART_21 UPDATE INDEXES;
select * 
from CE_SALES
Partition (PART_21);
Select count(*) from ce_sales;
Alter table ce_sales
Exchange partition Part_21
with table temp_part;
