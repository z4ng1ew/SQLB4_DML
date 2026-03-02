(
    SELECT pizz.name AS pizzeria_name
    FROM person client
    INNER JOIN person_visits visit ON client.id = visit.person_id
    INNER JOIN pizzeria pizz ON pizz.id = visit.pizzeria_id
    WHERE client.gender = 'female'
    
    EXCEPT ALL
    
    SELECT pizz.name
    FROM person client
    INNER JOIN person_visits visit ON client.id = visit.person_id
    INNER JOIN pizzeria pizz ON pizz.id = visit.pizzeria_id
    WHERE client.gender = 'male'
)

UNION ALL

(
    SELECT pizz.name AS pizzeria_name
    FROM person client
    INNER JOIN person_visits visit ON client.id = visit.person_id
    INNER JOIN pizzeria pizz ON pizz.id = visit.pizzeria_id
    WHERE client.gender = 'male'
    
    EXCEPT ALL
    
    SELECT pizz.name
    FROM person client
    INNER JOIN person_visits visit ON client.id = visit.person_id
    INNER JOIN pizzeria pizz ON pizz.id = visit.pizzeria_id
    WHERE client.gender = 'female'
)

ORDER BY 1;