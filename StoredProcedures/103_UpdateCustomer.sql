CREATE OR REPLACE PROCEDURE update_customer(
    p_email IN CUSTOMER.EMAIL%TYPE,
    p_firstname IN CUSTOMER.FIRSTNAME%TYPE,
    p_lastname IN CUSTOMER.LASTNAME%TYPE,
    p_password IN CUSTOMER.PASSWORD%TYPE,
    p_contactnumber IN CUSTOMER.CONTACTNUMBER%TYPE
) AS
    v_customerid CUSTOMER.CUSTOMERID%TYPE;
BEGIN
    SELECT CUSTOMERID INTO v_customerid FROM CUSTOMER WHERE EMAIL = p_email;

    UPDATE CUSTOMER
    SET FIRSTNAME = NVL(p_firstname, FIRSTNAME),
        LASTNAME = NVL(p_lastname, LASTNAME),
        PASSWORD = NVL(p_password, PASSWORD),
        CONTACTNUMBER = NVL(p_contactnumber, CONTACTNUMBER)
    WHERE CUSTOMERID = v_customerid;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No customer found with the provided email.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END update_customer;
/
