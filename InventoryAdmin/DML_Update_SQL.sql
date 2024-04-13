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

--Execute update_product to modify product details
EXEC update_product('Nikon D3500', 1, 450.00, 'Updated: Great for all skill levels', 15);
EXEC update_product('Canon EOS Rebel', 1, 500.00, 'Updated: Excellent for amateurs and pros', 12);
EXEC update_product('iPad Pro', 2, 800.00, 'Updated: Even more powerful than before', 25);
EXEC update_product('Samsung Tab S7', 2, 650.00, 'Updated: Better screen than ever', 25);
EXEC update_product('Boat Earbuds 110', 3, 50.00, 'Updated: Better battery and sound', 35);
