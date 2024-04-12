CREATE OR REPLACE PROCEDURE update_address(
    p_email IN CUSTOMER.EMAIL%TYPE,
    p_addresstype IN ADDRESS.ADDRESSTYPE%TYPE,
    p_streetname IN ADDRESS.STREETNAME%TYPE,
    p_unitnumber IN ADDRESS.UNITNUMBER%TYPE,
    p_city IN ADDRESS.CITY%TYPE,
    p_state IN ADDRESS.STATE%TYPE,
    p_country IN ADDRESS.COUNTRY%TYPE,
    p_zipcode IN ADDRESS.ZIPCODE%TYPE
) AS
    v_customerid CUSTOMER.CUSTOMERID%TYPE;
BEGIN
    SELECT CUSTOMERID INTO v_customerid FROM CUSTOMER WHERE EMAIL = p_email;

    IF p_addresstype NOT IN ('Home', 'Work', 'Alternate') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid AddressType. Allowed types are Home, Work, Alternate.');
    END IF;

    UPDATE ADDRESS
    SET ADDRESSTYPE = NVL(p_addresstype, ADDRESSTYPE),
        STREETNAME = NVL(p_streetname, STREETNAME),
        UNITNUMBER = NVL(p_unitnumber, UNITNUMBER),
        CITY = NVL(p_city, CITY),
        STATE = NVL(p_state, STATE),
        COUNTRY = NVL(p_country, COUNTRY),
        ZIPCODE = NVL(p_zipcode, ZIPCODE)
    WHERE CUSTOMERID = v_customerid;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No customer found with the provided email.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END update_address;
/
