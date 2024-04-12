---------- Stored procedure to add products to Warehouse(ProductSupplier table)
CREATE OR REPLACE PROCEDURE INSERT_DATA_TO_WAREHOUSE (
    PI_PRODUCT_NAME VARCHAR2, 
    PI_SUPPLIER_NAME VARCHAR2, 
    PI_PRODUCT_QTY NUMBER
) AS
    E_PRODUCT_NOT_FOUND EXCEPTION;
    E_SUPPLIER_NOT_FOUND EXCEPTION;
    E_INVALID_QUANTITY EXCEPTION;

    V_PRODUCT_ID Product.ProductID%TYPE;
    V_SUPPLIER_ID Supplier.SupplierID%TYPE;
BEGIN
    -- Lookup ProductID from ProductName
    BEGIN
        SELECT ProductID INTO V_PRODUCT_ID FROM Product WHERE UPPER(ProductName) = UPPER(PI_PRODUCT_NAME);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_PRODUCT_NOT_FOUND;
    END;

    -- Lookup SupplierID from SupplierName
    BEGIN
        SELECT SupplierID INTO V_SUPPLIER_ID FROM Supplier WHERE UPPER(SupplierName) = UPPER(PI_SUPPLIER_NAME);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_SUPPLIER_NOT_FOUND;
    END;

    -- Validate ProductQty
    IF PI_PRODUCT_QTY <= 0 THEN
        RAISE E_INVALID_QUANTITY;
    END IF;

    -- Insert data into Warehouse table using the resolved IDs
    INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (
        V_PRODUCT_ID,
        V_SUPPLIER_ID,
        PI_PRODUCT_QTY
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data inserted successfully into Warehouse.');
EXCEPTION
    WHEN E_PRODUCT_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The specified ProductName does not exist.');
    WHEN E_SUPPLIER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The specified SupplierName does not exist.');
    WHEN E_INVALID_QUANTITY THEN
        DBMS_OUTPUT.PUT_LINE('Error: Product quantity must be greater than 0.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END INSERT_DATA_TO_WAREHOUSE;
/