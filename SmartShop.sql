DROP TABLE IF EXISTS Deliveries;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Categories;
-- Table Definitions

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    CategoryName NVARCHAR(100) NOT NULL
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(255)
);

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY IDENTITY,
    StoreName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    StoreID INT FOREIGN KEY REFERENCES Stores(StoreID),
    StockLevel INT NOT NULL
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    StoreID INT FOREIGN KEY REFERENCES Stores(StoreID),
    SaleDate DATETIME NOT NULL,
    QuantitySold INT NOT NULL
);

-- Example Deliveries table for delayed deliveries query
CREATE TABLE Deliveries (
    DeliveryID INT PRIMARY KEY IDENTITY,
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID),
    DeliveryDate DATETIME NOT NULL,
    ExpectedDate DATETIME NOT NULL
);
-- Sample Data Inserts

-- Insert sample data into Categories
INSERT INTO Categories (CategoryName) VALUES 
('Electronics'), 
('Clothing'), 
('Groceries');

-- Insert sample data into Suppliers
INSERT INTO Suppliers (SupplierName, ContactInfo) VALUES 
('TechSource', 'techsource@email.com'),
('FashionHub', 'fashionhub@email.com'),
('FreshFoods', 'freshfoods@email.com');

-- Insert sample data into Stores
INSERT INTO Stores (StoreName, Location) VALUES 
('Downtown Store', '123 Main St'),
('Mall Store', '456 Mall Ave');

-- Insert sample data into Products
INSERT INTO Products (ProductName, Price, CategoryID, SupplierID) VALUES
('Laptop', 999.99, 1, 1),
('T-Shirt', 19.99, 2, 2),
('Apple', 0.99, 3, 3);

-- Insert sample data into Inventory
INSERT INTO Inventory (ProductID, StoreID, StockLevel) VALUES
(1, 1, 10),  -- Laptop at Downtown Store
(2, 1, 50),  -- T-Shirt at Downtown Store
(3, 2, 200); -- Apple at Mall Store

-- Insert sample data into Sales
INSERT INTO Sales (ProductID, StoreID, SaleDate, QuantitySold) VALUES
(1, 1, '2024-06-01', 2),
(2, 1, '2024-06-02', 5),
(3, 2, '2024-06-03', 20);

-- Insert sample data into Deliveries
INSERT INTO Deliveries (SupplierID, DeliveryDate, ExpectedDate) VALUES
(1, '2024-06-05', '2024-06-04'), -- Delayed
(2, '2024-06-04', '2024-06-04'), -- On time
(3, '2024-06-06', '2024-06-05'); -- Delayed

-- Indexes for optimization
CREATE INDEX idx_products_categoryid ON Products(CategoryID);
CREATE INDEX idx_inventory_productid ON Inventory(ProductID);
CREATE INDEX idx_sales_productid ON Sales(ProductID);
CREATE INDEX idx_deliveries_supplierid ON Deliveries(SupplierID);

-- Query: Retrieve all product details with category and stock level
SELECT 
    p.ProductName, 
    c.CategoryName AS Category,
    p.Price, 
    ISNULL(i.StockLevel, 0) AS StockLevel
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Inventory i ON p.ProductID = i.ProductID;

-- Query: Filter products by CategoryID and availability
DECLARE @CategoryID INT = 1; -- Set this to the desired CategoryID
SELECT 
    p.ProductName, 
    c.CategoryName AS Category,
    p.Price, 
    ISNULL(i.StockLevel, 0) AS StockLevel
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Inventory i ON p.ProductID = i.ProductID
WHERE p.CategoryID = @CategoryID
  AND ISNULL(i.StockLevel, 0) > 0;

-- Query: Filter products in a specific category by name
DECLARE @CategoryName NVARCHAR(100) = 'YourCategoryName'; -- Set this to the desired category name
SELECT 
    p.ProductName, 
    c.CategoryName AS Category,
    p.Price, 
    ISNULL(i.StockLevel, 0) AS StockLevel
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Inventory i ON p.ProductID = i.ProductID
WHERE c.CategoryName = @CategoryName;

-- Query: Filter products with low stock levels (e.g., less than 10)
SELECT 
    p.ProductName, 
    c.CategoryName AS Category,
    p.Price, 
    ISNULL(i.StockLevel, 0) AS StockLevel
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Inventory i ON p.ProductID = i.ProductID
WHERE ISNULL(i.StockLevel, 0) < 10;

-- Query: Sort products by Price in ascending order
SELECT 
    p.ProductName, 
    c.CategoryName AS Category,
    p.Price, 
    ISNULL(i.StockLevel, 0) AS StockLevel
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Inventory i ON p.ProductID = i.ProductID
ORDER BY p.Price ASC;

-- Query: Calculate total sales for each product (aggregation)
SELECT 
    p.ProductName,
    SUM(s.QuantitySold) AS TotalUnitsSold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

-- Query: Use aggregate functions to analyze sales trends
SELECT 
    p.ProductName,
    AVG(CAST(s.QuantitySold AS FLOAT)) AS AvgUnitsSold,
    MAX(s.QuantitySold) AS MaxUnitsSold,
    SUM(s.QuantitySold) AS TotalUnitsSold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

-- Query: Identify suppliers with the most delayed deliveries
SELECT 
    s.SupplierName,
    COUNT(*) AS DelayedDeliveries
FROM Suppliers s
JOIN Deliveries d ON s.SupplierID = d.SupplierID
WHERE d.DeliveryDate > d.ExpectedDate
GROUP BY s.SupplierName
ORDER BY DelayedDeliveries DESC;

