use sakila;

SELECT title
FROM film
WHERE film_id IN (
	SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c
    ON c.category_id = fc.category_id
    WHERE c.name = 'Action'
    );
    
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = 'Action'
        ));
        
SELECT f.title
FROM film f
WHERE f.film_id IN (SELECT fc.film_id
FROM film_category fc
WHERE fc.category_id IN (
	SELECT c.category_id
    FROM category c
    WHERE c.category_id = fc.category_id AND c.name = 'Action'
    ));



SELECT actor_rating.level, COUNT(num_roles) number_of_actors
FROM
(SELECT COUNT(film_id) num_roles
FROM film_actor
GROUP BY actor_id) film_count
INNER JOIN (SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) actor_rating
ON film_count.num_roles 
BETWEEN actor_rating.min_roles AND actor_rating.max_roles
GROUP BY actor_rating.level;

SELECT CONCAT(film_count.first_name, ' ', film_count.last_name) name
,actor_rating.level
,film_count.num_roles
FROM (
	SELECT a.first_name, a.last_name, COUNT(film_id) num_roles
	FROM film_actor fa
	INNER JOIN actor a
	ON fa.actor_id = a.actor_id
	GROUP BY fa.actor_id
    ) film_count
INNER JOIN (
	SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
	UNION ALL
	SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
	UNION ALL
	SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) actor_rating
ON film_count.num_roles 
	BETWEEN actor_rating.min_roles AND actor_rating.max_roles
GROUP BY film_count.first_name;
	
        
