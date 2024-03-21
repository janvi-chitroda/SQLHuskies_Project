-- Truncate tables in reverse order of dependencies
TRUNCATE TABLE Address;
TRUNCATE TABLE Review;
TRUNCATE TABLE ProductOrder;
TRUNCATE TABLE Warehouse;
TRUNCATE TABLE CustomerOrder;
TRUNCATE TABLE Product;
TRUNCATE TABLE Category;
TRUNCATE TABLE Customer;
TRUNCATE TABLE Supplier;

-- Insert data into tables in order of dependencies
INSERT INTO Category VALUES (1, 'Category1');
INSERT INTO Supplier VALUES (1, 'SupplierName1', 'SupplierLocation1');
INSERT INTO Product VALUES (1, 'Product1', 1, 100.0, 'Description1', 10);
INSERT INTO Warehouse VALUES (1, 1, 100);
INSERT INTO Customer VALUES (1, 'FirstName1', 'LastName1', 'Email1', 'Password1', 1234567890);
INSERT INTO Address VALUES (1, 'Type1', 1, 'StreetName1', 'UnitNumber1', 'City1', 'State1', 'Country1', 'ZipCode1');
INSERT INTO CustomerOrder VALUES (1, 1, CURRENT_DATE, 100.0);
INSERT INTO ProductOrder VALUES (1, 1, 10);
INSERT INTO Review VALUES (1, 1, 1, 5, 'ReviewText1');