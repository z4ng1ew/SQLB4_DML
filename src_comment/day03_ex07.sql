-- DELETE FROM menu WHERE id = 19;

INSERT INTO menu(id, pizzeria_id, pizza_name, price) 
VALUES (19, 2, 'greek pizza', 800);

SELECT count(*) = 1 AS is_inserted
FROM menu
WHERE id = 19
  AND pizzeria_id = 2
  AND pizza_name = 'greek pizza'
  AND price = 800;