SET SERVEROUTPUT ON;

DECLARE
    v_sid NUMBER;
    v_serial NUMBER;
    v_sql VARCHAR2(100);
BEGIN
    -- Obtaining SID and SERIAL# values --
    SELECT SID, SERIAL# INTO v_sid, v_serial
    FROM V$SESSION
    WHERE USERNAME = 'INVENTORYADMIN' AND ROWNUM = 1;
    
    -- Kill the session for INVENTORYADMIN if session is already present --
    v_sql := 'ALTER SYSTEM KILL SESSION ' || '''' || v_sid  || ',' || v_serial || '''';
  
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('SESSION ALTERED IF EXISTED');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No active session found for INVENTORYADMIN.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN
    FOR I IN (
    WITH DESIRED_USER AS (SELECT 'INVENTORYADMIN' USERNAME FROM DUAL)
    SELECT DU.USERNAME FROM DESIRED_USER DU JOIN ALL_USERS AU ON DU.USERNAME = AU.USERNAME
    )
LOOP
    DBMS_OUTPUT.PUT_LINE('USER INVENTORYADMIN EXIST -> DROPPING USER AND CREATING IT BACK.');
    EXECUTE IMMEDIATE 'DROP USER ' || I.USERNAME || ' CASCADE';
END LOOP;
EXCEPTION 
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SOMETHING WENT WRONG ' || SQLERRM);
END;
/
 
CREATE USER INVENTORYADMIN IDENTIFIED BY "Admin123456789";
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE USER, DROP USER, CREATE ROLE, DROP ANY ROLE TO INVENTORYADMIN WITH ADMIN OPTION;
GRANT SELECT ON V$SESSION TO INVENTORYADMIN;
GRANT ALTER USER TO INVENTORYADMIN;
GRANT DROP ANY TABLE TO INVENTORYADMIN;
GRANT DROP ANY SEQUENCE TO INVENTORYADMIN;
GRANT ALTER SYSTEM TO INVENTORYADMIN;
GRANT execute ON DBMS_LOCK TO INVENTORYADMIN;
ALTER USER INVENTORYADMIN QUOTA UNLIMITED ON DATA;
/