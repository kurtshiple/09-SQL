use sakila;
SET SQL_SAFE_UPDATES = 0;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
ALTER TABLE actor DROP COLUMN ActorName;
ALTER TABLE actor ADD ActorName VARCHAR( 50 ) after last_update;
UPDATE actor SET ActorName = CONCAT(first_name, '  ', last_name);
SELECT * FROM actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = "Joe";
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT last_name, first_name 
FROM actor 
WHERE last_name 
LIKE "%GEN%";
-- 2c. Find all actors whose last names contain the letters LI. This time, order the 
-- rows by last name and first name, in that order:
SELECT last_name, first_name 
FROM actor 
WHERE last_name 
LIKE "%LI%"
ORDER BY last_name DESC, first_name DESC;
-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries 
-- on a description, so create a column in the table actor named description and use the data type 
-- BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor 
ADD description BLOB AFTER ActorName;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor DROP COLUMN ActorName;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) COPIES
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;
-- 4b. List last names of actors and the number of actors who have that last name, but 
-- only for names that are shared by at least two actors
SELECT last_name, COUNT(*) COPIES
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor
SET last_name = 'WILLIAMS', first_name = 'HARPO', ActorName = "HARPO WILLIAMS"
WHERE actor_id = 172;
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE tbl_name

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
staff.address_id = address.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.

DROP TABLE t1;
DROP TABLE t2;

CREATE TABLE t1 (
SELECT staff_id,SUM(amount) AS totalamount
FROM payment            
GROUP BY staff_id
);
CREATE TABLE t2 (
SELECT staff_id, last_name
FROM staff            
);
SELECT t2.last_name, t1.totalamount
FROM t1 JOIN t2
ON t1.staff_id = t2.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.

CREATE TABLE t3 (
		
        SELECT film_id, COUNT(*) numactors
		FROM film_actor
		GROUP BY film_id
		HAVING COUNT(*) > 0
		ORDER BY film_id ASC

);
CREATE TABLE t4 (
		
        SELECT film_id, title
		FROM film
		

);

SELECT t4.title, t3.numactors
FROM t4 
INNER JOIN t3
ON t4.film_id = t3.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

CREATE TABLE t5 (
		
        SELECT title, COUNT(*) numdup 
		FROM film 
		GROUP BY title

);

SELECT title, numdup
FROM t5
WHERE title = "Hunchback Impossible";

-- only 1 copy

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT * FROM customer;
CREATE TABLE t6 (
SELECT customer_id,SUM(amount) AS totalamount
FROM payment            
GROUP BY customer_id
);
CREATE TABLE t7 (
SELECT customer_id, first_name, last_name
FROM customer            
);
SELECT t7.first_name, t7.last_name, t6.totalamount
FROM t7 
INNER JOIN t6
ON t7.customer_id = t6.customer_id
ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared 
-- in popularity. Use subqueries to display the titles of movies starting with the letters K 
-- and Q whose language is English.
SELECT * FROM film;
SELECT language_id = 1, title 
FROM film 
WHERE title 
LIKE "K%" OR title LIKE "Q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.


CREATE TABLE t8 (
SELECT film_id, actor_id 
FROM  film_actor
WHERE film_id = 17
);
CREATE TABLE t9 (
SELECT first_name, last_name, actor_id 
FROM  actor
);
SELECT t9.first_name, t9.last_name, t8.film_id
FROM t8 
INNER JOIN t9
ON t8.actor_id = t9.actor_id;

-- 7c. You want to run an email marketing campaign in Canada, for 
-- which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT * FROM customer;
SELECT store_id, first_name, last_name, email 
FROM  customer
WHERE store_id = 1;
-- Because there are only two stores, knowing the data makes it easy to 
-- decide to select customers who bought from the Alberta store rather than Queensland

-- 7d. Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films.
SELECT * FROM film;
SELECT title, rating
FROM film
WHERE rating IN ('PG', 'G');

-- 7e. Display the most frequently rented movies in descending order.
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM film;
DROP TABLE t10;
DROP TABLE t11;
DROP TABLE t12;
DROP TABLE t13;
DROP TABLE t14;
CREATE TABLE t10 (
		
        SELECT inventory_id, film_id, store_id
		FROM inventory 

);
CREATE TABLE t11 (
		
        SELECT inventory_id, staff_id, rental_id 
		FROM rental 

);
CREATE TABLE t12 (

SELECT t10.inventory_id, t10.film_id, t11.staff_id, t11.rental_id
FROM t10 
INNER JOIN t11
ON t10.inventory_id = t11.inventory_id

);
CREATE TABLE t13 (

SELECT title, film_id
FROM film 

);
CREATE TABLE t14 (
		
SELECT t13.title, t13.film_id, t12.staff_id, t12.rental_id 
FROM t13 
INNER JOIN t12
ON t13.film_id = t12.film_id

);
SELECT title, COUNT(*) numrents 
FROM t14 
GROUP BY title
ORDER BY numrents DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM rental;
CREATE TABLE t15 (

SELECT rental_id, amount
FROM payment 

);
CREATE TABLE t16 (
		
SELECT t14.title, t14.film_id, t14.staff_id, t14.rental_id, t15.amount 
FROM t14 
INNER JOIN t15
ON t14.rental_id = t15.rental_id

);
SELECT staff_id,SUM(amount) AS totalamount
FROM t16            
GROUP BY staff_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

CREATE TABLE t17 (

SELECT store_id, address_id
FROM store 

);
CREATE TABLE t18 (

SELECT address_id, city_id
FROM address 

);
CREATE TABLE t19 (

SELECT city_id, city, country_id
FROM city 

);
CREATE TABLE t20 (

SELECT country_id, country
FROM country 

);
CREATE TABLE t21 (

SELECT t17.store_id, t17.address_id, t18.city_id
FROM t17 
INNER JOIN t18
ON t17.address_id = t18.address_id

);
CREATE TABLE t22 (

SELECT t21.store_id, t21.address_id, t19.city_id, city, t19.country_id
FROM t21 
INNER JOIN t19
ON t21.city_id = t19.city_id

);
CREATE TABLE t23 (

SELECT t22.store_id, t22.address_id, t22.city_id, city, t20.country_id, t20.country
FROM t22 
INNER JOIN t20
ON t22.country_id = t20.country_id

);
SELECT store_id, city, country
FROM t23;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, 
-- film_category, inventory, payment, and rental.)
SELECT * FROM category;
SELECT * FROM film_category; --
SELECT * FROM inventory; --
SELECT * FROM payment;
SELECT * FROM rental; -- 

CREATE TABLE t24 (
SELECT rental_id, amount
FROM payment
WHERE rental_id IN
(
SELECT rental_id
FROM rental
)
);
   
CREATE TABLE t25 (

SELECT t24.rental_id,t24.amount,rental.inventory_id
FROM t24 
INNER JOIN rental
ON t24.rental_id = rental.rental_id

);

CREATE TABLE t26 (

SELECT t25.rental_id,t25.amount,t25.inventory_id, inventory.film_id
FROM t25 
INNER JOIN inventory
ON t25.inventory_id = inventory.inventory_id

);
CREATE TABLE t27 (

SELECT t26.rental_id,t26.amount,t26.inventory_id, t26.film_id, film_category.category_id
FROM t26 
INNER JOIN film_category
ON t26.film_id = film_category.film_id

);
CREATE TABLE t28 (

SELECT t27.rental_id,t27.amount,t27.inventory_id, t27.film_id, t27.category_id, category.name
FROM t27 
INNER JOIN category
ON t27.category_id = category.category_id

);
CREATE TABLE t29 (
SELECT name,SUM(amount) AS grossamount
FROM t28            
GROUP BY name
ORDER BY grossamount DESC
);
-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
DROP VIEW topfivegenres;
CREATE VIEW topfivegenres AS
SELECT name, grossamount
FROM t29
WHERE grossamount LIMIT 5;
SELECT * FROM topfivegenres;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM topfivegenres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW topfivegenres;
