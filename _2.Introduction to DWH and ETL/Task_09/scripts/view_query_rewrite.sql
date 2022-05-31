GRANT GLOBAL QUERY REWRITE TO BL_CL; --SYSTEM SCHEMA

SElECT c2.country, sum(s.sale_cost) as cost_by_channel, sum(s.sale_price) as sale_by_channel
FROM bl_3nf.ce_sales s
inner join bl_3nf.ce_stores s2
on s.store_id=s2.store_id
inner join bl_3nf.ce_addresses a
on s2.address_id=a.address_id
inner join bl_3nf.ce_cities c
on a.city_id = c.city_id
inner join bl_3nf.ce_states s3
on s3.state_id=c.state_id
inner join BL_3NF.ce_countries c2
on c2.country_id=c2.country_id
group by c2.country;

CREATE MATERIALIZED VIEW bl_cl.sales_by_countries
ENABLE QUERY REWRITE 
AS SElECT c2.country, sum(s.sale_cost) as cost_by_channel, sum(s.sale_price) as sale_by_channel
FROM bl_3nf.ce_sales s
inner join bl_3nf.ce_stores s2
on s.store_id=s2.store_id
inner join bl_3nf.ce_addresses a
on s2.address_id=a.address_id
inner join bl_3nf.ce_cities c
on a.city_id = c.city_id
inner join bl_3nf.ce_states s3
on s3.state_id=c.state_id
inner join BL_3NF.ce_countries c2
on c2.country_id=c2.country_id
group by c2.country;



SElECT c2.country, sum(s.sale_cost) as cost_by_channel, sum(s.sale_price) as sale_by_channel
FROM bl_3nf.ce_sales s
inner join bl_3nf.ce_stores s2
on s.store_id=s2.store_id
inner join bl_3nf.ce_addresses a
on s2.address_id=a.address_id
inner join bl_3nf.ce_cities c
on a.city_id = c.city_id
inner join bl_3nf.ce_states s3
on s3.state_id=c.state_id
inner join BL_3NF.ce_countries c2
on c2.country_id=c2.country_id
group by c2.country;