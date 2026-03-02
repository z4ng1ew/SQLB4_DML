SELECT pizza_name,
       price,
       pizz.name AS pizzeria_name

FROM (
    SELECT id AS menu_id
    FROM menu
    
    EXCEPT
    
    SELECT menu_id
    FROM person_order
) AS unordered_menu

INNER JOIN menu
    ON unordered_menu.menu_id = menu.id

INNER JOIN pizzeria pizz
    ON pizz.id = menu.pizzeria_id

ORDER BY 1, 2;