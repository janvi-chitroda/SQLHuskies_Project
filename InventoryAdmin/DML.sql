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
-- INSERT INTO Category VALUES (1, 'Category1');
-- INSERT INTO Supplier VALUES (1, 'SupplierName1', 'SupplierLocation1');
-- INSERT INTO Product VALUES (1, 'Product1', 1, 100.0, 'Description1', 10);
-- INSERT INTO Warehouse VALUES (1, 1, 100);
-- INSERT INTO Customer VALUES (1, 'FirstName1', 'LastName1', 'Email1', 'Password1', 1234567890);
-- INSERT INTO Address VALUES (1, 'Type1', 1, 'StreetName1', 'UnitNumber1', 'City1', 'State1', 'Country1', 'ZipCode1');
-- INSERT INTO CustomerOrder VALUES (1, 1, CURRENT_DATE, 100.0);
-- INSERT INTO ProductOrder VALUES (1, 1, 10);
-- INSERT INTO Review VALUES (1, 1, 1, 5, 'ReviewText1');

-- Inserting 5 categories
INSERT INTO Category (CategoryID, Name) VALUES (1, 'Phone');
INSERT INTO Category (CategoryID, Name) VALUES (2, 'Laptop');
INSERT INTO Category (CategoryID, Name) VALUES (3, 'Camera');
INSERT INTO Category (CategoryID, Name) VALUES (4, 'Tablet');
INSERT INTO Category (CategoryID, Name) VALUES (5, 'Audio');

-- Inserting 5 supplier records
INSERT INTO Supplier (SupplierID, SupplierName, SupplierLocation) VALUES (1, 'Apple', 'Cupertino');
INSERT INTO Supplier (SupplierID, SupplierName, SupplierLocation) VALUES (2, 'HP', 'Palo Alto');
INSERT INTO Supplier (SupplierID, SupplierName, SupplierLocation) VALUES (3, 'Boat', 'Delhi');
INSERT INTO Supplier (SupplierID, SupplierName, SupplierLocation) VALUES (4, 'Sony', 'Tokyo');
INSERT INTO Supplier (SupplierID, SupplierName, SupplierLocation) VALUES (5, 'Nikon', 'Tokyo');

-- Inserting 10 product records
-- Phones
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (1, 'iPhone 15', 1, 999.999, 'Latest iPhone model', 20);
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (2, 'Samsung Galaxy S22', 1, 899.999, 'Latest Galaxy model', 20);
-- Laptops
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (3, 'HP Probook', 2, 599.999, 'Reliable business laptop', 15);
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (4, 'MacBook Air', 2, 999.999, 'Lightweight and powerful', 15);
-- Cameras
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (5, 'Nikon D3500', 3, 449.999, 'Great for beginners', 10);
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (6, 'Canon EOS Rebel', 3, 499.999, 'Versatile DSLR', 10);
-- Tablets
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (7, 'iPad Pro', 4, 799.999, 'Powerful performance', 20);
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (8, 'Samsung Tab S7', 4, 649.999, 'High-resolution screen', 20);
-- Audio
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (9, 'Boat Earbuds 110', 5, 49.999, 'Clear sound, noise cancellation', 30);
INSERT INTO Product (ProductID, ProductName, Category, Price, Description, MinStockQuantity) VALUES (10, 'Sony WH-1000XM4', 5, 349.999, 'Industry-leading noise cancellation', 30);

-- Inserting warehouse records
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (1, 1, 40); -- iPhone 15
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (2, 5, 40); -- Samsung Galaxy S22
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (3, 2, 30); -- HP Probook
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (4, 1, 30); -- MacBook Air
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (5, 5, 20); -- Nikon D3500
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (6, 5, 20); -- Canon EOS Rebel
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (7, 1, 40); -- iPad Pro
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (8, 5, 40); -- Samsung Tab S7
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (9, 3, 60); -- Boat Earbuds 110
INSERT INTO Warehouse (ProductID, SupplierID, ProductQty) VALUES (10, 4, 60); -- Sony WH-1000XM4

-- Inserting 7 customer records
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (1, 'John', 'Doe', 'johndoe@email.com', 'pass123', 1234567890);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (2, 'Jane', 'Smith', 'janesmith@email.com', 'pass123', 2345678901);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (3, 'Michael', 'Brown', 'michaelbrown@email.com', 'pass123', 3456789012);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (4, 'Emily', 'Davis', 'emilydavis@email.com', 'pass123', 4567890123);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (5, 'William', 'Wilson', 'williamwilson@email.com', 'pass123', 5678901234);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (6, 'Emma', 'Martinez', 'emmamartinez@email.com', 'pass123', 6789012345);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Password, ContactNumber) VALUES (7, 'Oliver', 'Taylor', 'olivertaylor@email.com', 'pass123', 7890123456);

-- Inserting 10 addresses belonging to the 7 customers with different address types
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (1, 'Home', 1, 'Maple Street', '101', 'Springfield', 'State1', 'CountryX', '12345');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (2, 'Work', 1, 'Oak Avenue', '201', 'Shelbyville', 'State2', 'CountryX', '23456');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (3, 'Home', 2, 'Pine Street', '102', 'Springfield', 'State1', 'CountryX', '12345');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (4, 'Work', 2, 'Elm Street', '202', 'Shelbyville', 'State2', 'CountryX', '23456');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (5, 'Home', 3, 'Birch Street', '103', 'Springfield', 'State1', 'CountryX', '12345');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (6, 'Work', 4, 'Cedar Avenue', '203', 'Shelbyville', 'State2', 'CountryX', '23456');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (7, 'Home', 5, 'Maple Street', '104', 'Springfield', 'State1', 'CountryX', '12345');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (8, 'Work', 6, 'Oak Avenue', '204', 'Shelbyville', 'State2', 'CountryX', '23456');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (9, 'Home', 7, 'Pine Street', '105', 'Springfield', 'State1', 'CountryX', '12345');
INSERT INTO Address (AddressID, AddressType, CustomerID, StreetName, UnitNumber, City, State, Country, ZipCode) VALUES (10, 'Work', 7, 'Elm Street', '205', 'Shelbyville', 'State2', 'CountryX', '23456');

-- Generate 10 orders by the above customers
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (1, 1, DATE '2023-09-15', 1200.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (2, 2, DATE '2023-10-01', 650.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (3, 3, DATE '2023-11-20', 500.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (4, 4, DATE '2023-12-05', 350.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (5, 5, DATE '2024-01-10', 900.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (6, 6, DATE '2024-02-15', 1100.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (7, 7, DATE '2024-03-01', 750.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (8, 1, DATE '2024-03-15', 400.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (9, 2, DATE '2024-04-05', 1200.000);
INSERT INTO CustomerOrder (OrderID, CustomerID, OrderDate, InvoiceAmount) VALUES (10, 3, DATE '2024-05-10', 550.000);

-- Generate values in the bridge table of ProductOrder
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (1, 1, 2); -- iPhone 15
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (3, 2, 1); -- HP Probook
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (5, 3, 1); -- Nikon D3500
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (9, 4, 3); -- Boat Earbuds 110
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (7, 5, 1); -- iPad Pro
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (4, 6, 1); -- MacBook Air
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (10, 7, 2); -- Sony WH-1000XM4
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (2, 8, 1); -- Samsung Galaxy S22
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (6, 9, 1); -- Canon EOS Rebel
INSERT INTO ProductOrder (ProductID, OrderID, ProductQty) VALUES (8, 10, 1); -- Samsung Tab S7

-- Generate 5 reviews by the above customers
NSERT INTO Review (ReviewID, CustomerID, ProductID, Rating, ReviewText) VALUES (1, 1, 1, 5, 'Absolutely love my new iPhone! The camera is fantastic.');
INSERT INTO Review (ReviewID, CustomerID, ProductID, Rating, ReviewText) VALUES (2, 2, 3, 4, 'HP Probook is reliable for my daily tasks, though a bit heavy.');
INSERT INTO Review (ReviewID, CustomerID, ProductID, Rating, ReviewText) VALUES (3, 3, 5, 4, 'Nikon D3500 is perfect for beginners. Great value for money.');
INSERT INTO Review (ReviewID, CustomerID, ProductID, Rating, ReviewText) VALUES (4, 4, 9, 5, 'The sound quality of Boat Earbuds 110 is clear and crisp. Love them for my workouts!');
INSERT INTO Review (ReviewID, CustomerID, ProductID, Rating, ReviewText) VALUES (5, 5, 10, 5, 'Sony WH-1000XM4 has the best noise cancellation. Worth every penny.');
