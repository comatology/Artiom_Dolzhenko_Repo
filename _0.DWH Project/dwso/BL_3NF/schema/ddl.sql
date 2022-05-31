CREATE USER BL_3NF IDENTIFIED BY BL_3NF
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    PROFILE DEFAULT;

GRANT CONNECT, RESOURCE TO BL_3NF;

GRANT
    UNLIMITED TABLESPACE
TO BL_3NF;