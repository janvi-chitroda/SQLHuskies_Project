---------- Stored procedure to add suppliers
CREATE OR REPLACE PROCEDURE ADD_SUPPLIER (
    PI_SUPPLIER_NAME Supplier.SupplierName%TYPE,
    PI_SUPPLIER_LOCATION Supplier.SupplierLocation%TYPE
) AS 
    E_SUPPLIER_NAME_EXISTS EXCEPTION;
    E_INVALID_NAME EXCEPTION;
    E_INVALID_LOCATION EXCEPTION;
    E_NAME_TOO_LONG EXCEPTION;
    E_LOCATION_TOO_LONG EXCEPTION;

    -- Constants for maximum lengths based on your table definition
    CONST_MAX_NAME_LENGTH CONSTANT INTEGER := 20;
    CONST_MAX_LOCATION_LENGTH CONSTANT INTEGER := 20;
BEGIN
    -- Check for NULL inputs
    IF PI_SUPPLIER_NAME IS NULL THEN
        RAISE E_INVALID_NAME;
    END IF;

    IF PI_SUPPLIER_LOCATION IS NULL THEN
        RAISE E_INVALID_LOCATION;
    END IF;

    -- Check for input length
    IF LENGTH(PI_SUPPLIER_NAME) > CONST_MAX_NAME_LENGTH THEN
        RAISE E_NAME_TOO_LONG;
    END IF;

    IF LENGTH(PI_SUPPLIER_LOCATION) > CONST_MAX_LOCATION_LENGTH THEN
        RAISE E_LOCATION_TOO_LONG;
    END IF;

    -- Check for existing supplier name to ensure uniqueness
    FOR C IN (SELECT 1 FROM Supplier WHERE UPPER(SupplierName) = UPPER(PI_SUPPLIER_NAME)) LOOP
        RAISE E_SUPPLIER_NAME_EXISTS;
    END LOOP;
    
    -- Insert the new supplier with an ID generated from the sequence
    INSERT INTO Supplier (SupplierID, SupplierName, SupplierLocation) VALUES (
        SupplierSeq.NEXTVAL, 
        INITCAP(PI_SUPPLIER_NAME), 
        INITCAP(PI_SUPPLIER_LOCATION)
    );
    
    COMMIT; -- Commit the transaction to make sure the changes are saved
    
    -- Success message
    DBMS_OUTPUT.PUT_LINE('Supplier added successfully: ' || INITCAP(PI_SUPPLIER_NAME));
    
EXCEPTION
    WHEN E_SUPPLIER_NAME_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The supplier name "' || PI_SUPPLIER_NAME || '" already exists.');
    WHEN E_INVALID_NAME THEN
        DBMS_OUTPUT.PUT_LINE('Error: Supplier name cannot be null.');
    WHEN E_INVALID_LOCATION THEN
        DBMS_OUTPUT.PUT_LINE('Error: Supplier location cannot be null.');
    WHEN E_NAME_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Supplier name exceeds the maximum length of ' || CONST_MAX_NAME_LENGTH || ' characters.');
    WHEN E_LOCATION_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Supplier location exceeds the maximum length of ' || CONST_MAX_LOCATION_LENGTH || ' characters.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back the transaction in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_SUPPLIER;
/