CREATE OR REPLACE PACKAGE pkg_load_fct_sales IS
L_PACKAGE_NAME CONSTANT VARCHAR2(100) := 'pkg_load_fct_tables';
    PROCEDURE prc_load_ce_sales(
        p_start_dt  DATE,
        p_end_dt    DATE);

    PROCEDURE prc_load_fct_sales(
        p_start_dt  DATE,
        p_end_dt    DATE);

END;
