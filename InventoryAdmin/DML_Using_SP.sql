TRUNCATE TABLE Category;
TRUNCATE TABLE Address;
TRUNCATE TABLE Review;
TRUNCATE TABLE ProductOrder;
TRUNCATE TABLE Warehouse;
TRUNCATE TABLE CustomerOrder;
TRUNCATE TABLE Product;
TRUNCATE TABLE Customer;
TRUNCATE TABLE Supplier;

-- Execute the ADD_CATEGORY stored procedure for each category record
EXEC ADD_CATEGORY('Phone');
EXEC ADD_CATEGORY('Laptop');
EXEC ADD_CATEGORY('Camera');
EXEC ADD_CATEGORY('Tablet');
EXEC ADD_CATEGORY('Audio');
EXEC ADD_CATEGORY('audio');

-- Execute the ADD_SUPPLIER stored procedure for each supplier record
EXEC ADD_SUPPLIER('Apple', 'Cupertino');
EXEC ADD_SUPPLIER('HP', 'Palo Alto');
EXEC ADD_SUPPLIER('Boat', 'Mumbai');
EXEC ADD_SUPPLIER('Sony', 'Tokyo');
EXEC ADD_SUPPLIER('Nikon', 'Boston');

-- Execute the ADD_PRODUCT stored procedure for each product record
-- Phones
EXEC ADD_PRODUCT_T('iPhone 15', 'Phone', 999.999, 'Latest iPhone model', 20);
EXEC ADD_PRODUCT_T('Samsung Galaxy S22', 'Phone', 899.999, 'Latest Galaxy model', 20);

-- Laptops
EXEC ADD_PRODUCT_T('HP Probook', 'Laptop', 599.999, 'Reliable business laptop', 15);
EXEC ADD_PRODUCT_T('MacBook Air', 'Laptop', 999.999, 'Lightweight and powerful', 15);

-- Cameras
EXEC ADD_PRODUCT_T('Nikon D3500', 'Camera', 449.999, 'Great for beginners', 10);
EXEC ADD_PRODUCT_T('Canon EOS Rebel', 'Camera', 499.999, 'Versatile DSLR', 10);

-- Tablets
EXEC ADD_PRODUCT_T('iPad Pro', 'Tablet', 799.999, 'Powerful performance', 20);
EXEC ADD_PRODUCT_T('Samsung Tab S7', 'Tablet', 649.999, 'High-resolution screen', 20);

-- Audio
EXEC ADD_PRODUCT_T('Boat Earbuds 110', 'Audio', 49.999, 'Clear sound, noise cancellation', 30);
EXEC ADD_PRODUCT_T('Sony WH-1000XM4', 'Audio', 349.999, 'Industry-leading noise cancellation', 30);

-- Execute the INSERT_DATA_TO_WAREHOUSE stored procedure for each warehouse record
EXEC INSERT_DATA_TO_WAREHOUSE('iPhone 15', 'Apple', 40);
EXEC INSERT_DATA_TO_WAREHOUSE('Samsung Galaxy S22', 'Nikon', 40);
EXEC INSERT_DATA_TO_WAREHOUSE('HP Probook', 'HP', 30);
EXEC INSERT_DATA_TO_WAREHOUSE('MacBook Air', 'Apple', 30);
EXEC INSERT_DATA_TO_WAREHOUSE('Nikon D3500', 'Nikon', 20);
EXEC INSERT_DATA_TO_WAREHOUSE('Canon EOS Rebel', 'Nikon', 20);
EXEC INSERT_DATA_TO_WAREHOUSE('iPad Pro', 'Apple', 40);
EXEC INSERT_DATA_TO_WAREHOUSE('Samsung Tab S7', 'Nikon', 40);
EXEC INSERT_DATA_TO_WAREHOUSE('Boat Earbuds 110', 'Boat', 60);
EXEC INSERT_DATA_TO_WAREHOUSE('Sony WH-1000XM4', 'Sony', 60);

-- Execute the ADD_CUSTOMER stored procedure for each customer record
EXEC ADD_CUSTOMER('John', 'Doe', 'johndoe@email.com', 'pass1234', 1234567890);
EXEC ADD_CUSTOMER('Jane', 'Smith', 'janesmith@email.com', 'pass1234', 2345678901);
EXEC ADD_CUSTOMER('Michael', 'Brown', 'michaelbrown@email.com', 'pass1234', 3456789012);
EXEC ADD_CUSTOMER('Emily', 'Davis', 'emilydavis@email.com', 'pass1234', 4567890123);
EXEC ADD_CUSTOMER('William', 'Wilson', 'williamwilson@email.com', 'pass1234', 5678901234);
EXEC ADD_CUSTOMER('Emma', 'Martinez', 'emmamartinez@email.com', 'pass1234', 6789012345);
EXEC ADD_CUSTOMER('Oliver', 'Taylor', 'olivertaylor@email.com', 'pass1234', 7890123456);

-- Execute the ADD_ADDRESS procedure for each address record    
EXEC ADD_ADDRESS('Home', 'johndoe@email.com', 'Maple Street', '101', 'Springfield', 'State1', 'CountryX', '12345');
EXEC ADD_ADDRESS('Work', 'johndoe@email.com', 'Oak Avenue', '201', 'Shelbyville', 'State2', 'CountryX', '23456');
EXEC ADD_ADDRESS('Alternate', 'janesmith@email.com', 'Pine Street', '102', 'Springfield', 'State1', 'CountryX', '12345');
EXEC ADD_ADDRESS('Work', 'janesmith@email.com', 'Elm Street', '202', 'Shelbyville', 'State2', 'CountryX', '23456');
EXEC ADD_ADDRESS('Home', 'michaelbrown@email.com', 'Birch Street', '103', 'Springfield', 'State1', 'CountryX', '12345');
EXEC ADD_ADDRESS('Alternate', 'emilydavis@email.com', 'Cedar Avenue', '203', 'Shelbyville', 'State2', 'CountryX', '23456');
EXEC ADD_ADDRESS('Alternate', 'williamwilson@email.com', 'Maple Street', '104', 'Springfield', 'State1', 'CountryX', '12345');
EXEC ADD_ADDRESS('Work', 'emmamartinez@email.com', 'Oak Avenue', '204', 'Shelbyville', 'State2', 'CountryX', '23456');
EXEC ADD_ADDRESS('Home', 'olivertaylor@email.com', 'Pine Street', '105', 'Springfield', 'State1', 'CountryX', '12345');
EXEC ADD_ADDRESS('Alternate', 'olivertaylor@email.com', 'Elm Street', '205', 'Shelbyville', 'State2', 'CountryX', '23456');


-- Execute the ADD_ORDER procedure for each address record    
-- Execute the ADD_CUSTOMERORDER procedure for each address record   

-- Execute the ADD_REVIEW procedure for each review record    
EXEC ADD_REVIEW('johndoe@email.com', 'iPhone 15', 5, 'Absolutely love my new iPhone! The camera is fantastic.');
EXEC ADD_REVIEW('janesmith@email.com', 'HP Probook', 4, 'HP Probook is reliable for my daily tasks, though a bit heavy.');
EXEC ADD_REVIEW('michaelbrown@email.com', 'Nikon D3500', 4, 'Nikon D3500 is perfect for beginners. Great value for money.');
EXEC ADD_REVIEW('emilydavis@email.com', 'Boat Earbuds 110', 5, 'The sound quality of Boat Earbuds 110 is clear and crisp. Love them for my workouts!');
EXEC ADD_REVIEW('williamwilson@email.com', 'Sony WH-1000XM4', 5, 'Sony WH-1000XM4 has the best noise cancellation. Worth every penny.');


select * from category;
select * from supplier;
select * from product;
select * from warehouse;
select * from customer;