# Book Store Data Analysis using SQL

![Book Store Logo](https://github.com/Pranesh034/Book_Store_SQL-Project/blob/main/Book_Store.png)


## Overview
This project involves designing and querying a structured relational database for a bookstore, focusing on analyzing book inventory, customer behavior, and sales trends. The dataset consists of three primary tables:

Books – Contains details about books, including title, author, genre, published year, price, and stock levels.
Customers – Stores customer information such as name, email, phone, city, and country.
Orders – Tracks book purchases with details like customer ID, book ID, order date, quantity, and total amount spent.

The project leverages SQL for data processing, querying, and reporting, helping extract meaningful insights into book sales, customer preferences, and inventory management.


## Objectives
Create and manage a relational database for a bookstore.

Load and organize book, customer, and order data.

Analyze book inventory, genres, and pricing trends.

Track customer orders, spending, and locations.

Identify top-selling books and high-revenue customers.


## Datasets

Here are the datasets used in this project:

- [Books Dataset](https://github.com/Pranesh034/Book_Store_SQL-Project/raw/main/Books.csv)
- [Customers Dataset](https://github.com/Pranesh034/Book_Store_SQL-Project/raw/main/Customers.csv)
- [Orders Dataset](https://github.com/Pranesh034/Book_Store_SQL-Project/raw/main/Orders.csv)


## Database Schema and Queries

The database consists of three tables: **Books**, **Customers**, and **Orders**.

```sql
-- Drop tables if they exist
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;

-- Create Books table
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

-- Create Customers table
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

-- Create Orders table
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

-- Load data into tables
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\Harish\Downloads\Books.csv' 
CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\Harish\Downloads\Customers.csv' 
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\Harish\Downloads\Orders.csv' 
CSV HEADER;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1. Retrieve all books in the "Fiction" genre
SELECT * FROM Books WHERE Genre = 'Fiction';

-- 2. Find books published after the year 1950
SELECT * FROM Books WHERE Published_Year > 1950;

-- 3. List all customers from Canada
SELECT * FROM Customers WHERE Country = 'Canada';

-- 4. Show orders placed in November 2023
SELECT * FROM Orders
WHERE Order_Date >= '2023-11-01' AND Order_Date < '2023-12-01';

-- 5. Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock FROM Books;

-- 6. Find the details of the most expensive book
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 7. Show all customers who ordered more than 1 quantity of a book
SELECT c.Name AS Cust_Name, SUM(o.Quantity) AS Total_Quantity 
FROM Customers c 
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name 
HAVING SUM(o.Quantity) > 1 
ORDER BY Total_Quantity;

-- 8. Find each genre and how many books are available in that genre
SELECT Genre, COUNT(Genre) AS Books_Count FROM Books GROUP BY Genre;

-- 9. Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity) AS Total_Sold 
FROM Books b 
JOIN Orders o ON b.Book_ID = o.Book_ID 
GROUP BY b.Genre;

-- 10. Find the average price of books in the "Fantasy" genre
SELECT ROUND(AVG(Price)) AS Avg_Price FROM Books WHERE Genre = 'Fantasy';

-- 11. Find the top 3 most frequently ordered books
SELECT b.Title, SUM(o.Quantity) AS Total_Orders 
FROM Books b 
JOIN Orders o ON b.Book_ID = o.Book_ID 
GROUP BY b.Title 
ORDER BY Total_Orders DESC LIMIT 3;

-- 12. List the cities where customers who spent over $30 are located
SELECT c.City, SUM(o.Total_Amount) AS Total_Spent
FROM Customers c 
JOIN Orders o ON c.Customer_ID = o.Customer_ID 
GROUP BY c.City 
HAVING SUM(o.Total_Amount) > 30 
ORDER BY Total_Spent;

-- 13. Find the customer who placed the highest total order amount
SELECT c.Name, SUM(o.Total_Amount) AS Total_Spent 
FROM Customers c 
JOIN Orders o ON c.Customer_ID = o.Customer_ID 
GROUP BY c.Name 
ORDER BY Total_Spent DESC LIMIT 1;

-- 14. List the books that have never been ordered
SELECT Title FROM Books 
WHERE Book_ID NOT IN (SELECT DISTINCT(Book_ID) FROM Orders);

-- 15. Find books that are priced higher than the average price of all books
SELECT Title, Price FROM Books 
WHERE Price > (SELECT AVG(Price) FROM Books);
