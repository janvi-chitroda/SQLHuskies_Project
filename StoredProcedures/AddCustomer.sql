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