--SYSTEM schema
GRANT all PRIVILEGES TO BL_CL;
--create view
CREATE MATERIALIZED VIEW bl_cl.sales_by_channels_com
REFRESH  ON COMMIT 
AS 
SELECT c.channel_id,c.channel_description,sum(s.sale_cost) as cost_by_channel, sum(s.sale_price) as sale_by_channel
FROM bl_3nf.ce_sales s
INNER JOIN bl_3nf.ce_channels c
ON s.channel_id=c.channel_id
GROUP BY  c.channel_id,c.channel_description;

--check
Select * from bl_cl.sales_by_channels_com;

--modify_tables
DELETE FROM bl_3nf.ce_sales
WHERE channel_id=3;
commit;

--check
Select * from bl_cl.sales_by_channels_com;

