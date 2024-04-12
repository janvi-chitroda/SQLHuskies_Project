--Execute UPDATE_SUPPLIER to modify supplier values
EXEC UPDATE_SUPPLIER(1,'Apple Incc');
EXEC UPDATE_SUPPLIER(2,Null,'San Jose, Cali');
EXEC UPDATE_SUPPLIER(3,Null, 'Mumbai');
EXEC UPDATE_SUPPLIER(4,'Sony', 'Tokyoooooo');
EXEC UPDATE_SUPPLIER(5,'Nikon Corporation', 'Boston');

--Execute UPDATE_WAREHOUSE_QUANTITY to modify product quantity in warehouse
EXEC UPDATE_WAREHOUSE_QUANTITY('Apple', 'iPhone 15', 40);
EXEC UPDATE_WAREHOUSE_QUANTITY('Nikon', 'Samsung Galaxy S22', 40);
EXEC UPDATE_WAREHOUSE_QUANTITY('HP', 'HP Probook', 30);
EXEC UPDATE_WAREHOUSE_QUANTITY('Boat', 'Boat Earbuds 110', 60);
EXEC UPDATE_WAREHOUSE_QUANTITY('Sony', 'Sony WH-1000XM4', 60);
