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