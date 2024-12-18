USE sakila;

-- ----------------------------------------EJERCICIOS--------------------------------------
/*
	1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
*/
-- Se ha realizado una prueba con COUNT aplicada directamente a la columna title para comprobar el total de valores
-- Se comprueba, despues de COUNT y DISTINCT a la columna title, que no hay titulos duplicados

SELECT DISTINCT (title) AS titulo_pelicula
	FROM film;


/*
	2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
*/
-- Clasificacion -> columna rating

SELECT title AS titulo_pelicula_PG13
	FROM film
    WHERE rating = 'PG-13';


/*
	3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
*/

SELECT title AS titulo_pelicula, description
	FROM film
    WHERE description LIKE "%amazing%";


/*
	4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
*/
-- Duracion -> columna length
-- Se ordenan las peliculas de menor a mayor duracion para comprobar que las de menor duracion superan los 120 minutos.
-- Una vez finalizada la prueba, se elimina length del Select y el order by length ASC.

SELECT title AS titulo_pelicula
	FROM film
    WHERE length > 120;


/*
	5. Recupera los nombres de todos los actores.
*/
-- Suponemos que no quieren nombres duplicados y que el nombre esta compuesto por nombre y apellido -> devolvemos el nombre completo como concatenacion de nombre y apellido
-- Aplicamos count y distinct a la nueva columna generada "nombre_completo" y comprobamos que hay 1 nombre repetido
-- Devolvemos solucion con un DISTINCT aplicado a la columa nombre_completo para evitar duplicados

SELECT DISTINCT(CONCAT(first_name," ",last_name)) AS nombre_completo
	FROM actor
    ORDER BY nombre_completo ASC;

-- Como bonus del ejercicio se ha obtenido el valor duplicado de la siguiente manera:
	-- Agrupamos por nombre y apellido y creamos la columna conteo que nos dara el numero total de cada uno de los valores agrupados
	-- Usamos HAVING para que nos de el valor que tenga un conteo > 1, siendo este SUSAN DAVIS, que tiene un conteo = 2 -> valor repetido

	/*
		SELECT CONCAT(first_name," ",last_name) AS nombre_completo, COUNT(*) AS conteo
			FROM actor
			GROUP BY first_name, last_name
			HAVING COUNT(*) > 1
	*/


/*
	6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
*/
-- Suponemos que quieren nombre y apellido como columnas independientes y que no quieren repetidos -> el repetido es SUSAN DAVIS, por lo que no afecta en este caso
-- Usamos LIKE y no una igualdad en el WHERE porque nos piden que tenga Gibson en su apellido, pudiendo tener algo mas

SELECT first_name AS nombre, last_name AS apellido
	FROM actor
    WHERE last_name LIKE "GIBSON";


/*
	7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
*/
-- Se elimina actor_id del SELECT una vez finalizada la comprobacion
-- Usamos BETWEEN porque queremos valores dentro del rango 10 y 20 y NO especificamente esos valores, en ese caso habriamos usado IN

SELECT CONCAT(first_name," ",last_name) AS nombre_completo
	FROM actor  
	WHERE actor_id BETWEEN 10 AND 20;
    
    
/*
	8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
*/    
-- Aplicamos COUNT a title sin restricciones para saber el total de titulos de pelicula -> 1000
-- Aplicamos COUNT a title con WHERE rating = 'PG-13' -> 223
-- Aplicamos COUNT a title con WHERE rating = 'R' -> 195
-- La query final tiene un total de 582 resultados -> es correcto 1000 - 223 - 195

SELECT title AS titulo_pelicula, rating
	FROM film
    WHERE rating <> 'PG-13' AND rating <> 'R';
    
    
/*
	9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
*/ 

SELECT rating AS clasificacion, COUNT(rating) AS conteo_clasificacion
	FROM film
	GROUP BY rating;
    

/*
	10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
*/     
-- INNER JOIN que me permita tener una tabla con todos los campos que necesito mostrar
-- Como tenemos una tabla con los datos de los film_id que ha alquilado cada cliente, agrupamos por customer_id (va en funcion de nombre y apellido) y aplicamos COUNT a film_id 
-- para tener el conteo de peliculas alquiladas por cliente

SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(f.film_id) AS peliculas_alquiladas
	FROM customer as c
    INNER JOIN rental
		USING (customer_id) 
	INNER JOIN inventory
		USING (inventory_id)
	INNER JOIN film AS f
		USING (film_id)
    GROUP BY customer_id;
    
    
/*
	11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
*/     
-- Categoria en la tabla film_category -> se comprueba que esta tabla tiene todas las peliculas categorizadas

SELECT c.name AS categoria, COUNT(f_c.film_id) AS recuento_alquileres
	FROM rental AS r
	INNER JOIN inventory AS i
		USING (inventory_id)
	INNER JOIN film_category AS f_c -- Hago el INNER JOIN con film_category que contiene todas las peliculas categorizadas (category_id)
		USING (film_id)
    INNER JOIN category AS c
		USING (category_id)
	 GROUP BY c.category_id;
     
/*
	12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
*/    

SELECT rating AS clasificacion, ROUND(AVG(length),2) AS promedio_duracion
	FROM film
    GROUP BY rating;
    

/*
	13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
*/     
-- Se elimina el campo title del SELECT tras comprobacion

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM film AS f
    INNER JOIN film_actor AS f_a
		USING (film_id) 
	INNER JOIN actor AS a
		USING (actor_id)
	WHERE f.title = "Indian Love";
    
    
 /*
	14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
*/     
    -- Se elimina el campo description del SELECT tras comprobacion
    
 SELECT title AS titulo
	FROM film
    WHERE description LIKE "%dog%" OR description LIKE "%cat%";
    
    -- Al hacer las consultas por separado se comprueba hay un total de 99 peliculas que contienen dog en la description y 70 que contienen cat
    -- Al hacer la consulta buscando dog o cat en la description se han obtenido 167 resultados. Esto es debido a que se hace la busqueda eliminando aquellas description que contienen ambos valores.
    -- Se comprueba que nos da un resultado de 2 peliculas que tienen cat y dog en la description y que por tanto no se incluyen en el resultado de la query principal
    
	  /*   
		SELECT title,  description
			FROM film
			WHERE description LIKE '%dog%' AND description LIKE '%cat%';
	*/ 
    
    
/*
	15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
*/ 
-- Obtener actor_id que no este en la tabla film_actor
-- Seleccionamos aquellos actores de la tabla actor_id que NO aparecen en la subconsulta que nos indica los actor_id que SI aparecen en film_actor y por tanto, parecen en alguna película 
-- No hay ningun actor que no este asignado a, por lo menos, una pelicula
SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	WHERE a.actor_id NOT IN (SELECT f_a.actor_id
								FROM film_actor AS f_a);

-- Otra forma de obtener el resultado seria usando un LEFT JOIN que nos mantiene todos los resultados de la tabla actores combinandolo con la tabla film_actor
-- y usando el WHERE para que muestre el nombre y apellido de aquellos actores que obtuvieron un valor de actor_id null es la tabla film_actor
SELECT a.first_name AS nombre, a.last_name AS apellido, a.actor_id
	FROM actor AS a
	LEFT JOIN film_actor AS f_a 
    USING (actor_id)
	WHERE f_a.actor_id IS NULL;


/*
	16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
*/ 

SELECT title AS titulo
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010;


/*
	17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
*/ 

SELECT f.title AS titulo
	FROM film AS f
	INNER JOIN film_category AS f_c 
		USING (film_id)
    INNER JOIN category AS c
		USING (category_id)
	WHERE c.name = "Family";


/*
	18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
*/ 
-- Se elimina COUNT(f_a.film_id) del SELECT tras la comprobacion

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
    INNER JOIN film_actor AS f_a
		USING (actor_id)
	GROUP BY a.actor_id
	HAVING COUNT(f_a.film_id) > 10;


/*
	19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
*/ 
-- Asumimos que length es la duracion de la pelicula en minutos, por lo tanto length debe ser mayor que 120 

SELECT title AS titulo, length, rating
	FROM film
    WHERE length > 120 AND rating = "R";
	
    
/*
	20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
*/ 

SELECT c.name AS categoria, ROUND(AVG(f.length),2) AS promedio_duracion
	FROM film AS f
	INNER JOIN film_category AS f_c 
		USING (film_id)
    INNER JOIN category AS c
		USING (category_id)
	WHERE length > 120 -- Aplicamos el filtro antes de la agrupacion para trabajar solo con los valores que cumplen con los requisitos
    GROUP BY c.category_id;


/*
	21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
*/ 

SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(f_a.film_id) AS cantidad_peliculas
	FROM actor AS a
	INNER JOIN film_actor AS f_a 
		USING (actor_id)
    GROUP BY a.actor_id
	HAVING COUNT(f_a.film_id) >= 5;


/*
	22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con 
		una duración superior a 5 días y luego selecciona las películas correspondientes.
*/ 
-- Se eliminan r.rental_id, DATEDIFF(r.return_date, r.rental_date) del SELECT tras la comprobacion
-- Utilizamos DISTINCT(f.title) porque la misma pelicula ha podido ser alquilada varias veces durante mas de 5 dias, asi evitamos duplicados

SELECT DISTINCT(f.title) AS titulo
	FROM rental AS r
	INNER JOIN inventory AS i
		USING (inventory_id)
	INNER JOIN film AS f 
		USING (film_id)
    WHERE r.rental_id IN (SELECT rental_id
							FROM rental
							WHERE DATEDIFF(return_date, rental_date) > 5); 
	
 -- Mismo ejercicio resuelto con una CTE   
 
 WITH rental_length AS (SELECT r.rental_id
							FROM rental AS r
							WHERE DATEDIFF(return_date, rental_date) > 5)
    
 SELECT DISTINCT(f.title) AS titulo -- Habria sido mejor hacer la CTE con los INNER JOIN
	FROM rental AS r
	INNER JOIN inventory AS i
		USING (inventory_id)
	INNER JOIN film AS f 
		USING (film_id)
    WHERE r.rental_id IN (SELECT rental_id
							FROM rental_length);


/*
	23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores 
		que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
*/ 
-- Genero una tabla temporal con una CTE donde obtengo los actor_id que no han actuado en ninguna pelicula de Horror -> la utilizare en la subconsulta

WITH actor_film_horror AS (SELECT DISTINCT(a.actor_id)
								FROM actor AS a
								INNER JOIN film_actor AS f_a 
									USING (actor_id)
								INNER JOIN film_category AS f_c 
									USING (film_id)    
								INNER JOIN category AS c
									USING (category_id)
								WHERE c.name = "Horror")

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	WHERE a.actor_id NOT IN (SELECT actor_id
								FROM actor_film_horror)
	ORDER BY a.first_name;
	



-- ----------------------------------------BONUS--------------------------------------
/*
	24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
*/

SELECT title AS titulo
	FROM film AS f
	INNER JOIN film_category AS f_c 
		USING (film_id)
    INNER JOIN category AS c
		USING (category_id)
	WHERE f.length > 180 AND c.name = "Comedy";


/*
	25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
*/
-- En la tabla film_actor hay que localizar los pares de actores (actor_id) que comparten film_id -> SELF JOIN -> INNER JOIN de la tabla film_actor consigo misma
-- Para conseguir el nombre y apellido -> INNER JOIN de cada tabla film_actor con la tabla actor 
-- Para SELF JOIN necesito asignar alias

SELECT a1.first_name AS actor1_nombre, a1.last_name AS actor1_apellido, a2.first_name AS actor2_nombre, a2.last_name AS actor2_apellido, COUNT(*) AS peliculas_juntos
	FROM film_actor AS f_a1
	INNER JOIN film_actor AS f_a2
		USING (film_id) -- USING porque film_id solo esta en la tabla film_actor -> Con este INNER JOIN estoy haciendo la union consigo misma para encontrar todos los pares de actores que comparten una película 
	INNER JOIN actor AS a1 
		ON f_a1.actor_id = a1.actor_id -- Utilizo ON porque necesito especificar con los alias la procedencia de la columna actor_id sobre la que quiero aplicar el INNER JOIN (actor_id) es comun a todas las tablas
	INNER JOIN actor AS a2 
		ON f_a2.actor_id = a2.actor_id
	WHERE f_a1.actor_id < f_a2.actor_id -- IMPORTANTE porque si indicas f_a1.actor_id <> f_a2.actor_id se generan duplicados al incluirse los pares de actores de distinto orden
	GROUP BY a1.actor_id, a2.actor_id -- Agrupacion de resultados por pares de actores
		HAVING peliculas_juntos >= 1 -- peliculas_juntos es el conteo de peliculas en las que cada par de actores han estado juntos, ya que filtra resultados del GROUP BY. Filtramos con >= 1
	ORDER BY peliculas_juntos DESC;

-- Resuelto con CTE - Ejemplo facilitado por Cesar --> esto NO lo subi yo en la evaluacion
WITH ActoresRelacionados AS (
  SELECT a1.actor_id AS actor_id1, a2.actor_id AS actor_id2, COUNT(*) AS cantidad_actuaciones
  FROM film_actor a1
  JOIN film_actor a2 ON a1.film_id = a2.film_id AND a1.actor_id < a2.actor_id
  GROUP BY a1.actor_id, a2.actor_id
  HAVING COUNT(*) >= 1
)
SELECT actor1.first_name AS actor1_nombre, actor1.last_name AS actor1_apellido,
       actor2.first_name AS actor2_nombre, actor2.last_name AS actor2_apellido,
       cantidad_actuaciones
FROM ActoresRelacionados
JOIN actor AS actor1 ON actor1.actor_id = actor_id1
JOIN actor AS actor2 ON actor2.actor_id = actor_id2
ORDER BY cantidad_actuaciones DESC;
