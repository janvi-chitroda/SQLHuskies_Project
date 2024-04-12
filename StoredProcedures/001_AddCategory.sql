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