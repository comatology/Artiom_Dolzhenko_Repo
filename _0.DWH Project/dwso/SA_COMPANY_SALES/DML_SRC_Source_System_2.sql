DELETE FROM SA_SOURCE_SYSTEM_2.src_CHANNELS;
INSERT INTO SA_SOURCE_SYSTEM_2.src_CHANNELS (
    channel_id  ,
    channel_desc ,
    channel_class  ,
    channel_class_id,
	TA_UPDATE_DT
)
(SELECT channel_id  ,
    channel_desc ,
    channel_class  ,
    channel_class_id  ,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.CHANNELS);
select * from SA_SOURCE_SYSTEM_2.src_CHANNELS;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_COUNTIRES;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_COUNTIRES (
       country_id ,
       country_iso_code,
       country_name,
       country_subregion,
       country_subregion_id ,
       country_region,
       country_region_id ,
       country_total ,
       country_total_id ,
       country_name_hist,
	TA_UPDATE_DT
)
(SELECT 
       country_id ,
       country_iso_code,
       country_name,
       country_subregion,
       country_subregion_id ,
       country_region,
       country_region_id ,
       country_total ,
       country_total_id ,
       country_name_hist,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.COUNTIRES);

select * from SA_SOURCE_SYSTEM_2.SRC_COUNTIRES;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_CUSTOMERS;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_CUSTOMERS (
          customer_id ,
          customer_company_name ,
          customer_company_number ,
          customer_address ,
          customer_country_id ,
          customer_iso_code ,
          customer_country_name ,
          customer_phone ,
          customer_email,
          TA_UPDATE_DT
)
(SELECT 
          customer_id ,
          customer_company_name ,
          customer_company_number ,
          customer_address ,
          customer_country_id ,
          customer_iso_code ,
          customer_country_name ,
          customer_phone ,
          customer_email .SYSDATE
FROM SA_SOURCE_SYSTEM_2.CUSTOMERS);

select * from SA_SOURCE_SYSTEM_2.SRC_CUSTOMERS;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_EMPLOYEES;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_EMPLOYEES (
  employee_id ,
  employee_name ,
  employee_last_name ,
  employee_birthday ,
  employee_position_id ,
  employee_position ,
  employee_phone  ,
  employee_email ,
  employee_address ,
  employee_country,
	TA_UPDATE_DT 
)
(SELECT 
  employee_id ,
  employee_name ,
  employee_last_name ,
  employee_birthday ,
  employee_position_id ,
  employee_position ,
  employee_phone  ,
  employee_email ,
  employee_address ,
  employee_cointry ,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.EMPLOYEES);

select * from SA_SOURCE_SYSTEM_2.SRC_EMPLOYEES;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_PRODUCTS;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_PRODUCTS (
 product_id  ,
 product_name ,
 brand_id ,
 brand ,
 product_type_id ,
 product_type ,
 unit_cost ,
 unit_price ,
	TA_UPDATE_DT
)
(SELECT 
 product_id  ,
 product_name,
 brand_id ,
 brand ,
 product_type_id ,
 product_type ,
 unit_cost ,
 unit_price ,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.PRODUCTS);

select * from SA_SOURCE_SYSTEM_2.SRC_PRODUCTS;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_PROMOTIONS;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_PROMOTIONS (
 promo_id ,
 promo_name ,
 promo_category ,
 promo_category_id ,
 promo_cost ,
 promo_begin_date ,
 promo_end_date,
	TA_UPDATE_DT 
)
(SELECT 
 promo_id ,
 promo_name ,
 promo_category ,
 promo_category_id ,
 promo_cost ,
 promo_begin_date ,
 promo_end_date ,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.PROMOTIONS);
select * from SA_SOURCE_SYSTEM_2.SRC_PROMOTIONS;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_STORES;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_STORES (
 store_id  ,
 store_postal_code ,
 store_city ,
 store_city_id ,
 store_state ,
 store_state_id ,
 store_country ,
 store_country_id ,
 store_phone ,
 store_street_address_id, 
 store_street_address,
	TA_UPDATE_DT  
)
(SELECT 
 store_id  ,
 store_postal_code ,
 store_city ,
 store_city_id ,
 store_state ,
 store_state_id ,
 store_country ,
 store_country_id ,
 store_phone ,
 store_street_address_id,
 store_street_address ,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.STORES);

select * from SA_SOURCE_SYSTEM_2.SRC_STORES;
commit;

DELETE FROM SA_SOURCE_SYSTEM_2.SRC_SALES;
INSERT INTO SA_SOURCE_SYSTEM_2.SRC_SALES (
 product_id ,
 customer_id ,
 channel_id ,
 promo_id ,
 employee_id ,
 store_id ,
 quantity_sold ,
 time_id,
TA_UPDATE_DT  
)
(SELECT 
 product_id ,
 customer_id ,
 channel_id ,
 promo_id ,
 employee_id ,
 store_id ,
 quantity_sold ,
 time_id ,
    SYSDATE
FROM SA_SOURCE_SYSTEM_2.SALES);

select count( *) from SA_SOURCE_SYSTEM_2.SRC_SALES;
commit;