---------- Stored procedure to add categories
CREATE OR REPLACE PROCEDURE ADD_CATEGORY (
    PI_NAME Category.Name%TYPE
) AS 
    E_NAME_EXISTS EXCEPTION; -- Exception for when the category name already exists
    
BEGIN
    -- Check for existing category name to ensure uniqueness
    FOR C IN (SELECT 1 FROM Category WHERE UPPER(Name) = UPPER(PI_NAME)) LOOP
        RAISE E_NAME_EXISTS;
    END LOOP;
    
    -- If the category name is unique, insert a new record
    INSERT INTO Category (CategoryID, Name) VALUES (
        CategorySeq.NEXTVAL, -- Auto-generate the CategoryID using the sequence
        INITCAP(PI_NAME)     -- Capitalize the first letter of each word in the category name
    );
    
    COMMIT; -- Commit the transaction to ensure changes are saved
    
    -- Success message
    DBMS_OUTPUT.PUT_LINE('Category added successfully: ' || INITCAP(PI_NAME));
    
EXCEPTION
    WHEN E_NAME_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The category name "' || PI_NAME || '" already exists.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back the transaction in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_CATEGORY;
/

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

---------- Stored procedure to add products
CREATE OR REPLACE PROCEDURE ADD_PRODUCT_T (
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
END ADD_PRODUCT_T;
/

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

---------- Stored procedure to add customer (Customer table)
CREATE OR REPLACE PROCEDURE ADD_CUSTOMER (
    PI_FIRST_NAME Customer.FirstName%TYPE,
    PI_LAST_NAME Customer.LastName%TYPE,
    PI_EMAIL Customer.Email%TYPE,
    PI_PASSWORD Customer.Password%TYPE,
    PI_CONTACT_NUMBER Customer.ContactNumber%TYPE
) AS
    E_PASSWORD_VALID EXCEPTION;
    E_EMAIL_EXISTS EXCEPTION;
    E_CONTACT_NUMBER_EXISTS EXCEPTION;
    E_NUMERIC_NAME EXCEPTION; -- Exception for numeric values in the name

    V_EMAIL_COUNT NUMBER;
    V_CONTACT_NUMBER_COUNT NUMBER;
BEGIN
    -- Check if the password meets the minimum length requirement
    IF LENGTH(PI_PASSWORD) < 8 THEN
        RAISE E_PASSWORD_VALID;
    END IF;

    -- Check if the first name contains numeric values
    IF REGEXP_LIKE(PI_FIRST_NAME, '\d') THEN
        RAISE E_NUMERIC_NAME;
    END IF;

    -- Check if the last name contains numeric values
    IF REGEXP_LIKE(PI_LAST_NAME, '\d') THEN
        RAISE E_NUMERIC_NAME;
    END IF;

    -- Check if the email already exists
    SELECT COUNT(*) INTO V_EMAIL_COUNT FROM Customer WHERE Email = LOWER(PI_EMAIL);
    IF V_EMAIL_COUNT > 0 THEN
        RAISE E_EMAIL_EXISTS;
    END IF;

    -- Check if the contact number already exists
    SELECT COUNT(*) INTO V_CONTACT_NUMBER_COUNT FROM Customer WHERE ContactNumber = PI_CONTACT_NUMBER;
    IF V_CONTACT_NUMBER_COUNT > 0 THEN
        RAISE E_CONTACT_NUMBER_EXISTS;
    END IF;

    -- Insert the customer record
    INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (
        CustomerSeq.NEXTVAL,
        INITCAP(PI_FIRST_NAME),
        INITCAP(PI_LAST_NAME),
        LOWER(PI_EMAIL),
        PI_PASSWORD,
        PI_CONTACT_NUMBER
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer added successfully');
EXCEPTION
    WHEN E_PASSWORD_VALID THEN
        DBMS_OUTPUT.PUT_LINE('Password should have at least 8 characters');
    WHEN E_EMAIL_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Email already exists. Please sign in directly.');
    WHEN E_CONTACT_NUMBER_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Contact number already exists. Please sign in directly.');
    WHEN E_NUMERIC_NAME THEN
        DBMS_OUTPUT.PUT_LINE('First name and last name cannot contain numeric values.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_CUSTOMER;
/

---------- Stored procedure to add Address (Address table)
CREATE OR REPLACE PROCEDURE ADD_ADDRESS (
    PI_ADDRESS_TYPE Address.AddressType%TYPE,
    PI_CUSTOMER_EMAIL Customer.Email%TYPE,
    PI_STREET_NAME Address.StreetName%TYPE,
    PI_UNIT_NUMBER Address.UnitNumber%TYPE,
    PI_CITY Address.City%TYPE,
    PI_STATE Address.State%TYPE,
    PI_COUNTRY Address.Country%TYPE,
    PI_ZIP_CODE Address.ZipCode%TYPE
) AS
    E_INVALID_ADDRESS_TYPE EXCEPTION;
    E_INVALID_CUSTOMER_ID EXCEPTION;
    E_INVALID_ZIP_CODE EXCEPTION;
    E_DUPLICATE_ADDRESS_TYPE EXCEPTION;
    V_CUSTOMER_ID Customer.CustomerID%TYPE;
    V_EXISTING_ADDRESS_COUNT NUMBER;

BEGIN
    -- Check if the address type is valid
    IF NOT (PI_ADDRESS_TYPE IN ('Home', 'Work', 'Alternate')) THEN
        RAISE E_INVALID_ADDRESS_TYPE;
    END IF;

    -- Get the customer ID based on the provided email
    SELECT CustomerID INTO V_CUSTOMER_ID FROM Customer WHERE Email = PI_CUSTOMER_EMAIL;
    IF V_CUSTOMER_ID IS NULL THEN
        RAISE E_INVALID_CUSTOMER_ID;
    END IF;

    -- Check if the zip code is valid (length 5 or 9 digits)
    IF LENGTH(PI_ZIP_CODE) NOT IN (5, 9) THEN
        RAISE E_INVALID_ZIP_CODE;
    END IF;

    -- Check if the customer has already added the same address type
    SELECT COUNT(*) INTO V_EXISTING_ADDRESS_COUNT FROM Address WHERE CustomerID = V_CUSTOMER_ID AND AddressType = INITCAP(PI_ADDRESS_TYPE);
    IF V_EXISTING_ADDRESS_COUNT > 0 THEN
        RAISE E_DUPLICATE_ADDRESS_TYPE;
    END IF;

    -- Insert the address record
    INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (
        AddressSeq.NEXTVAL,
        INITCAP(PI_ADDRESS_TYPE),
        V_CUSTOMER_ID, -- Use the retrieved customer ID
        INITCAP(PI_STREET_NAME),
        INITCAP(PI_UNIT_NUMBER),
        INITCAP(PI_CITY),
        INITCAP(PI_STATE),
        INITCAP(PI_COUNTRY),
        PI_ZIP_CODE
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Address added successfully');
EXCEPTION
    WHEN E_INVALID_ADDRESS_TYPE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid address type. Valid types are "Home", "Work", or "Alternate".');
    WHEN E_INVALID_CUSTOMER_ID THEN
        DBMS_OUTPUT.PUT_LINE('Error: Customer email does not exist.');
    WHEN E_INVALID_ZIP_CODE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid zip code. Zip code must be 5 or 9 digits.');
    WHEN E_DUPLICATE_ADDRESS_TYPE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Customer has already added an address of type ' || INITCAP(PI_ADDRESS_TYPE));
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_ADDRESS;
/

---------- Stored procedure to add Order (CustomerOrder table)
---------- Stored procedure to add ProductOrder (ProductOrder table)


---------- Stored procedure to add Review (Review table)
CREATE OR REPLACE PROCEDURE ADD_REVIEW (
    PI_CUSTOMER_EMAIL Customer.Email%TYPE,
    PI_PRODUCT_NAME Product.Name%TYPE,
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

    -- Get the CustomerID based on the provided email address
    SELECT CustomerID INTO V_CUSTOMER_ID FROM Customer WHERE Email = PI_CUSTOMER_EMAIL;

    -- Check if the customer exists
    IF V_CUSTOMER_ID IS NULL THEN
        RAISE E_CUSTOMER_NOT_FOUND;
    END IF;

    -- Get the ProductID based on the provided product name
    SELECT ProductID INTO V_PRODUCT_ID FROM Product WHERE Name = PI_PRODUCT_NAME;

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
