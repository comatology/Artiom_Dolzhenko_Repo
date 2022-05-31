CREATE OR REPLACE PACKAGE PKG_LOAD_3NF_TABLES IS
    L_PACKAGE_NAME CONSTANT VARCHAR2(100) := 'pkg_load_3nf_tables';
    PROCEDURE PRC_LOAD_CE_CHANNEL_CLASSES;
    PROCEDURE PRC_LOAD_CE_CHANNELS; 
    PROCEDURE PRC_LOAD_CE_PROMOTION_CATEGORIES;
    PROCEDURE PRC_LOAD_CE_PROMOTIONS_SCD;
    PROCEDURE PRC_LOAD_CE_BRANDS;
    PROCEDURE PRC_LOAD_CE_PRODUCT_TYPES;
    PROCEDURE PRC_LOAD_CE_PRODUCTS;
    PROCEDURE PRC_LOAD_CE_COUNTRIES;
    PROCEDURE PRC_LOAD_CE_STATES;
    PROCEDURE PRC_LOAD_CE_CITIES;
    PROCEDURE PRC_LOAD_CE_ADDRESSES;
    PROCEDURE PRC_LOAD_CE_STORES;
    PROCEDURE PRC_LOAD_CE_CUSTOMERS;
    PROCEDURE PRC_LOAD_CE_POSITIONS;
    PROCEDURE PRC_LOAD_CE_EMPLOYEES;

END;