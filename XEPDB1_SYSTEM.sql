DROP USER grupo8 CASCADE;

CREATE USER grupo8 IDENTIFIED BY grupo8
ACCOUNT UNLOCK;

GRANT CONNECT, RESOURCE TO grupo8;
GRANT UNLIMITED TABLESPACE TO grupo8;

GRANT CREATE PUBLIC SYNONYM TO grupo8;
GRANT CREATE SYNONYM TO grupo8;
GRANT CREATE VIEW TO grupo8;