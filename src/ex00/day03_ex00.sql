SELECT pizza_name,
       price,
       pizz.name AS pizzeria_name,
       visit.visit_date

FROM menu

INNER JOIN pizzeria pizz
    ON pizz.id = menu.pizzeria_id

INNER JOIN person_visits visit
    ON pizz.id = visit.pizzeria_id

INNER JOIN person client
    ON client.id = visit.person_id

WHERE price BETWEEN 800 AND 1000
  AND client.name = 'Kate'

ORDER BY 1, 2, 3;