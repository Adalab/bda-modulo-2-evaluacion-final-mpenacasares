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
-- INNER JOIN que me permitan tener una tabla con todos los campos que necesito mostrar
-- Como tenemos una tabla con los datos de los film_id que ha alquilado cada cliente, agrupamos por customer_id (va en funcion de nombre y apellido) y aplicamos COUNT a film_id para tener el conteo de peliculas 
-- alquiladas por cliente

SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(f.film_id) AS peliculas_alquiladas
	FROM customer as c
    INNER JOIN rental
		USING (customer_id) 
	INNER JOIN inventory
		USING (inventory_id)
	INNER JOIN film AS f
		USING (film_id)
    GROUP BY customer_id;
    
    
-- BORRAR    
SELECT *
	FROM film
    LIMIT 8;

SELECT *
	FROM inventory
    LIMIT 8;
    
SELECT *
	FROM rental
    LIMIT 8;

-- ----------------------------------------BONUS--------------------------------------
/*
	
*/

        
