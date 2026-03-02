SELECT pizz.name AS pizzeria_name
FROM person_visits visit
INNER JOIN person client ON client.id = visit.person_id
INNER JOIN pizzeria pizz ON pizz.id = visit.pizzeria_id
WHERE client.name = 'Andrey'

EXCEPT

SELECT pizz.name
FROM person_order ord
INNER JOIN person client ON client.id = ord.person_id
INNER JOIN menu ON menu.id = ord.menu_id
INNER JOIN pizzeria pizz ON pizz.id = menu.pizzeria_id
WHERE client.name = 'Andrey'

ORDER BY 1;
