--Procedure to Add Product Quantity
CREATE OR REPLACE PROCEDURE UPDATE_WAREHOUSE_QUANTITY(
    si_supplier_name IN Supplier.SupplierName%TYPE,
    si_product_name IN Product.ProductName%TYPE,
    si_quantity IN VARCHAR2
)
AS
    v_supplier_id Supplier.SupplierID%TYPE;
    v_product_id Product.ProductID%TYPE;
    v_qty NUMBER;
BEGIN
    -- Check if the entered quantity is a valid integer
    BEGIN
        v_qty := TO_NUMBER(si_quantity);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Invalid quantity. Please enter a valid integer.');
            RETURN;
    END;

    -- Get the supplier ID based on the supplier name
    BEGIN
        SELECT SupplierID INTO v_supplier_id FROM Supplier WHERE SupplierName = si_supplier_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Supplier not found.');
            RETURN;
    END;

    -- Get the product ID based on the product name
    BEGIN
        SELECT ProductID INTO v_product_id FROM Product WHERE ProductName = si_product_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Product not found.');
            RETURN;
    END;

    -- Update the quantity in the warehouse
    UPDATE Warehouse
    SET ProductQty = ProductQty + v_qty
    WHERE ProductID = v_product_id AND SupplierID = v_supplier_id;

    -- If no rows were updated, insert a new record into the warehouse
    IF SQL%NOTFOUND THEN
        INSERT INTO Warehouse (ProductID, SupplierID, ProductQty)
        VALUES (v_product_id, v_supplier_id, v_qty);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END UPDATE_WAREHOUSE_QUANTITY;
/
