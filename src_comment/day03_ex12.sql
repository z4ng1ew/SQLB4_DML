DELETE FROM person_order
WHERE order_date = '2022-02-25'
  AND menu_id IN (
      SELECT id
      FROM menu
      WHERE pizza_name = 'greek pizza'
  );

INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT 
    (SELECT MAX(id) FROM person_order) + gs,
    p.id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza' LIMIT 1),
    '2022-02-25'
FROM person p
CROSS JOIN generate_series(1, (SELECT COUNT(*) FROM person)) AS gs
WHERE gs = p.id;

SELECT COUNT(*) = 9 AS greek_pizza_orders_created
FROM person_order
WHERE order_date = '2022-02-25'
  AND menu_id IN (
      SELECT id
      FROM menu
      WHERE pizza_name = 'greek pizza'
  );