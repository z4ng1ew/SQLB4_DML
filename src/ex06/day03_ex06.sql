SELECT menu1.pizza_name,
       pizz1.name AS pizzeria_name_1,
       pizz2.name AS pizzeria_name_2,
       menu1.price

FROM menu menu1

INNER JOIN menu menu2
    ON menu1.id <> menu2.id
    AND menu1.pizza_name = menu2.pizza_name
    AND menu1.price = menu2.price
    AND menu1.pizzeria_id > menu2.pizzeria_id

INNER JOIN pizzeria pizz1 ON menu1.pizzeria_id = pizz1.id
INNER JOIN pizzeria pizz2 ON menu2.pizzeria_id = pizz2.id

ORDER BY 1;