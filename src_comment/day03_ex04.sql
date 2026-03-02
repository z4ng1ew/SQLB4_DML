(
    SELECT pizz.name AS pizzeria_name
    FROM person client
    INNER JOIN person_order ord ON client.id = ord.person_id
    INNER JOIN menu ON menu.id = ord.menu_id
    INNER JOIN pizzeria pizz ON pizz.id = menu.pizzeria_id
    WHERE client.gender = 'female'
    
    EXCEPT
    
    SELECT pizz.name
    FROM person client
    INNER JOIN person_order ord ON client.id = ord.person_id
    INNER JOIN menu ON menu.id = ord.menu_id
    INNER JOIN pizzeria pizz ON pizz.id = menu.pizzeria_id
    WHERE client.gender = 'male'
)

UNION

(
    SELECT pizz.name AS pizzeria_name
    FROM person client
    INNER JOIN person_order ord ON client.id = ord.person_id
    INNER JOIN menu ON menu.id = ord.menu_id
    INNER JOIN pizzeria pizz ON pizz.id = menu.pizzeria_id
    WHERE client.gender = 'male'
    
    EXCEPT
    
    SELECT pizz.name
    FROM person client
    INNER JOIN person_order ord ON client.id = ord.person_id
    INNER JOIN menu ON menu.id = ord.menu_id
    INNER JOIN pizzeria pizz ON pizz.id = menu.pizzeria_id
    WHERE client.gender = 'female'
)

ORDER BY 1;
