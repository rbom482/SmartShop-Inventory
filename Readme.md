# SmartShop Inventory System

This project is a sample SQL database and query set for the **SmartShop Inventory System**, designed for a fictional retail company. The system manages inventory, sales, and supplier data across multiple stores, providing real-time insights into stock levels, sales trends, and supplier performance.

## Features

- **Database Schema:**  
  Includes tables for Categories, Suppliers, Stores, Products, Inventory, Sales, and Deliveries.

- **Sample Data:**  
  Pre-populated with example data for easy testing and demonstration.

- **Basic Queries:**  
  - Retrieve product details (name, category, price, stock level)
  - Filter products by category, availability, and low stock
  - Sort products by price

- **Complex Queries:**  
  - Aggregate sales data (total, average, max units sold per product)
  - Identify suppliers with the most delayed deliveries
  - Use of JOINs, GROUP BY, and aggregate functions

- **Performance Optimization:**  
  - Indexes on frequently queried columns
  - Query restructuring for efficiency

## How to Use

1. **Clone or Download the Repository**
2. **Open the `SmartShop.sql` file in your SQL environment (e.g., SQL Server, Azure Data Studio, VS Code with SQL extension)**
3. **Run the entire script** to create tables, insert sample data, and execute queries.

## Example Queries

- Retrieve all product details:
    ```sql
    SELECT p.ProductName, c.CategoryName AS Category, p.Price, ISNULL(i.StockLevel, 0) AS StockLevel
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
    LEFT JOIN Inventory i ON p.ProductID = i.ProductID;
    ```

- Calculate total sales for each product:
    ```sql
    SELECT p.ProductName, SUM(s.QuantitySold) AS TotalUnitsSold
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    GROUP BY p.ProductName;
    ```

- Identify suppliers with the most delayed deliveries:
    ```sql
    SELECT s.SupplierName, COUNT(*) AS DelayedDeliveries
    FROM Suppliers s
    JOIN Deliveries d ON s.SupplierID = d.SupplierID
    WHERE d.DeliveryDate > d.ExpectedDate
    GROUP BY s.SupplierName
    ORDER BY DelayedDeliveries DESC;
    ```

## Copilot Assistance Summary

- **Query Generation:** Used Copilot to generate both basic and complex SQL queries.
- **Debugging:** Leveraged Copilot to identify and fix JOIN issues, variable declarations, and syntax errors.
- **Optimization:** Implemented Copilot’s suggestions for indexing and query restructuring to improve performance.
- **Validation:** Used Copilot to test, validate, and ensure accuracy and efficiency of all queries.

## License

This project is for educational purposes.