INSERT INTO DIM_PROMOTIONS_SCD (
    PROMOTION_SURR_ID     ,
    PROMOTION_SRCID       ,
    SOURCE_SYSTEM         ,
    SOURCE_ENTITY         ,
    PROMOTION_NAME        ,
    PROMOTION_CATEGORY_ID ,
    PROMOTION_CATEGOTY    ,
    START_DT              ,
    END_DT                ,
    IS_ACTIVE             ,
    COST                  ,
    TA_UPDATE_DT          ,
    TA_INSERT_DT          
) VALUES (
    - 1,
    - 1,
    '3nf',
    'ce_promotions_scd',
    'N/A',
    - 1,
    'N/A',
	TO_DATE('9999-12-31', 'yyyy-mm-dd'),
    TO_DATE('9999-12-31', 'yyyy-mm-dd'),
	'inactive',
    - 1,
    SYSDATE,
    SYSDATE
);

COMMIT;