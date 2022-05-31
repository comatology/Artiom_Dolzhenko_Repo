INSERT INTO CE_CHANNELS (
    CHANNEL_ID,
    CHANNEL_SRCID,
    CHANNEL_SOURCE_SYSTEM,
    CHANNEL_SOURCE_ENTITY,
    CHANNEL_DESCRIPTION,
    CHANNEL_CLASS_ID,
    TA_UPDATE_DT,
    TA_INSERT_DT
) VALUES (
    - 1,
    - 1,
    'personnel_sales',
    'src_channels',
    'N/A',
    - 1,
    SYSDATE,
    SYSDATE
);
COMMIT;