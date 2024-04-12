---------- Stored procedure to add products
CREATE OR REPLACE PROCEDURE ADD_PRODUCT (
    PI_PRODUCT_NAME Product.ProductName%TYPE,
    PI_CATEGORY_TITLE VARCHAR, -- Parameter for category title
    PI_PRICE Product.Price%TYPE,
    PI_DESCRIPTION Product.Description%TYPE,
    PI_MIN_STOCK_QUANTITY Product.MinStockQuantity%TYPE
) AS
    E_CATEGORY_NOT_FOUND EXCEPTION;
    E_INVALID_PRICE EXCEPTION;
    E_INVALID_MIN_STOCK_QUANTITY EXCEPTION;
    E_NAME_TOO_LONG EXCEPTION;
    E_DESCRIPTION_TOO_LONG EXCEPTION;
    E_PRODUCT_NAME_EXISTS EXCEPTION; -- New exception for unique product name

    V_CATEGORY_ID Product.Category%TYPE;
    V_PRODUCT_COUNT NUMBER;
    CONST_PRODUCT_NAME_MAX_LENGTH CONSTANT NUMBER := 20;
    CONST_DESCRIPTION_MAX_LENGTH CONSTANT NUMBER := 300;
BEGIN
    -- Validate product name length
    IF LENGTH(PI_PRODUCT_NAME) > CONST_PRODUCT_NAME_MAX_LENGTH THEN
        RAISE E_NAME_TOO_LONG;
    END IF;

    -- Validate description length
    IF LENGTH(PI_DESCRIPTION) > CONST_DESCRIPTION_MAX_LENGTH THEN
        RAISE E_DESCRIPTION_TOO_LONG;
    END IF;

    -- Check for existing product name to ensure uniqueness
    SELECT COUNT(*)
    INTO V_PRODUCT_COUNT
    FROM Product
    WHERE UPPER(ProductName) = UPPER(PI_PRODUCT_NAME);

    IF V_PRODUCT_COUNT > 0 THEN
        RAISE E_PRODUCT_NAME_EXISTS; -- Raise the new exception if product name already exists
    END IF;

    BEGIN
        -- Lookup CategoryID from CategoryTitle
        SELECT CategoryID INTO V_CATEGORY_ID FROM Category WHERE UPPER(Name) = UPPER(PI_CATEGORY_TITLE);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_CATEGORY_NOT_FOUND;
    END;

    -- Validate price
    IF PI_PRICE <= 0 THEN
        RAISE E_INVALID_PRICE;
    END IF;

    -- Validate minimum stock quantity
    IF PI_MIN_STOCK_QUANTITY < 0 THEN
        RAISE E_INVALID_MIN_STOCK_QUANTITY;
    END IF;

    -- Insert the new product with resolved CategoryID
    INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (
        ProductSeq.NEXTVAL,
        INITCAP(PI_PRODUCT_NAME),
        V_CATEGORY_ID,
        PI_PRICE,
        PI_DESCRIPTION,
        PI_MIN_STOCK_QUANTITY
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('PRODUCT ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_PRODUCT_NAME_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: A product with the name "' || PI_PRODUCT_NAME || '" already exists.');
    WHEN E_CATEGORY_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: The specified category title does not exist.');
    WHEN E_NAME_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Product name exceeds the maximum length of ' || CONST_PRODUCT_NAME_MAX_LENGTH || ' characters.');
    WHEN E_DESCRIPTION_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Description exceeds the maximum length of ' || CONST_DESCRIPTION_MAX_LENGTH || ' characters.');
    WHEN E_INVALID_PRICE THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Price must be greater than 0.');
    WHEN E_INVALID_MIN_STOCK_QUANTITY THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Minimum stock quantity cannot be negative.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_PRODUCT;
/