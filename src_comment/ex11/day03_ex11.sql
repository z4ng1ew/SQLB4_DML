UPDATE menu
SET price = 800
WHERE pizza_name = 'greek pizza'
  AND price != 800;


UPDATE menu
SET price = price - price * 0.1
WHERE pizza_name = 'greek pizza';


SELECT (800 - 800 * 0.1) = price AS price_reduced_by_10_percent
FROM menu
WHERE pizza_name = 'greek pizza';