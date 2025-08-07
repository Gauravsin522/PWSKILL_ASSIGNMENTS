# 1. Create a table called employees with the following structure
#  emp_id (integer, should not be NULL and should be a primary key)
#  emp_name (text, should not be NULL)
#  age (integer, should have a check constraint to ensure the age is at least 18)
#  email (text, should be unique for each employee)
#  salary (decimal, with a default value of 30,000).
#  Write the SQL query to create the above table with all constraints.

create database office;
use office;
create table employees(
	emp_id int not null primary key,
    emp_name varchar(30) not null,
    age int check (age <=18),
    email varchar(40) unique,
    salary float default 30000);
    
# 2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.

# Constraints are rules enforced on database tables to ensure the accuracy, validity, 
# and consistency of the data. They define how data can be inserted, updated, or 
# deleted, helping maintain data integrity by preventing invalid data from being 
#stored in the database. 
#• Primary key 
#• Foreign key 
#• Not Null 
#• Unique 
#• Check 
#• Default

# 3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer. 

# The NOT NULL constraint is applied to ensure essential fields are never left 
# blank. A primary key inherently disallows NULL values because it must 
# uniquely and reliably identify each row in the table.

#4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.

-- Creating the table
CREATE TABLE emp (
    empid INT,
    empname VARCHAR(28),
    empdep VARCHAR(30)
);

-- Adding constraints
ALTER TABLE emp 
ADD CONSTRAINT pk_emp PRIMARY KEY (empid);

ALTER TABLE emp 
ADD CONSTRAINT unique_empdep UNIQUE (empdep);

-- Removing constraints
ALTER TABLE emp 
DROP PRIMARY KEY;

ALTER TABLE emp 
DROP CONSTRAINT unique_empdep;

# 5. Explain the consequences of attempting to insert, update, or delete data in  a way that violates constraints. Provide an example of an error message that 
# might occur when violating a constraint. 

# Violating constraints leads to errors that prevent the operation from completing, 
# ensuring data integrity. Each type of constraint has specific rules and associated 
# error messages. Understanding these rules helps design and manage databases 
# effectively, avoiding unintended consequences. 
# ERROR: Column 'emp_name' cannot be null 
# ERROR: Duplicate entry '1' for key 'emp_id_UNIQUE' 
# ERROR: Cannot add or update a child row: a foreign key constraint fails

#  6. You created a products table without constraints as follows:
#  CREATE TABLE products (
#  product_id INT,
#  product_name VARCHAR(50),
#  price DECIMAL(10, 2));


#  Now, you realise that
#  The product_id should be a primary key
#  The price should have a default value of 50.00


CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2)
);

ALTER TABLE products 
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

ALTER TABLE products 
ALTER COLUMN price SET DEFAULT 50.00;

# 7.Write a query to fetch the student_name and class_name for each student using an INNER JOIN.

create table student(
	student_id int ,
    student_name varchar(10),
    class_id int);
create table classes(
	class_id int,
    class_name varchar(10));

insert into student value (1,"Alice",101),(2,"Bob",102),(3,"Charlie",101);
insert into classes value (101,"Math"),(102,"Science"),(103,"History");

SELECT 
    student.student_name, 
    classes.class_name
FROM 
    student
INNER JOIN 
    classes
ON 
    student.class_id = classes.class_id;

-- 8. Consider the following three tables:
-- Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are
-- listed even if they are not associated with an order 

CREATE TABLE orders (
    order_id INT UNIQUE PRIMARY KEY,
    order_date DATE,
    customer_id INT UNIQUE
);

insert into orders values (1,'2024-01-01',101),(2,'2024-01-03',102);

CREATE TABLE customers (
    customer_id INT UNIQUE,
    customer_name VARCHAR(50)
);

insert into customers values (101,'Alice'),(102,'Bob');

CREATE TABLE product (
    product_id INT UNIQUE,
    product_name VARCHAR(50),
    order_id INT
);

insert into product values (1,'Laptop',1),(2,'Phone',null);

SELECT 
    o.order_id, c.customer_name, p.product_name
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
        JOIN
    product p ON o.order_id = p.order_id;       
    
## 9 Write a query to find the totTablesal sales amount for each product using an INNER JOIN and the SUM() function.

create table sales (sale_id int unique, product_id int, amount int not null);

insert into sales values(1,101,500),(2,102,300),(3,101,700);
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50));
insert into products values(101,'laptop'),(102,'Phone');

SELECT 
    products.product_id AS Product, SUM(sales.amount) AS total
FROM
    products 
        JOIN
    sales ON products.product_id = sales.product_id group by Product ;

-- 10 Write a query to display the order_id, customer_name, and the quantity of products ordered by each
-- customer using an INNER JOIN between all three tables.
 create table order_details ( order_id int not null, product_id int not null , Quantity int not null);
 insert into order_details values(1,101,2),(1,102,1),(2,101,3);
 
 SELECT 
    orders.order_id, customer_name,product_id, Quantity
FROM
    order_details
        JOIN
    orders ON orders.order_id = orders.order_id
        JOIN
    customers ON orders.customer_id = customers.customer_id; 
-- 1. Identify primary and foreign keys
-- Example: PRIMARY KEY (customer_id), FOREIGN KEY (customer_id) REFERENCES rental(customer_id)
### i do in theory and output
use sakila;
-- 2. List all actors
SELECT * FROM actor;

-- 3. List all customers
SELECT * FROM customer;

-- 4. List distinct countries
SELECT DISTINCT country FROM country;

-- 5. Display active customers
SELECT * FROM customer WHERE active = 1;

-- 6. List rentals for customer ID 1
SELECT rental_id FROM rental WHERE customer_id = 1;

-- 7. Films with rental duration > 5
SELECT * FROM film WHERE rental_duration > 5;

-- 8. Films with replacement cost between $15 and $20
SELECT COUNT(*) FROM film WHERE replacement_cost BETWEEN 15 AND 20;

-- 9. Unique actor first names
SELECT COUNT(DISTINCT first_name) FROM actor;

-- 10. First 10 customers
SELECT * FROM customer LIMIT 10;

-- 11. First 3 customers whose name starts with B
SELECT * FROM customer WHERE first_name LIKE 'B%' LIMIT 3;

-- 12. First 5 'G' rated movies
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

-- 13. Customers whose name starts with 'A'
SELECT * FROM customer WHERE first_name LIKE 'A%';

-- 14. Customers whose name ends with 'A'
SELECT * FROM customer WHERE first_name LIKE '%A';

-- 15. First 4 cities that start and end with 'A'
SELECT city FROM city WHERE city LIKE 'A%A' LIMIT 4;

-- 16. Customers with "NI" in their name
SELECT * FROM customer WHERE first_name LIKE '%NI%';

-- 17. Customers with 'R' in the second position
SELECT * FROM customer WHERE first_name LIKE '_R%';

-- 18. Customers whose name starts with 'A' and is at least 5 characters long
SELECT * FROM customer WHERE first_name LIKE 'A%' AND LENGTH(first_name) >= 5;

-- 19. Customers whose name starts with 'A' and ends with 'O'
SELECT * FROM customer WHERE first_name LIKE 'A%O';

-- 20. Get films with PG and PG-13 ratings
SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

-- 21. Get films between length 50 to 100
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- 22. Get top 50 actors
SELECT * FROM actor LIMIT 50;

-- 23. Get distinct film IDs from inventory
SELECT DISTINCT film_id FROM inventory;


# Question 1:
# Retrieve the total number of rentals made in the Sakila database.
# Hint: Use the COUNT() function.

USE sakila;
SELECT COUNT(*) AS total_rentals FROM rental;

# Question 2:
# Find the average rental duration (in days) of movies rented from the Sakila database.
# Hint: Utilize the AVG() function.
SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration
FROM rental;

 #Question 3:
 #Display the first name and last name of customers in uppercase.
 #Hint: Use the UPPER () function.
 
 SELECT UPPER(first_name)as first_name ,UPPER(last_name) AS last_name
FROM customer;

 #Question 4:
 #Extract the month from the rental date and display it alongside the rental ID.
 #Hint: Employ the MONTH() function.
 
SELECT rental_id, MONTH(rental_date) AS rental_month
FROM rental;

#Question 5:
#Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
#Hint: Use COUNT () in conjunction with GROUP BY
 
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

 
#Question 6:
# Find the total revenue generated by each store.
# Hint: Combine SUM() and GROUP BY.

SELECT payment_id, SUM(amount) AS total_revenue
FROM payment
GROUP BY payment_id;

# Question 7:
# Determine the total number of rentals for each category of movies.
# Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.

SELECT c.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY fc.category_id, c.name
ORDER BY total_rentals DESC;

#Question 8:
# Find the average rental rate of movies in each language.
# Hint: JOIN film and language tables, then use AVG () and GROUP BY.

SELECT l.name AS language_name, AVG(f.rental_rate) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY average_rental_rate DESC;

### Joins
 #Questions 9 -
 #Display the title of the movie, customer's first name, and last name who rented it.
 #Hint: Use JOIN between the film, inventory, rental, and customer tables.

SELECT f.title AS Movie_Title,c.first_name AS Customer_First_Name,c.last_name AS Customer_Last_Name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

#Question 10:
 #Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
 #Hint: Use JOIN between the film actor, film, and actor tables.
 
SELECT a.first_name AS Actor_First_Name,a.last_name AS Actor_Last_Name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

#  Question 11:
 #Retrieve the customer names along with the total amount they've spent on rentals.
 #Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.
 
 SELECT c.first_name AS Customer_First_Name,c.last_name AS Customer_Last_Name,SUM(p.amount) AS Total_Amount_Spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Total_Amount_Spent DESC;

#Question 12:
 #List the titles of movies rented by each customer in a particular city (e.g., 'London').
 #Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.
SELECT c.first_name AS Customer_First_Name,c.last_name AS Customer_Last_Name,f.title AS Movie_Title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY 
c.customer_id, c.first_name, c.last_name, f.title
ORDER BY c.last_name, c.first_name, f.title;


### Advanced Joins and GROUP BY:
 #Question 13:
 #Display the top 5 rented movies along with the number of times they've been rented.
 #Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results
 
SELECT f.title AS Movie_Title,COUNT(r.rental_id) AS Times_Rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY Times_Rented DESC
LIMIT 5;

 #Question 14:
 #Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
 #Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY
 
SELECT c.first_name AS Customer_First_Name,c.last_name AS Customer_Last_Name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;

# Windows Function

-- 1. Rank the customers based on the total amount they've spent on rentals
SELECT c.first_name,c.last_name,SUM(p.amount) AS Total_Spent,RANK() OVER (ORDER BY SUM(p.amount) DESC) AS Ranks
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 2. Calculate the cumulative revenue generated by each film over time
SELECT f.title AS Film_Title,r.rental_date,SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY r.rental_date) AS Cumulative_Revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id;

-- 3. Determine the average rental duration for each film, considering films with similar lengths
SELECT f.title AS Film_Title,f.length AS Film_Length,AVG(DATEDIFF(r.return_date, r.rental_date)) AS Avg_Rental_Duration
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, f.length;

-- 4. Identify the top 3 films in each category based on their rental counts
SELECT category_id,Film_Title,Rental_Count,Ranks
FROM (SELECT fc.category_id,f.title AS Film_Title,COUNT(r.rental_id) AS Rental_Count,
        RANK() OVER (PARTITION BY fc.category_id ORDER BY COUNT(r.rental_id) DESC) AS Ranks
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY fc.category_id, f.film_id, f.title
) RankedFilms 
WHERE Ranks <= 3;

-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers
SELECT c.first_name,c.last_name,COUNT(r.rental_id) AS Total_Rentals,
    COUNT(r.rental_id) - AVG(COUNT(r.rental_id)) OVER () AS Rental_Difference
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 6. Find the monthly revenue trend for the entire rental store over time
SELECT DATE_FORMAT(r.rental_date, '%Y-%m') AS Month,SUM(p.amount) AS Monthly_Revenue,
    SUM(SUM(p.amount)) OVER (ORDER BY DATE_FORMAT(r.rental_date, '%Y-%m')) AS Cumulative_Revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY DATE_FORMAT(r.rental_date, '%Y-%m');

-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers
SELECT first_name,last_name,Total_Spent
FROM (SELECT c.first_name,c.last_name,
        SUM(p.amount) AS Total_Spent,
        NTILE(5) OVER (ORDER BY SUM(p.amount) DESC) AS Spending_Tier
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) RankedCustomers
WHERE
    Spending_Tier = 1;


-- 8. Calculate the running total of rentals per category, ordered by rental count
SELECT fc.category_id,COUNT(r.rental_id) AS Rental_Count,
    SUM(COUNT(r.rental_id)) OVER (PARTITION BY fc.category_id ORDER BY COUNT(r.rental_id) DESC) AS Running_Total
FROM film_category fc
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY fc.category_id, i.inventory_id;

-- 9. Find the films that have been rented less than the average rental count for their respective categories
WITH CategoryAverage AS (
    SELECT fc.category_id,AVG(COUNT(r.rental_id)) OVER (PARTITION BY fc.category_id) AS Avg_Rental_Count
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY 
        fc.category_id, f.film_id
)
SELECT f.title AS Film_Title,fc.category_id,COUNT(r.rental_id) AS Rental_Count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN CategoryAverage ca ON fc.category_id = ca.category_id
GROUP BY f.film_id, f.title, fc.category_id, ca.Avg_Rental_Count
HAVING COUNT(r.rental_id) < ca.Avg_Rental_Count;



-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month
SELECT 
    DATE_FORMAT(r.rental_date, '%Y-%m') AS Month,
    SUM(p.amount) AS Monthly_Revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY DATE_FORMAT(r.rental_date, '%Y-%m')
ORDER BY Monthly_Revenue DESC
LIMIT 5;

#Normalisation and CTE 
#1. First Normal Form (1NF): 
#a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF. 

#Ans: each table cell contain a single value 
#No  repeating values in a group 
#No repeating groups 
#Each record(row) is unique 
#violating First Normal Form (1NF) could be the film table if it contains a 
#repeating group or multivalued fields.

#2.  Second Normal Form (2NF): 
#a. Choose a table in Sakila and describe how you would determine whether it is 
#in 2NF.  If it violates 2NF, explain the steps to normalize it. 

#Ans: Should be INF 
#No partial Dependency 
#Occur when there is composite Key 
#Steps to Normalize the Table to Achieve 2NF 
#To remove the partial dependency, split the table into two or more tables where 
#each non-key attribute is fully dependent on the entire primary key. 
#tep 1: Split the film_actor Table 
#Original film_actor Table: 
#film_id 
#actor_id 
#last_update 
#Split it into two tables: 
#A table to store the relationship between films and actors. 
##Step 2: Create New Tables 
#film_actor Table (for relationships): 
#film_id 
#actor_id 
#film_actor_update Table (for last_update): 
#film_id 
#last_update 
#Step 3: Populate the New Tables 
#Remove last_update from the original table and move it to film_actor_update, 
#ensuring the relationship between film_id and last_update remains intact. 

#3. Third Normal Form (3NF): 
#a. Identify a table in Sakila that violates 3NF. Describe the transitive 3dependencies resent and outline the steps to normalize the table to 3NF. 

#ANS:  
#Step 1: Identify Dependencies 
#Direct Dependencies: 
#payment_id → customer_id, staff_id, rental_id, amount, payment_date, 
#customer_name 
#Transitive Dependency: 
#payment_id → customer_id → customer_name 
#Step 2: Decompose the Table 
#To remove the transitive dependency, create a new table for customer information 
#and move customer_name to this table. 
#Step 3: Create New Tables

#4. Normalization Process: 
 
# a. Take a specific table in Sakila and guide through the process of normalizing it from the initial  
 
#unnormalized form up to at least 2NF. 
 
#Normalization Process: 
#Let’s take the rental table from the Sakila database and guide it through the normalization process. 
 
#Step 1: Analyze the Initial Unnormalized Form (UNF) 
#An unnormalized form (UNF) table may have repeating groups or multivalued attributes. Assume the rental table in its UNF form looks like this: 
#rental_id rental_date inventory_id customer_id return_date staff_id film_title category 
#10:00:00 101 201 2024-01-03 
#15:00:00 1 "Avengers" Action 
#2 2024-01-01 
#12:00:00 102 202 2024-01-03 
#17:00:00 2 "Finding 
#Nemo" Animation 
#3 2024-01-02 
#09:00:00 103 203 2024-01-04 
#11:00:00 1 "Avengers" Action 
#Violations in UNF: 
#1. Repeating Group: Columns like film_title and category are attributes of the inventory_id, not 
#the rental_id. 
#32. Multivalued Dependencies: Data about the films (e.g., film_title and category) is repeated for 
#every rental. \
#Step 2: Convert to First Normal Form (1NF) 
#To convert the table to 1NF: 
#1. Ensure atomicity (no multivalued attributes or repeating groups). 
#2. Break down repeating groups into separate rows or tables. 
#Revised Table in 1NF: 
#rental_id rental_date inventory_id customer_id return_date staff_id 
#1 2024-01-01 10:00:00 101 201 2024-01-03 15:00:00 1 
#2 2024-01-01 12:00:00 102 202 2024-01-03 17:00:00 2 
#3 2024-01-02 09:00:00 103 203 2024-01-04 11:00:00 1 
#Create a separate table for film information (film table): 
#inventory_id film_title category 
#101 Avengers Action 
#102 Finding Nemo Animation 
#103 Avengers Action 
 
#Step 3: Convert to Second Normal Form (2NF) 
#To achieve 2NF: 
#1. Ensure the table is already in 1NF. 
#2. Eliminate partial dependencies, where non-key attributes depend on only part of a composite 
#primary key. 
#Key Analysis: 
##• rental table primary key: rental_id (single-column key). 
#• All columns in the rental table depend fully on rental_id, so it is in 2NF. 
#• film table primary key: inventory_id.  
#o film_title and category fully depend on inventory_id, so it is also in 2NF. 
 
#Normalized Tables (1NF to 2NF) 
#1. rental Table: 
#rental_id rental_date inventory_id customer_id return_date staff_id 
#1 2024-01-01 10:00:00 101 201 2024-01-03 15:00:00 1 
#2 2024-01-01 12:00:00 102 202 2024-01-03 17:00:00 2 
#3 2024-01-02 09:00:00 103 203 2024-01-04 11:00:00 1 
#2. film Table: 
#inventory_id film_title category 
#101 Avengers Action 
#102 Finding Nemo Animation 
#103 Avengers Action 

-- 5. CTE Basics:

--  a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 

--  have acted in from the actor and film_actor tables.
 
WITH FilmLanguageCTE AS (
    SELECT f.title AS film_title, l.name AS language_name, f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM FilmLanguageCTE;

-- 6. CTE with Joins:

--  a. Create a CTE that combines information from the film and language tables to display the film title, 

--  language name, and rental rate.

WITH CustomerRevenue AS (SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_revenue
	FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT * FROM CustomerRevenue;

-- 7 CTE for Aggregation:
--  a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
--  from the customer and payment tables.

with Total_revenue as (

select concat(c.first_name + " " + c.last_name) as Name_ , sum(p.amount) as Total_revenue 
from customer c join payment p
on c.customer_id = p.customer_id 
 group by Name_)
 
 select * from Total_revenue;
 
-- 8 CTE with Window Functions:

--  a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.

WITH FilmRankingCTE AS (
    SELECT film_id, title AS film_title, rental_duration, 
        RANK() OVER (ORDER BY rental_duration DESC) AS rank_
    FROM film
)
SELECT * FROM FilmRankingCTE
ORDER BY rank_, film_title;

-- 9 CTE and Filtering:

--  a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 

--  customer table to retrieve additional customer details

WITH CustomerRentalCount AS (
    SELECT r.customer_id, COUNT(r.rental_id) AS rental_count
    FROM rental r
    GROUP BY r.customer_id
    HAVING COUNT(r.rental_id) > 2
)
SELECT c.customer_id,c.first_name, c.last_name, c.email, crc.rental_count
FROM CustomerRentalCount crc
JOIN customer c ON crc.customer_id = c.customer_id
ORDER BY crc.rental_count DESC, c.last_name, c.first_name;

-- 10 CTE for Date Calculations:

--  a. Write a query using a CTE to find the total number of rentals made each month, considering the 

--  rental_date from the rental table
WITH MonthlyRentalCount AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
    ORDER BY rental_month
)
SELECT * FROM MonthlyRentalCount;

-- 11' CTE and Self-Join:

--  a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 

--  together, using the film_actor table.

WITH ActorPairs AS (
    SELECT fa1.actor_id AS actor1_id,fa2.actor_id AS actor2_id,f.title AS film_title
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
    JOIN film f ON fa1.film_id = f.film_id
)
SELECT a1.actor_id AS actor1_id, 
    a1.first_name AS actor1_first_name, 
    a1.last_name AS actor1_last_name, 
    a2.actor_id AS actor2_id, 
    a2.first_name AS actor2_first_name, 
    a2.last_name AS actor2_last_name, 
    film_title
FROM ActorPairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id
ORDER BY film_title, actor1_last_name, actor2_last_name;

-- 12. CTE for Recursive Search:

--  a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 

--  considering the reports_to column


CREATE TABLE staff_hierarchy (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    reports_to INT NULL
);

INSERT INTO staff_hierarchy 
VALUES
    (1, 'John', 'Smith', NULL),    -- Top-level manager
    (2, 'Jane', 'Doe', 1),         -- Reports to John
    (3, 'Mike', 'Ross', 2),        -- Reports to Jane
    (4, 'Rachel', 'Zane', 2);      -- Reports to Jane

WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Start with the specified manager (e.g., manager_id = 1)
    SELECT 
        staff_id, first_name, last_name, reports_to
    FROM staff_hierarchy
    WHERE staff_id = 1  -- Replace 1 with the desired manager's staff_id

    UNION ALL

    -- Recursive member: Find employees who report to the current level of employees
    SELECT s.staff_id, 
        s.first_name, s.last_name, s.reports_to
    FROM     
        staff_hierarchy s
    JOIN 
        EmployeeHierarchy eh ON s.reports_to = eh.staff_id
)
SELECT * 
FROM EmployeeHierarchy
ORDER BY reports_to, staff_id;









