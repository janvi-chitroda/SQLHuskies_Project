CREATE OR REPLACE PROCEDURE add_customer_order(
    p_email VARCHAR2,
    p_productname VARCHAR2,
    p_qty NUMBER,
    p_orderdate DATE,
    p_invoiceamount NUMBER
) AS
    v_customerid CUSTOMER.CUSTOMERID%TYPE;
    v_productid PRODUCT.PRODUCTID%TYPE;
    v_warehouseqty WAREHOUSE.PRODUCTQTY%TYPE;
    v_orderid CUSTOMERORDER.ORDERID%TYPE;
BEGIN
    -- Get the customer ID
    SELECT CUSTOMERID INTO v_customerid FROM CUSTOMER WHERE EMAIL = p_email;

    -- Get the product ID
    SELECT PRODUCTID INTO v_productid FROM PRODUCT WHERE PRODUCTNAME = p_productname;

    -- Check the quantity in the warehouse
    SELECT PRODUCTQTY INTO v_warehouseqty FROM WAREHOUSE WHERE PRODUCTID = v_productid;

    IF v_warehouseqty < p_qty THEN
        RAISE_APPLICATION_ERROR(-20001, 'Not enough stock in the warehouse');
    END IF;

    -- Get the next ORDERID from the sequence
    SELECT CustomerOrderSeq.NEXTVAL INTO v_orderid FROM DUAL;

    -- Add the order
    INSERT INTO CUSTOMERORDER (ORDERID, CUSTOMERID, ORDERDATE, INVOICEAMOUNT)
    VALUES (v_orderid, v_customerid, p_orderdate, p_invoiceamount);

    -- Deduct the quantity from the warehouse
    UPDATE WAREHOUSE SET PRODUCTQTY = PRODUCTQTY - p_qty WHERE PRODUCTID = v_productid;

    -- Add an entry to the ProductOrder table
    INSERT INTO PRODUCTORDER (PRODUCTID, ORDERID, PRODUCTQTY) VALUES (v_productid, v_orderid, p_qty);

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Data not found');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END add_customer_order;
