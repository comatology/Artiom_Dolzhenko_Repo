exec pkg_load_3nf_tables.prc_load_CE_PRODUCTS;


select * from log_table order by timestamp, STEP_NUMBER 
delete from log_table
S from CE_CHANNEL_CLASSES where channel_class_id !=-1