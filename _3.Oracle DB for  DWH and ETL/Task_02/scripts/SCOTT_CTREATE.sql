alter user SCOTT account unlock;
Create user SCOTT identified by tiger;
GRANT CONNECT, RESOURCE TO SCOTT;
ALTER USER SCOTT QUOTA UNLIMITED ON USERS;