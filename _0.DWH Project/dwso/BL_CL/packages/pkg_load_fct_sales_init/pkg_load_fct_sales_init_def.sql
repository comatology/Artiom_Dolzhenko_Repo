CREATE OR REPLACE PACKAGE pkg_load_fct_sales_init IS
L_PACKAGE_NAME CONSTANT VARCHAR2(100) := 'pkg_load_fct_tables';
    PROCEDURE prc_load_ce_sales_init(
        p_start_dt  DATE,
        p_end_dt    DATE);

    PROCEDURE prc_load_fct_sales_init(
        p_start_dt  DATE,
        p_end_dt    DATE);

END;
