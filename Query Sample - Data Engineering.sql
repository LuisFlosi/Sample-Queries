#################################################################
# Practice exercises for Data Engineering class                 #
# Extracting and manupulating data in MySQL                     #
#                                                               #
# Author: Luis Flosi                                            #
# Date: 10/30/2019                                              #
# Questions by prof. Shreenidhi Bharadwaj                       #
# Dataset: Sakila Sample (https://dev.mysql.com/doc/sakila/en/) #
#################################################################



## Question 1

# a) Show the list of databases.

SHOW DATABASES;

# b) Select sakila database.

USE sakila;

# c) Show all tables in the sakila database.

SHOW TABLES;

# d) Show each of the columns along with their data types for the actor table.

DESCRIBE actor;

# e) Show the total number of records in the actor table.

SELECT 
	COUNT(*) 
FROM 
	actor;

# f) What is the first name and last name of all the actors in the actor table ?

SELECT
	first_name, last_name
FROM
	actor;

# g) Insert your first name and middle initial ( in the last name column ) into the actors table.

INSERT INTO `actor`
  (`first_name`, `last_name`)
VALUES
  ('Luis','W');

# h) Update your middle initial with your last name in the actors table.

SET SQL_SAFE_UPDATES = 0;

UPDATE actor 
SET 
    last_name = 'Flosi'
WHERE
    last_name = 'W';

# i) Delete the record from the actor table where the first name matches your first name.

DELETE FROM actor WHERE first_name = 'Luis';

# j) Create a table payment_type with the following specifications and appropriate data types
#  Table Name : “Payment_type”
#  Primary Key: "payment_type_id”
#  Column: “Type”
#  Insert following rows in to the table:
#  1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque”

DROP TABLE IF EXISTS `Payment_type`;


CREATE TABLE `payment_type` (
  `payment_type_id` VARCHAR(10) NOT NULL,
  `Type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`payment_type_id`)
);


INSERT INTO `payment_type`
  (`payment_type_id`, `Type`)
VALUES
  ('1','Credit Card'),
  ('2','Cash'),
  ('3','Paypal'),
  ('4','Cheque');

# k) Rename table payment_type to payment_types.

RENAME TABLE payment_type TO payment_types;

# l) Drop the table payment_types.

DROP TABLE payment_types;


## Question 2

# a) List all the movies ( title & description ) that are rated PG-13 ?

SELECT
  title,
  description
FROM film
WHERE rating = 'PG-13';

# b) List all movies that are either PG OR PG-13 using IN operator ?

SELECT
  title,
  description
FROM film
WHERE rating IN ('PG-13', 'PG');

# c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ? Note : write 2 separate queries conditional operator and BETWEEN keyword

SELECT
  *
FROM payment
WHERE amount >= 2 AND amount <= 7;


SELECT
  *
FROM payment
WHERE amount BETWEEN 2 AND 7;

# d) List all addresses that have phone number that contain digits 589, start with 140 or
# end with 589. Note : write 3 different queries

SELECT
  address
FROM address
WHERE
  phone LIKE '%589%';


SELECT
  address
FROM address
WHERE
  phone LIKE '140%';


SELECT
  address
FROM address
WHERE
  phone LIKE '%589';

# e) List all staff members ( first name, last name, email ) whose password is NULL ?

SELECT
  first_name,
  last_name,
  email
FROM
  staff
WHERE
  password IS NULL;

# f) Select all films that have title names like ZOO and rental duration greater than or equal to 4

SELECT
  *
FROM film
WHERE title LIKE '%ZOO%' AND rental_duration >=4;

# g) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ? Note : use of column alias

SELECT
  rental_rate / rental_duration * 14 AS 2_week_rental_cost
FROM
  film
WHERE
  title = 'ACADEMY DINOSAUR';

# h) List all unique districts where the customers, staff, and stores are located. Note : check for NOT NULL values

SELECT
  DISTINCT district
FROM address
WHERE
  district IS NOT NULL;

# i) List the top 10 newest customers across all stores

SELECT
  customer_id
FROM
  customer
ORDER BY create_date DESC
LIMIT 10;


## Question 3

# a) Show total number of movies

SELECT
  COUNT(DISTINCT title)
FROM film;

# b) What is the minimum payment received and max payment received across all transactions ?

SELECT
  MIN(amount) AS min_payment,
  MAX(amount) AS max_payment
FROM payment;

# c) Number of customers that rented movies between Feb-2005 & May-2005 ( based on paymentDate ).
 
SELECT
  COUNT(DISTINCT customer_id)
FROM payment
WHERE payment_date BETWEEN '2005-02-01 00:00:00' AND '2005-05-31 00:00:00';

# d) List all movies where replacement_cost is greater than 15$ or rental_duration is between 6 & 10 days

SELECT
  title
FROM film
WHERE
  replacement_cost > 15 OR (rental_duration BETWEEN 6 AND 10);

# e) What is the total amount spent by customers for movies in the year 2005 ?

SELECT
  SUM(amount) AS total_spent
FROM payment
WHERE
  YEAR(payment_date) = 2005;

# f) What is the average replacement cost across all movies ?

SELECT
  AVG(replacement_cost) AS avg_replacement_cost
FROM film;

# g) What is the standard deviation of rental rate across all movies ? 

SELECT
  STD(rental_rate) AS std_rental_rate
FROM film;

# h) What is the midrange of the rental duration for all movies

SELECT
  MAX(rental_duration) + MIN(rental_duration) / 2 AS midrange
FROM film;


## Question 4

# a) Customers sorted by first Name and last name in ascending order.

SELECT
  customer_id,
  first_name,
  last_name
FROM customer
ORDER BY
  2,3;

# b) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating.

SELECT
  rating,
  COUNT(DISTINCT title) AS num_movies
FROM film
WHERE
  rating IN ("G","NC-17","PG-13","PG","R")
GROUP BY rating;

# c) Number of addresses in each district.

SELECT
  district,
  COUNT(DISTINCT address) AS num_address
FROM address
GROUP BY district;

# d) Find the movies where rental rate is greater than 1$ and order result set by descending order.

SELECT
  title,
  rental_rate
FROM film
WHERE
  rental_rate > 1
ORDER BY 2 DESC;

# e) Top 2 movies that are rated R with the highest replacement cost ?

SELECT
  title,
  MAX(replacement_cost) AS max_replacement_cost
FROM film
WHERE rating = "R"
GROUP BY 1
ORDER BY replacement_cost DESC
LIMIT 2;

# f) Find the most frequently occurring (mode) rental rate across products.

SELECT
  rental_rate,
  COUNT(*) AS count
FROM film
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

# g) Find the top 2 movies with movie length greater than 50mins and which has commentaries as a special features.

SELECT
  title
FROM film
WHERE
  length > 50 AND
  special_features LIKE "%commentaries%"
LIMIT 2;

# h) List the years which has more than 2 movies released.

SELECT
  release_year,
  COUNT(title) AS count_movies
FROM film
GROUP BY 1
HAVING count_movies > 2;


# *Part III*

## Question 1

# a) List the actors (firstName, lastName) who acted in more then 25 movies.

SELECT
  first_name,
  last_name,
  COUNT(film_id) AS num_movies
FROM
  actor a RIGHT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY 1,2
HAVING num_movies > 25
ORDER BY num_movies DESC;


# b) List the actors who have worked in the German language movies. 

SELECT
  DISTINCT a.actor_id,
  a.first_name,
  a.last_name
FROM
  actor a RIGHT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
  LEFT JOIN film f
    ON fa.film_id = f.film_id
  LEFT JOIN language l
    ON f.language_id = l.language_id 
WHERE l.name = "German";


# c) List the actors who acted in horror movies.

SELECT
  a.first_name,
  a.last_name,
  COUNT(DISTINCT fa.film_id) AS num_horror_movies
FROM
  actor a RIGHT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
  LEFT JOIN film f
    ON fa.film_id = f.film_id
  RIGHT JOIN film_category fc
    ON f.film_id = fc.film_id
  LEFT JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = "Horror"
GROUP BY 1,2
ORDER BY 3 DESC;


# d) List all customers who rented more than 3 horror movies.

SELECT
  cu.first_name,
  cu.last_name,
  COUNT(DISTINCT rental_id) AS num_rented
FROM customer cu
  LEFT JOIN rental r
    ON cu.customer_id = r.customer_id
  LEFT JOIN inventory i
    ON r.inventory_id = i.inventory_id
  LEFT JOIN film f
    ON i.film_id = f.film_id
  RIGHT JOIN film_category fc
    ON f.film_id = fc.film_id
  LEFT JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = "Horror"
GROUP BY 1,2
HAVING num_rented > 3;


# e) List all customers who rented the movie which starred SCARLETT BENING

SELECT
  cu.first_name,
  cu.last_name
FROM customer cu
  LEFT JOIN rental r
    ON cu.customer_id = r.customer_id
  LEFT JOIN inventory i
    ON r.inventory_id = i.inventory_id
  LEFT JOIN film f
    ON i.film_id = f.film_id
  right JOIN film_actor fa
    ON f.film_id = fa.film_id
  LEFT JOIN actor a
    ON fa.actor_id = a.actor_id
WHERE a.first_name = "SCARLETT" AND a.last_name = "BENING"
GROUP BY 1,2;


# f) Which customers residing at postal code 62703 rented movies that were Documentaries.

SELECT
  cu_filtered.first_name,
  cu_filtered.last_name
FROM (
  SELECT
    cu.customer_id,
    cu.first_name,
    cu.last_name,
    a.postal_code
  FROM customer cu
    LEFT JOIN address a
      ON cu.address_id = a.address_id
  HAVING a.postal_code = 62703
) cu_filtered
  LEFT JOIN rental r
    ON cu_filtered.customer_id = r.customer_id
  LEFT JOIN inventory i
    ON r.inventory_id = i.inventory_id
  LEFT JOIN film f
    ON i.film_id = f.film_id
  RIGHT JOIN film_category fc
    ON f.film_id = fc.film_id
  LEFT JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = "Documentary"
GROUP BY 1,2;


# g) Find all the addresses where the second address line is not empty (i.e., contains some text), and return these second addresses sorted.

SELECT
  address,
  address2
FROM address
WHERE LENGTH(address2) > 0
ORDER BY address2 DESC;


# h) How many films involve a “Crocodile” and a “Shark” based on film description ?

SELECT
  COUNT(*) AS num_films
FROM film
WHERE description LIKE "%Shark%" OR description LIKE "%Crocodile%";


# i)  List the actors who played in a film involving a “Crocodile” and a “Shark”, along with the release year of the movie, sorted by the actors’ last names.

SELECT
  a.first_name,
  a.last_name,
  f.release_year
FROM 
  actor a RIGHT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
  LEFT JOIN film f
    ON fa.film_id = f.film_id
WHERE f.description LIKE "%Shark%" OR f.description LIKE "%Crocodile%"
ORDER BY 2 ASC;


# j) Find all the film categories in which there are between 55 and 65 films. Return the names of categories and the number of films per category, sorted from highest to lowest by the number of films.

SELECT
  c.name,
  COUNT(DISTINCT fc.film_id) AS num_films
FROM category c
  LEFT JOIN film_category fc
    ON c.category_id = fc.category_id
GROUP BY 1
HAVING num_films BETWEEN 55 AND 65
ORDER BY num_films DESC;


# k) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than 17$?

SELECT
  c.name,
  AVG(f.replacement_cost - f.rental_rate) AS avg_diff
FROM category c
  LEFT JOIN film_category fc
    ON c.category_id = fc.category_id
  LEFT JOIN film f
    ON fc.film_id = f.film_id
GROUP BY 1
HAVING avg_diff > 17;


# l) Many DVD stores produce a daily list of overdue rentals so that customers can be contacted and asked to return their overdue DVDs. To create such a list, search the rental table for films with a return date that is NULL and where the rental date is further in the past than the rental duration specified in the film table. If so, the film is overdue and we should produce the name of the film along with the customer name and phone number.

SELECT
  f.title,
  c.first_name,
  c.last_name,
  a.phone
FROM customer c
  LEFT JOIN rental r
    ON c.customer_id = r.customer_id
  LEFT JOIN address a
    ON c.address_id = a.address_id
  LEFT JOIN inventory i
    ON r.inventory_id = i.inventory_id
  LEFT JOIN film f
    ON i.film_id = f.film_id 
WHERE r.return_date IS NULL AND DATEDIFF(r.last_update,r.rental_date) > f.rental_duration;


# m) Find the list of all customers and staff given a store id

SELECT
  s.store_id,
  c.first_name,
  c.last_name
FROM customer c LEFT JOIN store s ON c.store_id = s.store_id
UNION  
SELECT
  s.store_id,
  st.first_name,
  st.last_name
FROM staff st LEFT JOIN store s ON st.store_id = s.store_id;


## Question 2

# a) List actors and customers whose first name is the same as the first name of the actor with ID 8. 

SELECT
  c.first_name,
  c.last_name
FROM
  customer c
  RIGHT JOIN (
  SELECT
    a0.first_name
  FROM actor a0
  WHERE a0.actor_id = 8
  ) a1
    ON c.first_name = a1.first_name
UNION
SELECT
  a.first_name,
  a.last_name
FROM actor a
  RIGHT JOIN (
  SELECT
    a0.first_name
  FROM actor a0
  WHERE a0.actor_id = 8
  ) a1
  ON a.first_name = a1.first_name;


# b) List customers and payment amounts, with payments greater than average the payment amount

SELECT
  c.first_name,
  c.last_name,
  p.amount AS payment
FROM customer c
  RIGHT JOIN payment p ON c.customer_id = p.customer_id
  JOIN (SELECT AVG(amount) AS avg_amount FROM payment) am
WHERE p.amount > am.avg_amount;


# b) List customers who have rented movies at least once 

SELECT
  c.first_name,
  c.last_name
FROM customer c 
WHERE c.customer_id IN (SELECT customer_id FROM rental);


# d) Find the floor of the maximum, minimum and average payment amount

SELECT
  FLOOR(MAX(amount)) AS max_payment,
  FLOOR(MIN(amount)) AS min_payment,
  FLOOR(AVG(amount)) AS avg_payment
FROM payment;


## Question 3

# a) Create a view called actors_portfolio which contains information about actors and films ( including titles and category).

CREATE OR REPLACE VIEW actors_portfolio AS
  SELECT
    a.first_name,
    a.last_name,
    f.title,
    f.description,
    f.release_year,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    c.name AS category
  FROM actor a 
    RIGHT JOIN film_actor fa ON a.actor_id = fa.actor_id
    LEFT JOIN film f ON fa.film_id = f.film_id
    LEFT JOIN film_category fc ON f.film_id = fc.film_id
    LEFT JOIN category c ON fc.category_id = c.category_id;


SELECT * FROM actors_portfolio;



# b) Describe the structure of the view and query the view to get information on the actor ADAM GRANT

CREATE OR REPLACE VIEW adam_grant_info AS
  SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    f.title,
    f.description,
    f.release_year,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    c.name AS category
  FROM actor a 
    RIGHT JOIN film_actor fa ON a.actor_id = fa.actor_id
    LEFT JOIN film f ON fa.film_id = f.film_id
    LEFT JOIN film_category fc ON f.film_id = fc.film_id
    LEFT JOIN category c ON fc.category_id = c.category_id
  WHERE a.first_name = "ADAM" AND a.last_name = "GRANT";


DESCRIBE adam_grant_info;


SELECT * FROM adam_grant_info;


# c) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT

SELECT @max_film_id:= MAX(film_id) FROM film;


SELECT @adam_grant_id:= actor_id FROM actor WHERE first_name = "ADAM" AND last_name = "GRANT";


SELECT @scifi_id:= category_id FROM category WHERE name = "Sci-Fi";


INSERT INTO `film`(`film_id`,`title`,`description`,`release_year`,`language_id`,`length`,`replacement_cost`,`rating`, `special_features`) 
  VALUES
    (@max_film_id+1,"DATA HERO","Epic Sci-Fi movie about a data hero", 2019, 1,90,99.99,"R","Trailers");


INSERT INTO `film_actor`(`film_id`,`actor_id`) 
  VALUES
    (@max_film_id+1,@adam_grant_id);


INSERT INTO `film_category`(`film_id`,`category_id`) 
  VALUES
    (@max_film_id+1,@scifi_id);


## Question 4

# a) Extract the street number ( characters 1 through 4 ) from customer addressLine1

SELECT REGEXP_SUBSTR(address, '[0-9]{1,4}') AS stree_num FROM address;


# b) Find out actors whose last name starts with character A, B or C.

SELECT first_name, last_name FROM actor WHERE last_name REGEXP '^A|^B|^C';


# c) Find film titles that contains exactly 10 characters

SELECT title FROM film WHERE title REGEXP '^[A-Z ]{10}$';


# d) Format a payment_date using the following format e.g "22/1/2016"

SELECT DATE_FORMAT(payment_date, "%d/%m/%Y") FROM payment;


# e) Find the number of days between two date values rental_date & return_date

SELECT DATEDIFF(return_date, rental_date) AS date_difference FROM rental;


## Question 5

# *Query 1*

# Business case: Find which customers paid the most over time to see who is most valuable


SELECT
  c.first_name,
  c.last_name,
  SUM(p.amount) AS total_paid
FROM customer c
  LEFT JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY 1,2
ORDER BY 3 DESC;


# *Query 2*

# Business case: Find the most popular actor by rentals


SELECT
  a.first_name,
  a.last_name,
  COUNT(r.rental_id) AS num_rented
FROM actor a
  LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
  LEFT JOIN inventory i 
    ON fa.film_id = i.film_id
  LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY 1,2
ORDER BY 3 DESC;


# *Query 3*

# Business case: Are foreign movies more or less expensive to rent?

SELECT
  l.name,
  AVG(rental_rate)
FROM language l LEFT JOIN film f ON l.language_id = f.language_id
GROUP BY 1;


# *Query 4*

# Business case: Most active districts (could help set up new stores)


SELECT
  district,
  COUNT(rental_id) AS num_rentals
FROM address a
  LEFT JOIN customer c
    ON a.address_id = c.address_id
  LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY 1
ORDER BY 2 DESC;


# *Query 5*

# Business case: Which staffers are responsible for highest revenue


SELECT
  s.first_name,
  s.last_name,
  SUM(p.amount) AS revenue
FROM staff s
  LEFT JOIN payment p
    ON s.staff_id = p.staff_id
GROUP BY 1,2
ORDER BY 3 DESC;
