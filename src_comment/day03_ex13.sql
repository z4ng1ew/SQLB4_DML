DELETE FROM person_order
WHERE order_date = '2022-02-25';

DELETE FROM menu
WHERE pizza_name = 'greek pizza';

SELECT COUNT(*) = 0 AS orders_deleted
FROM person_order
WHERE order_date = '2022-02-25';

SELECT COUNT(*) = 0 AS greek_pizza_removed
FROM menu
WHERE pizza_name = 'greek pizza';