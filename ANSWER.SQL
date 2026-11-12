-- WEEK 7 ASSIGNMENT: Database Design and Normalization
-- Topic: 1NF, 2NF, 3NF

-- =====================================================
-- QUESTION 1: Achieving First Normal Form (1NF)
-- Problem: Products column had multiple values in one cell
-- Example: 'Laptop, Mouse' in one row - violates 1NF
-- Solution: Each row must have only ONE product per order
-- =====================================================

CREATE TABLE ProductOrder_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductOrder_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

SELECT * FROM ProductOrder_1NF;

-- =====================================================
-- QUESTION 2: Achieving Second Normal Form (2NF)
-- Problem: In 1NF table, CustomerName depends only on OrderID,
-- not on the full Primary Key (OrderID, Product).
-- This is called Partial Dependency - violates 2NF.
-- Solution: Split into 2 tables: Orders and OrderDetails
-- =====================================================

-- Table 1: Orders - stores order and customer info only
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Table 2: OrderDetails - stores products per order
-- OrderID is a Foreign Key from Orders table
CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderDetails (OrderID, Product) VALUES
(101, 'Laptop'),
(101, 'Mouse'),
(102, 'Tablet'),
(102, 'Keyboard'),
(102, 'Mouse'),
(103, 'Phone');

SELECT * FROM Orders;
SELECT * FROM OrderDetails;

-- =====================================================
-- QUESTION 3: Achieving Third Normal Form (3NF)
-- Problem: If we add CustomerCity, it depends on CustomerName,
-- not directly on OrderID. This is Transitive Dependency.
-- Example: OrderID -> CustomerName -> CustomerCity - violates 3NF
-- Solution: Split Customers into its own table
-- =====================================================

-- Table 1: Customers - stores customer info only
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerCity VARCHAR(100)
);

INSERT INTO Customers (CustomerID, CustomerName, CustomerCity) VALUES
(1, 'John Doe', 'Nairobi'),
(2, 'Jane Smith', 'Mombasa'),
(3, 'Emily Clark', 'Kisumu');

-- Table 2: Orders_3NF - now only links Order to Customer via ID
CREATE TABLE Orders_3NF (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders_3NF (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 3);

-- Table 3: OrderDetails_3NF - same as in 2NF
CREATE TABLE OrderDetails_3NF (
    OrderID INT,
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders_3NF(OrderID)
);

INSERT INTO OrderDetails_3NF (OrderID, Product) VALUES
(101, 'Laptop'),
(101, 'Mouse'),
(102, 'Tablet'),
(102, 'Keyboard'),
(102, 'Mouse'),
(103, 'Phone');

-- Verify 3NF with JOIN - shows full data without redundancy
SELECT 
    o.OrderID,
    c.CustomerName,
    c.CustomerCity,
    od.Product
FROM Orders_3NF o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails_3NF od ON o.OrderID = od.OrderID;
