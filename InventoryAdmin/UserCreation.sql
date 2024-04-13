SET SERVEROUTPUT ON;

--  This user is responsible for managing product inventory and supplier relationships. They should have access to the V_Product and V_ProductSales views.
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='INVENTORYMANAGER';
    DBMS_OUTPUT.PUT_LINE('USER: InventoryManager already exists');
    EXECUTE IMMEDIATE 'GRANT CONNECT TO InventoryManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Product TO InventoryManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductSales TO InventoryManager';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE USER InventoryManager IDENTIFIED BY IMuser#123456789';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO InventoryManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Product TO InventoryManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductSales TO InventoryManager';
            DBMS_OUTPUT.PUT_LINE('InventoryManager created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        END;
END;
/

-- This user is responsible for analyzing sales data. They should have access to the V_Order, V_ProductSales, and V_CustomerOrderFrequency views.
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='c';
    DBMS_OUTPUT.PUT_LINE('USER: SalesAnalyst already exists');
    EXECUTE IMMEDIATE 'GRANT CONNECT TO SalesAnalyst';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO SalesAnalyst';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductSales TO SalesAnalyst';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerOrderFrequency TO SalesAnalyst';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE USER SalesAnalyst IDENTIFIED BY SAuser#123456789';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO SalesAnalyst';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO SalesAnalyst';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductSales TO SalesAnalyst';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerOrderFrequency TO SalesAnalyst';
            DBMS_OUTPUT.PUT_LINE('SalesAnalyst created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        END;
END;
/

-- This user is responsible for managing customer relationships and handling customer feedback. They should have access to the V_CustomerReview and V_Order views.
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='CUSTOMERSERVICEMANAGER';
    DBMS_OUTPUT.PUT_LINE('USER: CustomerServiceManager already exists');
    EXECUTE IMMEDIATE 'GRANT CONNECT TO CustomerServiceManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerReview TO CustomerServiceManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO CustomerServiceManager';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE USER CustomerServiceManager IDENTIFIED BY CSMuser#123456789';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO CustomerServiceManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerReview TO CustomerServiceManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO CustomerServiceManager';
            DBMS_OUTPUT.PUT_LINE('CustomerServiceManager created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        END;
END;
/

-- This user is responsible for managing deliveries and order details. They should have access to the V_CustomerAddress, V_ProductOrderDetail, and V_Order views.
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='LOGISTICSMANAGER';
    DBMS_OUTPUT.PUT_LINE('USER: LogisticsManager already exists');
    EXECUTE IMMEDIATE 'GRANT CONNECT TO LogisticsManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerAddress TO LogisticsManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductOrderDetail TO LogisticsManager';
    EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO LogisticsManager';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE USER LogisticsManager IDENTIFIED BY LMuser#123456789';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO LogisticsManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_CustomerAddress TO LogisticsManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_ProductOrderDetail TO LogisticsManager';
            EXECUTE IMMEDIATE 'GRANT SELECT ON INVENTORYADMIN.V_Order TO LogisticsManager';
            DBMS_OUTPUT.PUT_LINE('LogisticsManager created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        END;
END;
