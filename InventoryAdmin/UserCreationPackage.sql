CREATE OR REPLACE PACKAGE UserManagementPackage AS
  PROCEDURE CreateUser(p_username IN VARCHAR2, p_password IN VARCHAR2);
END UserManagementPackage;
/

CREATE OR REPLACE PACKAGE BODY UserManagementPackage AS
  PROCEDURE CreateUser(p_username IN VARCHAR2, p_password IN VARCHAR2) IS
    V_USER VARCHAR2(100);
  BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME = p_username;
    
    DBMS_OUTPUT.PUT_LINE('USER: ' || p_username || ' already exists');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      EXECUTE IMMEDIATE 'CREATE USER ' || p_username || ' IDENTIFIED BY ' || p_password;
      EXECUTE IMMEDIATE 'GRANT CONNECT TO ' || p_username;

      -- Additional grants based on user roles
      CASE p_username
        WHEN 'INVENTORYMANAGER' THEN
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Product TO InventoryManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductSales TO InventoryManager';
            DBMS_OUTPUT.PUT_LINE('InventoryManager created successfully');
        WHEN 'SALESANALYST' THEN
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO SalesAnalyst';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductSales TO SalesAnalyst';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerOrderFrequency TO SalesAnalyst';
            DBMS_OUTPUT.PUT_LINE('SalesAnalyst created successfully');
        WHEN 'CUSTOMERSERVICEMANAGER' THEN
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerReview TO CustomerServiceManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO CustomerServiceManager';
            DBMS_OUTPUT.PUT_LINE('CustomerServiceManager created successfully');
        WHEN 'LOGISTICSMANAGER' THEN
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerAddress TO LogisticsManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductOrderDetail TO LogisticsManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO LogisticsManager';
            DBMS_OUTPUT.PUT_LINE('LogisticsManager created successfully');
         
      END CASE;

      DBMS_OUTPUT.PUT_LINE(p_username || ' created successfully');
  END CreateUser;
END UserManagementPackage;
/


BEGIN
  UserManagementPackage.CreateUser('INVENTORYMANAGER', 'IMuser#123456789');
  UserManagementPackage.CreateUser('SALESANALYST', 'SAuser#123456789');
  UserManagementPackage.CreateUser('CUSTOMERSERVICEMANAGER', 'CSMuser#123456789');
  UserManagementPackage.CreateUser('LOGISTICSMANAGER', 'LMuser#123456789');
END;
/
