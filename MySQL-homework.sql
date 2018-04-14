#1a. Display the first and last names of all actors from the table actor.
USE sakila;
SELECT first_name,last_name
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
SELECT CONCAT(UPPER(first_name)," ",UPPER(last_name)) AS `Actor Name`
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
# What is one query would you use to obtain this information?
SELECT actor_id,first_name,last_Name
FROM actor
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id,first_name,last_name
FROM actor
WHERE last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:

SELECT *
FROM actor
WHERE last_name LIKE '%LI%';

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

#3a. Add a middle_name column to the table actor. 
# Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD `middle_name` varchar(30) AFTER `first_name` ;

# 3b. You realize that some of these actors have tremendously long last names. 
#Change the data type of the middle_name column to blobs.

ALTER TABLE actor
MODIFY COLUMN `middle_name` BLOB;

#3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN `middle_name`;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name,count(last_name)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name,
# but only for names that are shared by at least two actors

SELECT last_name,count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name) >=2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
# the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

UPDATE actor
SET first_name = 'Harpo'
WHERE first_name = 'Groucho' AND last_name = 'Williams';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name
# after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
# Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error.
# BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER!
# (Hint: update the record using a unique identifier.)

UPDATE actor
SET first_name = 'Groucho'
WHERE first_name = 'Harpo' and last_name = 'Williams';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;


#6a. Use JOIN to display the first and last names, as well as the address,
# of each staff member. Use the tables staff and address:
SELECT first_name,last_name,address
FROM staff
LEFT JOIN address on staff.address_id = address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member
# in August of 2005. Use tables staff and payment.

SELECT first_name,last_name,SUM(amount) as `Total_Amount`
FROM staff
LEFT JOIN payment on staff.staff_id = payment.staff_id
GROUP BY first_name,last_name;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
SELECT title,count(actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECt title,count(inventory_id)
FROM film
LEFT JOIN inventory on film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';


#6e. Using the tables payment and customer and the JOIN command, 
# list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name,last_name,sum(amount)
FROM customer
LEFT JOIN payment on customer.customer_id = payment.customer_id
GROUP BY first_name,last_name
ORDER BY last_name ASC;


#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
# As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
FROM film
LEFT JOIN sakila.language on film.language_id = language.language_id
WHERE name = 'English' AND ( title LIKE 'K%' OR title LIKE 'Q%');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name,last_name
FROM actor
LEFT JOIN film_actor on actor.actor_id = film_actor.actor_id
LEFT JOIN film on film_actor.film_id = film.film_id
WHERE film.title = 'Alone Trip';

#7c. You want to run an email marketing campaign in Canada,
# for which you will need the names and email addresses of all Canadian customers.
# Use joins to retrieve this information.
SELECT first_name,last_name
FROM customer
LEFT JOIN address on customer.address_id = address.address_id
LEFT JOIN city on address.city_id = city.city_id
LEFT JOIN country on city.country_id = country.country_id
WHERE country = 'Canada';

# 7d. Sales have been lagging among young families, 
# and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title
from film
LEFT JOin film_category on film.film_id = film_category.film_id
LEFT JOIN category on category.category_id = film_category.category_id
WHERE category.name = 'Family';


#7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_id) as rental_frequency
FROM rental
LEFT JOIN inventory on inventory.inventory_id = rental.inventory_id
LEFT JOIN film on film.film_id = inventory.film_id
GROUP BY title
ORDER BY COUNT(rental_id) DESC; 

#7f. Write a query to display how much business, in dollars, each store brought in
SELECT store.store_id,SUM(amount)
FROM store
LEFT JOIN staff on store.store_id = staff.store_id
LEFT JOIN payment on payment.staff_id = staff.staff_id
GROUP BY store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id,city,country
FROM store
LEFT JOIN address on store.address_id = address.address_id
LEFT JOIN city on address.city_id = city.city_id
LEFT JOIN country on city.country_id = country.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT c.name,SUM(Amount) As Gross_Revenue
FROM category c
LEFT JOIN film_category f on c.category_id = f.category_id
LEFT JOIN inventory i on f.film_id = i.film_id
LEFT JOIN rental r on r.inventory_id = i.inventory_id
LEFT JOIN payment p on r.rental_id = p.payment_id
GROUP BY c.name
ORDER BY SUM(Amount) DESC;


#8a. In your new role as an executive, you would like to have an easy way of viewing 
#the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_five_genres AS
SELECT c.name as Genre,SUM(Amount) As Gross_Revenue
FROM category c
LEFT JOIN film_category f on c.category_id = f.category_id
LEFT JOIN inventory i on f.film_id = i.film_id
LEFT JOIN rental r on r.inventory_id = i.inventory_id
LEFT JOIN payment p on r.rental_id = p.payment_id
GROUP BY c.name
ORDER BY SUM(Amount) DESC
LIMIT 5;

SELECT * from top_five_genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;


