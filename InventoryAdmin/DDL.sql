SET SERVEROUTPUT ON;

-- Delete existing sequences, if any
DECLARE
   v_exists NUMBER;
BEGIN
   -- Loop through each sequence in the database
   FOR c IN (SELECT sequence_name FROM user_sequences)
   LOOP
      -- Check if the sequence exists
      SELECT COUNT(*)
      INTO v_exists
      FROM user_sequences
      WHERE sequence_name = c.sequence_name;
      -- If the sequence exists, drop it
      IF v_exists > 0 THEN
         EXECUTE IMMEDIATE 'DROP SEQUENCE ' || c.sequence_name;
         -- Output a message indicating that the sequence was dropped
         DBMS_OUTPUT.PUT_LINE('Sequence dropped: ' || c.sequence_name);
      END IF;
   END LOOP;
EXCEPTION
   -- Handle any exceptions that occur during sequence deletion
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Delete existing tables, if any
DECLARE
   v_exists NUMBER;
BEGIN
   FOR t IN (SELECT table_name FROM user_tables)
   LOOP
      SELECT COUNT(*)
      INTO v_exists
      FROM user_tables
      WHERE table_name = t.table_name;

      IF v_exists > 0 THEN
         EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
         DBMS_OUTPUT.PUT_LINE('Table dropped: ' || t.table_name);
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


-- Create sequences
CREATE SEQUENCE ProductSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE CategorySeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE WarehouseSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ProductOrderSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE CustomerSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE AddressSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ReviewSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SupplierSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE CustomerOrderSeq START WITH 1 INCREMENT BY 1;

-- Create tables
CREATE TABLE Product (
   ProductID NUMBER(10) NOT NULL PRIMARY KEY,
   ProductName VARCHAR2(20) NOT NULL UNIQUE,
   Category NUMBER(10) NOT NULL ,
   Price NUMBER(10,3) NOT NULL ,
   Description VARCHAR2(300) NOT NULL ,
   MinStockQuantity NUMBER(10) NOT NULL 
);

CREATE TABLE Category (
   CategoryID NUMBER(10) NOT NULL  PRIMARY KEY,
   Name VARCHAR2(20) NOT NULL 
);

CREATE TABLE Warehouse (
   ProductID NUMBER(10) NOT NULL ,
   SupplierID NUMBER(10) NOT NULL ,
   ProductQty NUMBER(10) NOT NULL 
);

CREATE TABLE ProductOrder (
   ProductID NUMBER(10) NOT NULL ,
   OrderID NUMBER(10) NOT NULL ,
   ProductQty NUMBER(10) NOT NULL 
);

CREATE TABLE Customer (
   CustomerID NUMBER(10) NOT NULL  PRIMARY KEY,
   FirstName VARCHAR2(20) NOT NULL ,
   LastName VARCHAR2(20) NOT NULL ,
   Email VARCHAR2(30)  NOT NULL UNIQUE,
   Password VARCHAR2(20) NOT NULL ,
   ContactNumber NUMBER(10)  NOT NULL UNIQUE
);

CREATE TABLE Address (
   AddressID NUMBER(10)  NOT NULL PRIMARY KEY,
   AddressType VARCHAR2(20) NOT NULL CHECK (AddressType IN ('Home', 'Work', 'Alternate')),
   CustomerID NUMBER(10) NOT NULL ,
   StreetName VARCHAR2(40) NOT NULL ,
   UnitNumber VARCHAR2(20) NOT NULL ,
   City VARCHAR2(20) NOT NULL ,
   State VARCHAR2(20) NOT NULL ,
   Country VARCHAR2(20) NOT NULL ,
   ZipCode VARCHAR2(10) NOT NULL 
);

CREATE TABLE Review (
   ReviewID NUMBER(10) NOT NULL PRIMARY KEY,
   CustomerID NUMBER(10) NOT NULL,
   ProductID NUMBER(10) NOT NULL,
   Rating NUMBER(10) NOT NULL CHECK (Rating IN (1, 2, 3, 4, 5)),
   ReviewText VARCHAR2(100) NOT NULL
);

CREATE TABLE Supplier (
   SupplierID NUMBER(10) NOT NULL  PRIMARY KEY,
   SupplierName VARCHAR2(20) NOT NULL UNIQUE,
   SupplierLocation VARCHAR2(20) NOT NULL 
);

CREATE TABLE CustomerOrder (
   OrderID NUMBER(10) NOT NULL  PRIMARY KEY,
   CustomerID NUMBER(10) NOT NULL ,
   OrderDate DATE NOT NULL ,
   InvoiceAmount NUMBER(10,3) NOT NULL 
);

-- Add foreign key constraints
ALTER TABLE Product ADD CONSTRAINT fk_product_category FOREIGN KEY (Category) REFERENCES Category(CategoryID);
ALTER TABLE Warehouse ADD CONSTRAINT fk_warehouse_product FOREIGN KEY (ProductID) REFERENCES Product(ProductID);
ALTER TABLE Warehouse ADD CONSTRAINT fk_warehouse_supplier FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID);
ALTER TABLE ProductOrder ADD CONSTRAINT fk_order_product FOREIGN KEY (ProductID) REFERENCES Product(ProductID);
ALTER TABLE ProductOrder ADD CONSTRAINT fk_order_order FOREIGN KEY (OrderID) REFERENCES CustomerOrder(OrderID);
ALTER TABLE Address ADD CONSTRAINT fk_address_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID);
ALTER TABLE Review ADD CONSTRAINT fk_review_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID);
ALTER TABLE Review ADD CONSTRAINT fk_review_product FOREIGN KEY (ProductID) REFERENCES Product(ProductID);
ALTER TABLE CustomerOrder ADD CONSTRAINT fk_order_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID);



--DROP TABLE CUSTOMER CASCADE CONSTRAINTS;
--DROP TABLE CUSTOMERORDER CASCADE CONSTRAINTS;
--DROP TABLE Product CASCADE CONSTRAINTS;
--DROP TABLE PRODUCTORDER CASCADE CONSTRAINTS;
--DROP TABLE REVIEW CASCADE CONSTRAINTS;
--DROP TABLE SUPPLIER CASCADE CONSTRAINTS;
--DROP TABLE WAREHOUSE CASCADE CONSTRAINTS;
--DROP TABLE ADDRESS CASCADE CONSTRAINTS;
--DROP TABLE CATEGORY CASCADE CONSTRAINTS;
--DROP SEQUENCE ProductSeq;
--DROP SEQUENCE CategorySeq;
--DROP SEQUENCE WarehouseSeq;
--DROP SEQUENCE ProductOrderSeq;
--DROP SEQUENCE CustomerSeq;
--DROP SEQUENCE AddressSeq;
--DROP SEQUENCE ReviewSeq;
--DROP SEQUENCE SupplierSeq;
--DROP SEQUENCE CustomerOrderSeq;