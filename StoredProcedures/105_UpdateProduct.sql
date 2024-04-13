CREATE OR REPLACE PROCEDURE update_product(
    p_productname IN PRODUCT.PRODUCTNAME%TYPE,
    p_category IN PRODUCT.CATEGORY%TYPE DEFAULT NULL,
    p_price IN PRODUCT.PRICE%TYPE DEFAULT NULL,
    p_description IN PRODUCT.DESCRIPTION%TYPE DEFAULT NULL,
    p_minstockquantity IN PRODUCT.MINSTOCKQUANTITY%TYPE DEFAULT NULL
) AS
    v_productid PRODUCT.PRODUCTID%TYPE;
BEGIN
    -- Check if ProductName is provided
    IF p_productname IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: ProductName must be provided and cannot be null');
        RETURN;
    END IF;

    -- Retrieve ProductID based on ProductName, ignoring case
    BEGIN
        SELECT ProductID INTO v_productid FROM Product
        WHERE UPPER(ProductName) = UPPER(p_productname);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No product found with the provided product name.');
            RETURN;
    END;

    -- Validate Category exists if provided
    IF p_category IS NOT NULL THEN
        DECLARE
            v_exists NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_exists FROM Category WHERE CategoryID = p_category;
            IF v_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Invalid Category ID');
                RETURN;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error checking category ID.');
                RETURN;
        END;
    END IF;

    -- Validate non-negative values for Price and MinStockQuantity
    IF p_price IS NOT NULL AND p_price < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Price must be a non-negative number');
        RETURN;
    END IF;
    IF p_minstockquantity IS NOT NULL AND p_minstockquantity < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Minimum Stock Quantity must be a non-negative number');
        RETURN;
    END IF;

    -- Check that description does not exceed maximum length
    IF p_description IS NOT NULL AND LENGTH(p_description) > 300 THEN
        DBMS_OUTPUT.PUT_LINE('Description exceeds maximum length of 300 characters');
        RETURN;
    END IF;

    -- Update the product details using NVL to fallback to existing values if null inputs are provided
    UPDATE Product
    SET Category = NVL(p_category, Category),
        Price = NVL(p_price, Price),
        Description = NVL(p_description, Description),
        MinStockQuantity = NVL(p_minstockquantity, MinStockQuantity)
    WHERE ProductID = v_productid;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        ROLLBACK;
END update_product;
/