exec pkg_load_3nf_tables. PRC_LOAD_CE_PROMOTIONS_SCD ;

exec pkg_load_3nf_tables.TEST(-1);


select * from bl_cl.log_table; 
delete from log_table;

Delete  from BL_3NF.ce_promotions_scd where promotion_id!= -1;
Select * from BL_3NF.ce_promotions_scd;
Select * from BL_3NF.ce_promotion_categories;


 