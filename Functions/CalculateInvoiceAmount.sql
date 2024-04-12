CREATE OR REPLACE FUNCTION CalculateInvoiceAmount(
    p_productid PRODUCT.PRODUCTID%TYPE,
    p_qty NUMBER
) RETURN NUMBER IS
    v_price PRODUCT.PRICE%TYPE;
BEGIN
    -- Get the product price
    SELECT PRICE INTO v_price FROM PRODUCT WHERE PRODUCTID = p_productid;

    -- Calculate the invoice amount
    RETURN v_price * p_qty;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Product not found');
    WHEN OTHERS THEN
        RAISE;
END CalculateInvoiceAmount;
