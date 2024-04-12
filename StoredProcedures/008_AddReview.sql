---------- Stored procedure to add Review (Review table)
CREATE OR REPLACE PROCEDURE ADD_REVIEW (
    PI_CUSTOMER_EMAIL Customer.Email%TYPE,
    PI_PRODUCT_NAME Product.ProductName%TYPE,
    PI_RATING Review.Rating%TYPE,
    PI_REVIEW_TEXT Review.ReviewText%TYPE
) AS
    V_CUSTOMER_ID Customer.CustomerID%TYPE;
    V_PRODUCT_ID Product.ProductID%TYPE;
    E_CUSTOMER_NOT_FOUND EXCEPTION;
    E_PRODUCT_NOT_FOUND EXCEPTION;
    E_INVALID_RATING EXCEPTION;
    E_EMPTY_REVIEW_TEXT EXCEPTION;
BEGIN
    -- Check if customer email is provided
    IF PI_CUSTOMER_EMAIL IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer email cannot be null.');
    END IF;

    -- Check if product name is provided
    IF PI_PRODUCT_NAME IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Product name cannot be null.');
    END IF;

    -- Get the CustomerID based on the provided email address, converting to lower case for case-insensitive comparison
    SELECT CustomerID INTO V_CUSTOMER_ID
    FROM Customer
    WHERE LOWER(Email) = LOWER(PI_CUSTOMER_EMAIL);

    -- Check if the customer exists
    IF V_CUSTOMER_ID IS NULL THEN
        RAISE E_CUSTOMER_NOT_FOUND;
    END IF;

    -- Get the ProductID based on the provided product name, converting to lower case for case-insensitive comparison
    SELECT ProductID INTO V_PRODUCT_ID
    FROM Product
    WHERE LOWER(ProductName) = LOWER(PI_PRODUCT_NAME);

    -- Check if the product exists
    IF V_PRODUCT_ID IS NULL THEN
        RAISE E_PRODUCT_NOT_FOUND;
    END IF;

    -- Check if the rating is valid (between 1 and 5)
    IF PI_RATING NOT BETWEEN 1 AND 5 THEN
        RAISE E_INVALID_RATING;
    END IF;

    -- Check if the review text is provided
    IF PI_REVIEW_TEXT IS NULL OR TRIM(PI_REVIEW_TEXT) = '' THEN
        RAISE E_EMPTY_REVIEW_TEXT;
    END IF;

    -- Insert the review into the Review table
    INSERT INTO Review (ReviewID, CustomerID, ProductID, Rating, ReviewText) VALUES (
        ReviewSeq.NEXTVAL,
        V_CUSTOMER_ID,
        V_PRODUCT_ID,
        PI_RATING,
        PI_REVIEW_TEXT
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Review added successfully');
EXCEPTION
    WHEN E_CUSTOMER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Customer not found.');
    WHEN E_PRODUCT_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Product not found.');
    WHEN E_INVALID_RATING THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid rating. Rating must be between 1 and 5.');
    WHEN E_EMPTY_REVIEW_TEXT THEN
        DBMS_OUTPUT.PUT_LINE('Error: Review text cannot be empty.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_REVIEW;
/
