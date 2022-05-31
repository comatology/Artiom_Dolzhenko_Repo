CREATE OR REPLACE PROCEDURE BL_CL.CREATE_PARTITIONS_FOR_CE_SALES (
    START_YEAR INT,
    END_YEAR   INT
) IS
    PARTITION_PREF      VARCHAR2(50);
    PARTITION_LAST_DATE VARCHAR2(50);
    SQL_STATEMENT       VARCHAR2(200);
BEGIN
    FOR CURRENT_YEAR IN START_YEAR..END_YEAR LOOP
        FOR CURRENT_MONTH IN 1..12 LOOP
            PARTITION_PREF := 'ce_sales_'
                              || CURRENT_YEAR
                              || '_'
                              || LPAD(CURRENT_MONTH, 2, '0');

            IF CURRENT_MONTH <> 12 THEN
                PARTITION_LAST_DATE := CURRENT_YEAR
                                       || '-'
                                       || LPAD(CURRENT_MONTH + 1, 2, '0')
                                       || '-'
                                       || '01';

            ELSE
                PARTITION_LAST_DATE := CURRENT_YEAR + 1
                                       || '-'
                                       || '01-01';
            END IF;

            SQL_STATEMENT := 'ALTER TABLE ce_sales
                ADD PARTITION '
                             || PARTITION_PREF
                             || ' VALUES LESS THAN (to_date('''
                             || PARTITION_LAST_DATE
                             || ''',''yyyy-mm-dd''))';
            EXECUTE IMMEDIATE SQL_STATEMENT;
        END LOOP;
    END LOOP;

    EXECUTE IMMEDIATE 'ALTER TABLE ce_sales ADD PARTITION  sales_before_9999 VALUES LESS THAN (to_date(''9999-01-01'',''yyyy-mm-dd''))';
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;

EXEC BL_CL.CREATE_PARTITIONS_FOR_CE_SALES(2020,2021)