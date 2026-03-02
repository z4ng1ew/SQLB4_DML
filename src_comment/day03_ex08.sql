INSERT INTO menu (id, pizzeria_id, pizza_name, price) 
VALUES (
    (SELECT MAX(id) + 1 FROM menu),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    'sicilian pizza',
    900
);



SELECT COUNT(*) = 1 AS is_single_record
FROM menu
WHERE id = 20
  AND pizzeria_id = 2
  AND pizza_name = 'sicilian pizza'
  AND price = 900