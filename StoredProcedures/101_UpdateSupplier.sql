--Procedure to Update Supplier Information
CREATE OR REPLACE PROCEDURE UPDATE_SUPPLIER(
    si_supplier_id IN Supplier.SupplierID%TYPE,
    si_supplier_name IN Supplier.SupplierName%TYPE DEFAULT NULL,
    si_supplier_location IN Supplier.SupplierLocation%TYPE DEFAULT NULL
)
AS
BEGIN
    UPDATE Supplier
    SET
        SupplierName = NVL(si_supplier_name, SupplierName),
        SupplierLocation = NVL(si_supplier_location, SupplierLocation)
    WHERE SupplierID = si_supplier_id;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Supplier with ID ' || si_supplier_id || ' not found.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END UPDATE_SUPPLIER;
/
