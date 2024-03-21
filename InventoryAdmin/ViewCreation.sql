-- Shows product details along with supplier and warehouse information. This is useful for understanding product inventory and supplier details.
CREATE OR REPLACE VIEW V_Product AS
SELECT P.*, W.ProductQty, S.SupplierName, S.SupplierLocation, S.SupplierId
FROM Product P
JOIN Warehouse W ON P.ProductID = W.ProductID
JOIN Supplier S ON W.SupplierID = S.SupplierID;

-- This view can show all the orders placed by each customer along with their details. It can be used by the sales and customer service department to track and manage orders.
CREATE OR REPLACE VIEW V_Order AS
SELECT O.*, C.Email, P.ProductName, PO.ProductQty
FROM CustomerOrder O
JOIN Customer C ON O.CustomerID = C.CustomerID
JOIN ProductOrder PO ON O.OrderID = PO.OrderID
JOIN Product P ON PO.ProductID = P.ProductID;

-- This view can show all addresses for each customer. It can be used by the logistics and delivery department to manage deliveries.
CREATE OR REPLACE VIEW V_CustomerAddress AS
SELECT C.CustomerID, C.FirstName, C.LastName, C.Email, A.AddressType, A.StreetName, A.UnitNumber, A.City, A.State, A.Country, A.ZipCode
FROM Customer C
JOIN Address A ON C.CustomerID = A.CustomerID;


-- This view can show all reviews for each product. It can be used by the product management and marketing department to understand customer feedback.
CREATE OR REPLACE VIEW V_ProductReview AS
SELECT P.ProductID, P.ProductName, R.Rating, R.ReviewText
FROM Product P
JOIN Review R ON P.ProductID = R.ProductID;

-- This view can show detailed information about each product ordered, including the customer who ordered it, the order details, and the supplier who supplied it. It can be used by the sales and logistics departments to track and manage orders and inventory.
CREATE OR REPLACE VIEW V_ProductOrderDetail AS
SELECT P.ProductName, C.FirstName, C.LastName, C.Email, O.OrderID, O.OrderDate, O.InvoiceAmount, PO.ProductQty, S.SupplierName
FROM Product P
JOIN ProductOrder PO ON P.ProductID = PO.ProductID
JOIN CustomerOrder O ON PO.OrderID = O.OrderID
JOIN Customer C ON O.CustomerID = C.CustomerID
JOIN Warehouse W ON P.ProductID = W.ProductID
JOIN Supplier S ON W.SupplierID = S.SupplierID;

-- This view can show all reviews given by each customer along with their order details. It can be used by the customer service and product management departments to understand customer feedback and improve products.
CREATE OR REPLACE VIEW V_CustomerReview AS
SELECT C.FirstName, C.LastName, C.Email, P.ProductName, R.Rating, R.ReviewText, O.OrderID, O.OrderDate, O.InvoiceAmount
FROM Customer C
JOIN Review R ON C.CustomerID = R.CustomerID
JOIN Product P ON R.ProductID = P.ProductID
JOIN CustomerOrder O ON C.CustomerID = O.CustomerID;

-- This view can show the total quantity and total invoice amount of each product sold. It can be used for sales analysis.
CREATE OR REPLACE VIEW V_ProductSales AS
SELECT P.ProductName, SUM(PO.ProductQty) AS TotalQuantity, SUM(O.InvoiceAmount) AS TotalInvoiceAmount
FROM Product P
JOIN ProductOrder PO ON P.ProductID = PO.ProductID
JOIN CustomerOrder O ON PO.OrderID = O.OrderID
GROUP BY P.ProductName;

-- This view can show the number of orders placed by each customer. It can be used for customer behavior analysis.
CREATE OR REPLACE VIEW V_CustomerOrderFrequency AS
SELECT C.FirstName, C.LastName, C.Email, COUNT(O.OrderID) AS OrderCount
FROM Customer C
JOIN CustomerOrder O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName, C.Email;

-- This view can show the restock status of each product. It can be used by the inventory and logistics departments to manage inventory and restocking.
CREATE OR REPLACE VIEW V_RestockReport AS
SELECT 
    c.Name AS CategoryName,
    p.ProductName,
    p.MinStockQuantity AS MinQtyRequired,
    SUM(w.ProductQty) AS InStockQuantity,
    CASE 
        WHEN SUM(w.ProductQty) <= p.MinStockQuantity THEN 'Restock Needed' 
        ELSE 'In Stock' 
    END AS StockStatus
FROM 
    Product p
JOIN 
    Category c ON p.Category = c.CategoryID
LEFT JOIN 
    Warehouse w ON p.ProductID = w.ProductID
GROUP BY 
    c.Name, p.ProductName, p.MinStockQuantity;




-- for viewing the created view
-- SELECT * FROM V_Product;
-- SELECT * FROM V_Order;
-- Select * from v_customeraddress;
-- Select * from V_ProductReview;
-- SELECT * FROM V_ProductOrderDetail;
-- SELECT * FROM v_customerreview;
-- SELECT * FROM V_ProductSales;
-- SELECT * FROM V_CustomerOrderFrequency;
-- SELECT * FROM V_RestockReport;