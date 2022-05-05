USE sakila;
#In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
#Convert the query into a simple stored procedure. Use the following query:

    
    DELIMITER //
create procedure action_movie(out param1 int)
begin
  
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  end //
DELIMITER ;

call action_movie(@_action);



#Now keep working on the previous stored procedure to make it more dynamic. 
#Update the stored procedure in a such manner that it can take a string argument for the category name and return the results 
#for all customers that rented movie of that category/genre. 

DELIMITER //
create procedure movies1(in param1 varchar(20), out param2 int)
begin
  
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = param1
  group by first_name, last_name, email;
  end //
DELIMITER ;

call movies1('comedy', @_movie);

#Write a query to check the number of movies released in each movie category. 

SELECT 
	c.name , 
    count(f.film_id) as Number_of_movies from film f
JOIN
	film_category fc 
USING
	(film_id)
JOIN
	category c
USING
	(category_id)
GROUP BY
	c.name;

#Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
#Pass that number as an argument in the stored procedure.

DELIMITER $$

Create Procedure movie_category(in param1 int)

Begin
select c.name , count(f.film_id) as Number_of_movies from film f
join
film_category fc on f.film_id = fc.film_id
join
category c on fc.category_id = c.category_id
group by c.name
having count(f.film_id)  COLLATE utf8mb4_general_ci > param1;

END $$

-- Calling stored procedure
DELIMITER ;
call movie_category(65);