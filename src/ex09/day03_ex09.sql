insert into person_visits values (
((SELECT MAX(id) FROM person_visits) + 1),
(SELECT id FROM person WHERE name = 'Denis'),
(SELECT id FROM pizzeria WHERE name = 'Dominos'),
'2022-02-24');
insert into person_visits values (
((SELECT MAX(id) FROM person_visits) + 1),
(SELECT id FROM person WHERE name = 'Irina'),
(SELECT id FROM pizzeria WHERE name = 'Dominos'),
'2022-02-24');