DELETE FROM person_order
WHERE order_date = '2022-02-24'
  AND person_id IN (
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND menu_id IN (
      SELECT id
      FROM menu
      WHERE pizza_name = 'sicilian pizza'
  );

INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES (
    (
        SELECT MAX(id) + 1
        FROM person_order
    ),
    (
        SELECT id
        FROM person
        WHERE name = 'Denis'
    ),
    (
        SELECT id
        FROM menu
        WHERE pizza_name = 'sicilian pizza'
        LIMIT 1
    ),
    '2022-02-24'
);

INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES (
    (
        SELECT MAX(id) + 1
        FROM person_order
    ),
    (
        SELECT id
        FROM person
        WHERE name = 'Irina'
    ),
    (
        SELECT id
        FROM menu
        WHERE pizza_name = 'sicilian pizza'
        LIMIT 1
    ),
    '2022-02-24'
);

SELECT COUNT(*) = 2 AS sicilian_orders_created
FROM person_order
WHERE order_date = '2022-02-24'
  AND person_id IN (
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND menu_id IN (
      SELECT id
      FROM menu
      WHERE pizza_name = 'sicilian pizza'
  );