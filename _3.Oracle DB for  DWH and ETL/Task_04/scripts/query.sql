CREATE TABLE t2 AS
SELECT TRUNC( rownum / 100 ) id, rpad( rownum,100 ) t_pad
 FROM dual
CONNECT BY rownum < 100000;
CREATE INDEX t2_idx1 ON t2 ( id );
SELECT blocks FROM user_segments WHERE segment_name = 'T2';
SELECT COUNT(DISTINCT (dbms_rowid.rowid_block_number(rowid))) block_ct FROM t2 ;
SELECT COUNT( * ) FROM t2;
DELETE FROM t2;
SELECT blocks FROM user_segments WHERE segment_name = 'T2';
SELECT COUNT(DISTINCT (dbms_rowid.rowid_block_number(rowid))) block_ct FROM t2 ;
SELECT COUNT( * ) FROM t2;
INSERT INTO t2 ( ID, T_PAD )
 VALUES ( 1,'1' );
COMMIT;
SELECT blocks FROM user_segments WHERE segment_name = 'T2';
SELECT COUNT(DISTINCT (dbms_rowid.rowid_block_number(rowid))) block_ct FROM t2 ;
SELECT COUNT( * ) FROM t2;
 TRUNCATE TABLE t2;
 SELECT blocks FROM user_segments WHERE segment_name = 'T2';
SELECT COUNT(DISTINCT (dbms_rowid.rowid_block_number(rowid))) block_ct FROM t2 ;
SELECT COUNT( * ) FROM t2;
Drop table t2;
--------------------------------------------------------------------------------
CREATE TABLE t2 AS
SELECT TRUNC( rownum / 100 ) id, rpad( rownum,100 ) t_pad
 FROM dual
CONNECT BY rownum < 100000;
CREATE INDEX t2_idx1 ON t2 ( id );

CREATE TABLE t1 AS
SELECT MOD( rownum, 100 ) id, rpad( rownum,100 ) t_pad
 FROM dual
CONNECT BY rownum < 100000;
CREATE INDEX t1_idx1 ON t1 ( id );

EXEC dbms_stats.gather_table_stats( USER,'t1',method_opt=>'FOR ALL COLUMNS SIZE 1',CASCADE=>TRUE );
EXEC dbms_stats.gather_table_stats( USER,'t2',method_opt=>'FOR ALL COLUMNS SIZE 1',CASCADE=>TRUE );
 SELECT t.table_name||'.'||i.index_name idx_name,
 i.clustering_factor,
 t.blocks,
 t.num_rows
 FROM user_indexes i, user_tables t
 WHERE i.table_name = t.table_name
 AND t.table_name IN( 'T1','T2' );

-------------------------------------------------------------------------------
CREATE UNIQUE INDEX udx_t1 ON t1( t_pad );
SELECT t1.* FROM t1 where t1.t_pad = '1';
-------------------------------------------------------------------------------
 SELECT t2.* FROM t2 where t2.id = rpad ('1', 100);
-------------------------------------------------------------------------------
 CREATE TABLE employees AS
 SELECT *
 FROM scott.emp;
 CREATE INDEX idx_emp01 ON employees
 ( empno, ename, job );

 SELECT /*+INDEX_SS(emp idx_emp01)*/ emp.* FROM employees emp where ename = 'SCOTT';

SELECT /*+FULL*/ emp.* FROM employees emp WHERE ename = 'SCOTT';
--------------------------------------------------------------------------------

Explain plan for
Select  c.first_name, c.last_name, sum(s.sale_price), sum(s.sale_cost), sum(s.sale_price-s.sale_cost) as profit
from ce_sales s
inner join ce_customers c
on s.customer_id=c.customer_id
inner join ce_countries c2
on c2.country_id=c.country_id
Where c.first_name!='N/A' and c.last_name!='N/A' and c2.country in('Poland', 'Germany','United States of America','Spain' )
Group by  c.first_name, c.last_name
order by sum(s.sale_price-s.sale_cost) desc;
select * from table(dbms_xplan.display);

Explain plan for
Select b.product_brand,pt.product_type_id, sum(s.sale_price-s.sale_cost) as profit
From ce_sales s
inner join ce_products p
on p.product_id=s.product_id
inner join ce_brands b
on b.product_brand_id=p.product_brand_id
inner join ce_product_types pt
on pt.product_type_id=p.product_type_id
group by b.product_brand,pt.product_type_id
order by sum(s.sale_price-s.sale_cost) desc;

select * from table(dbms_xplan.display);






Explain plan for
Select 
c3.channel_description, c2.country, sum(s.sale_price-s.sale_cost) as profit
from ce_sales s
inner join ce_stores s2
on s.store_id=s2.store_id
inner join ce_addresses a 
on a.address_id=s2.address_id
inner join CE_CITIES c
on c.city_id=a.city_id
inner join ce_states s3
on s3.state_id=c.state_id
inner join ce_countries c2
on c2.country_id=s3.country_id
inner join ce_channels c3
on s.channel_id=c3.channel_id
where c2.country_id in
(Select country_id
From ce_countries
where country in ('Poland','United States of America','Spain' ))
Group by  c3.channel_description, c2.country
having sum(s.sale_price-s.sale_cost)>10000
order by sum(s.sale_price-s.sale_cost) desc;

select * from table(dbms_xplan.display);

--------------------------------------------------------------------------------
create MATERIALIZED VIEW sum_by_countries_ch
as
Select
c3.channel_description, c2.country, sum(s.sale_price-s.sale_cost) as profit
from ce_sales s
inner join ce_stores s2
on s.store_id=s2.store_id
inner join ce_addresses a 
on a.address_id=s2.address_id
inner join CE_CITIES c
on c.city_id=a.city_id
inner join ce_states s3
on s3.state_id=c.state_id
inner join ce_countries c2
on c2.country_id=s3.country_id
inner join ce_channels c3
on s.channel_id=c3.channel_id
Group by  c3.channel_description, c2.country;

Explain plan for
Select channel_description, country,  profit
from sum_by_countries_ch
where country in ('Poland','United States of America','Spain' ) and profit >10000
order by   profit desc;
select * from table(dbms_xplan.display);



