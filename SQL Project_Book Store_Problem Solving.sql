DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


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

select * from books where genre = 'Fiction';


-- 2. Find books published after the year 1950

select * from books where published_year > 1950;


-- 3. List all customers from Canada

select * from customers where country = 'Canada';


-- 4. Show orders placed in November 2023

select * from orders
where order_date >= '2023-11-01' AND order_date < '2023-12-01';


-- 5. Retrieve the total stock of books available

select sum(stock) Total_Stock from books;


-- 6. Find the details of the most expensive book

select * from books order by price desc limit 1;


-- 7. Show all customers who ordered more than 1 quantity of a book

select c.name cust_name, sum(o.quantity) total_quantity from customers c 
join orders o on c.customer_id = o.customer_id
group by c.name having sum(o.quantity)>1 order by total_quantity;


-- 8. Find each genre and how many books are available in that genre

select genre, count(genre) Books_Count from books group by genre;


-- 9. Retrieve the total number of books sold for each genre

select b.genre, sum(o.quantity) Total_Sold 
from books b join orders o on b.book_id = o.book_id group by genre;


-- 10. Find the average price of books in the "Fantasy" genre

select round(avg(price)) Avg_Price from books where genre = 'Fantasy';


-- 11. Find the top 3 most frequently ordered books

select b.title, sum(o.quantity) total_orders 
from books b join orders o on b.book_id = o.book_id group by b.title order by total_orders desc limit 3;


-- 12. List the cities where customers who spent over $30 are located

select c.city, sum(o.total_amount) Total_Spent
from customers c join orders o on c.customer_id = o.customer_id 
group by c.city having sum(o.total_amount) > 30 order by Total_Spent;


-- 13. Find the customer who placed the highest total order amount

select c.name, sum(o.total_amount) total_spent from customers c 
join orders o on c.customer_id = o.customer_id group by c.name order by total_spent desc limit 1;


-- 14. List the books that have never been ordered

select title from books where book_id not in 
(select distinct(book_id) from orders);


-- 15. Find books that are priced higher than the average price of all books

select title, price from books where price >
(select avg(price) from books);
