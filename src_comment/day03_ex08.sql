DELETE FROM person_order
WHERE menu_id IN (
    SELECT id
    FROM menu
    WHERE pizza_name = 'sicilian pizza'
      AND pizzeria_id = (
          SELECT id
          FROM pizzeria
          WHERE name = 'Dominos'
      )
);

DELETE FROM menu
WHERE pizza_name = 'sicilian pizza'
  AND pizzeria_id = (
      SELECT id
      FROM pizzeria
      WHERE name = 'Dominos'
  );


INSERT INTO menu (id, pizzeria_id, pizza_name, price)
VALUES (
    (
        SELECT MAX(id) + 1
        FROM menu
    ),
    (
        SELECT id
        FROM pizzeria
        WHERE name = 'Dominos'
    ),
    'sicilian pizza',
    900
);


SELECT COUNT(*) = 1 AS is_single_record
FROM menu
WHERE pizza_name = 'sicilian pizza'
  AND pizzeria_id = (
      SELECT id
      FROM pizzeria
      WHERE name = 'Dominos'
  )
  AND price = 900;