USE sakila;

SELECT t1.country, SUM(t1.amount) AS total_payments
FROM (
SELECT p.amount, cn.country
FROM payment p
INNER JOIN customer c
ON c.customer_id = p.customer_id
INNER JOIN address a
ON a.address_id = c.address_id
INNER JOIN city ci
ON ci.city_id = a.city_id
INNER JOIN country cn
ON cn.country_id = ci.country_id) t1
GROUP BY t1.country;

CREATE VIEW payments_country
AS
SELECT cn.country,
	(SELECT SUM(p.amount)
    FROM city ci
    INNER JOIN address a
    ON ci.city_id = a.city_id
    INNER JOIN customer cm
    ON a.address_id = cm.address_id
    INNER JOIN payment p
    ON cm.customer_id = p.customer_id
    WHERE ci.country_id = cn.country_id
    ) AS tot_payments
FROM country cn;

SELECT rating
FROM film
LIMIT 10;

SELECT COUNT(rating) G
FROM film
WHERE rating = 'G';

CREATE VIEW rating_distribution
AS 
SELECT 
	COUNT(CASE 
		WHEN rating = 'G' THEN 1
	END) as 'G',
    COUNT(CASE 
		WHEN rating = 'PG' THEN 1
	END) as 'PG',
    COUNT(CASE 
		WHEN rating = 'PG-13' THEN 1
	END) as 'PG-13',
    COUNT(CASE 
		WHEN rating = 'R' THEN 1
	END) as 'R',
    COUNT(CASE 
		WHEN rating = 'NC-17' THEN 1
	END) as 'NC-17'
FROM film;

SELECT g
FROM rating_distribution;

SELECT a.CONCAT(first_name + ' ' + last_name) full_name,
	f.release_year,
    COUNT(film_id) films_made
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id;

SELECT (SELECT COUNT(f.film_id) FROM film f
		WHERE f.film_id = fa.film_id) films_made
FROM film_actor fa;

CREATE VIEW film_stats
AS
SELECT f.film_id, f.title, f.description, f.rating,
	(SELECT c.name
    FROM category c
		INNER JOIN film_category fc
        ON c.category_id = fc.category_id
	WHERE fc.film_id = f.film_id) category_name,
    (SELECT COUNT(*)
    FROM film_actor fa
    WHERE fa.film_id = f.film_id) num_actors,
    (SELECT COUNT(*)
    FROM inventory i
    WHERE i.film_id = f.film_id) inventory_cnt,
    (SELECT COUNT(*)
    FROM inventory i 
    INNER JOIN rental r
    ON i.inventory_id = r.inventory_id
    WHERE i.film_id = f.film_id) num_rentals
FROM film f;

SELECT *
FROM film_stats;

CREATE VIEW rental_stats_test
AS
SELECT rating,
	SUM(inventory_cnt)
FROM film_stats;

SELECT *
FROM rental_stats
WHERE rent_ratio > 4
ORDER BY rating;

SELECT CONCAT(a.first_name, ' ', a.last_name) full_name,
	f.release_year,
    films_made.*
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
INNER JOIN (SELECT COUNT(film_id) film_count
	FROM film_actor
	GROUP BY actor_id) films_made
ON films_made.actor_id = a.actor_id;