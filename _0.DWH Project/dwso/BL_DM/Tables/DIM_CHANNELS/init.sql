INSERT INTO DIM_CHANNELS (
    CHANNEL_SURR_ID,
    CHANNEL_SRCID,
    SOURCE_SYSTEM,
    SOURCE_ENTITY,
    CHANNEL_DESCRIPTION,
    CHANNEL_CLASS_ID,
    CHANNEL_CLASS,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    '3nf',
    'ce_channels',
    'N/A',
    - 1,
    'N/A',
    SYSDATE,
    SYSDATE
);

COMMIT;