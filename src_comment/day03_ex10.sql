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



























  # 📝 SQL Комментарий для Задания 10


-- ============================================================================
-- SQL Bootcamp Day 03 — Exercise 10
-- ============================================================================
-- Задание: Зарегистрировать заказы от Denis и Irina на новое блюдо меню
--          "sicilian pizza" 24 февраля 2022 года
-- Требование: НЕ использовать прямые числовые значения для ID
-- ============================================================================

-- ОПИСАНИЕ ПОДХОДА:
-- 1. DELETE: Удаляем старые заказы Denis и Irina на sicilian pizza (если есть)
-- 2. INSERT #1: Добавляем заказ от Denis на sicilian pizza
-- 3. INSERT #2: Добавляем заказ от Irina на sicilian pizza
-- 4. SELECT: Проверяем, что создано ровно 2 заказа
--
-- КОНТЕКСТ (цепочка заданий):
-- Задание 08: Добавили sicilian pizza в меню Dominos (menu.id=20)
-- Задание 09: Зафиксировали посещения Denis и Irina в Dominos
-- Задание 10: Регистрируем заказы на sicilian pizza (→ МЫ ЗДЕСЬ)
-- Задание 11: Изменим цену на greek pizza
-- Задание 12-13: Массовые операции и откат

-- ИДЕМПОТЕНТНОСТЬ: Скрипт можно запускать многократно без ошибок

-- ============================================================================
-- ШАГ 1: Удаление существующих заказов (для идемпотентности)
-- ============================================================================

DELETE FROM person_order
WHERE order_date = '2022-02-24'
  AND person_id IN (
      -- Подзапрос: находим ID Denis и Irina
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND menu_id IN (
      -- Подзапрос: находим ID всех sicilian pizza
      SELECT id
      FROM menu
      WHERE pizza_name = 'sicilian pizza'
  );

-- ЗАЧЕМ ЭТОТ DELETE:
-- Делает скрипт идемпотентным - можно запускать многократно
-- - При первом запуске: удалит 0 строк (заказов ещё нет)
-- - При повторном запуске: удалит 2 строки (заказы от Denis и Irina)
-- - Освобождает место для новых INSERT

-- ЛОГИКА ПОДЗАПРОСОВ:
-- 1. person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
--    → Возвращает ID: {4, 6}
--    
-- 2. menu_id IN (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza')
--    → Возвращает ID: {20} (из задания 08)
--    Примечание: Может быть несколько sicilian pizza в разных пиццериях!
--    Поэтому используем IN, а не =
--
-- 3. order_date = '2022-02-24'
--    → Только заказы от 24 февраля

-- ПОЧЕМУ ТРИ УСЛОВИЯ:
-- Фильтруем точечно, чтобы не удалить лишние заказы:
-- 1. order_date: только эта дата (могут быть другие заказы Denis и Irina)
-- 2. person_id IN: только эти два человека
-- 3. menu_id IN: только sicilian pizza (не другие пиццы)

-- ВИЗУАЛИЗАЦИЯ:
-- ДО DELETE (если были заказы из предыдущих запусков):
-- person_order
-- ┌────┬───────────┬─────────┬────────────┐
-- │ id │ person_id │ menu_id │ order_date │
-- ├────┼───────────┼─────────┼────────────┤
-- │ 21 │ 4         │ 20      │ 2022-02-24 │ ← Denis → sicilian pizza
-- │ 22 │ 6         │ 20      │ 2022-02-24 │ ← Irina → sicilian pizza
-- └────┴───────────┴─────────┴────────────┘
--
-- ПОСЛЕ DELETE:
-- person_order
-- ┌────┬───────────┬─────────┬────────────┐
-- │ id │ person_id │ menu_id │ order_date │
-- ├────┼───────────┼─────────┼────────────┤
-- │    │           │         │            │ ← Заказы удалены
-- └────┴───────────┴─────────┴────────────┘

-- ============================================================================
-- ШАГ 2: Вставка заказа от Denis
-- ============================================================================

INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES (
    -- Подзапрос 1: Автоматический ID
    (
        SELECT MAX(id) + 1
        FROM person_order
    ),
    
    -- Подзапрос 2: ID Denis
    (
        SELECT id
        FROM person
        WHERE name = 'Denis'
    ),
    
    -- Подзапрос 3: ID sicilian pizza
    (
        SELECT id
        FROM menu
        WHERE pizza_name = 'sicilian pizza'
        LIMIT 1
    ),
    
    -- Дата заказа (из условия задания)
    '2022-02-24'
);

-- ДЕТАЛЬНЫЙ РАЗБОР ПОДЗАПРОСОВ:

-- ============================================================================
-- ПОДЗАПРОС 1: Вычисление ID заказа
-- ============================================================================
-- (SELECT MAX(id) + 1 FROM person_order)
--
-- Находит максимальный существующий ID в person_order и добавляет 1
-- Пример: если MAX(id) = 20, то новый ID = 21

-- ============================================================================
-- ПОДЗАПРОС 2: Получение ID Denis
-- ============================================================================
-- (SELECT id FROM person WHERE name = 'Denis')
--
-- Находит ID Denis в таблице person
-- Результат: 4 (из model.sql)

-- ============================================================================
-- ПОДЗАПРОС 3: Получение ID sicilian pizza (КРИТИЧЕСКИ ВАЖЕН LIMIT 1!)
-- ============================================================================
-- (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1)
--
-- ПОЧЕМУ НУЖЕН LIMIT 1:
-- 
-- Проблема: Может быть НЕСКОЛЬКО пицц с названием 'sicilian pizza'!
-- Например:
-- - sicilian pizza в Dominos (id=20, pizzeria_id=2)
-- - sicilian pizza в Pizza Hut (id=30, pizzeria_id=1) ← если добавили позже
-- - sicilian pizza в Best Pizza (id=40, pizzeria_id=5)
--
-- БЕЗ LIMIT 1:
-- SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'
-- → Может вернуть: {20, 30, 40} (несколько значений!)
-- → INSERT ожидает ОДНО значение
-- → ❌ ERROR: more than one row returned by a subquery used as an expression
--
-- С LIMIT 1:
-- SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1
-- → Возвращает: 20 (первая найденная)
-- → ✅ INSERT работает корректно
--
-- АЛЬТЕРНАТИВЫ (более точные):
-- 
-- A) Фильтр по пиццерии (если знаем, откуда заказываем):
-- SELECT id FROM menu 
-- WHERE pizza_name = 'sicilian pizza' 
--   AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos')
-- 
-- B) Фильтр по цене (если уникальна):
-- SELECT id FROM menu 
-- WHERE pizza_name = 'sicilian pizza' AND price = 900
-- 
-- Но в нашем задании используется LIMIT 1 (берёт первую попавшуюся)

-- ВЫЧИСЛЕННЫЕ ЗНАЧЕНИЯ:
-- ┌─────────────────────────────┬───────────┐
-- │ Подзапрос                   │ Результат │
-- ├─────────────────────────────┼───────────┤
-- │ MAX(id)+1 FROM person_order │ 21        │
-- │ id WHERE name='Denis'       │ 4         │
-- │ id WHERE pizza='sicilian..' │ 20        │
-- │ order_date (из задания)     │ 2022-02-24│
-- └─────────────────────────────┴───────────┘
--
-- Эквивалентный INSERT после вычисления:
-- INSERT INTO person_order VALUES (21, 4, 20, '2022-02-24');

-- ============================================================================
-- ШАГ 3: Вставка заказа от Irina
-- ============================================================================

INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES (
    -- Подзапрос 1: Автоматический ID (выполняется ЗАНОВО!)
    (
        SELECT MAX(id) + 1
        FROM person_order
    ),
    
    -- Подзапрос 2: ID Irina
    (
        SELECT id
        FROM person
        WHERE name = 'Irina'
    ),
    
    -- Подзапрос 3: ID sicilian pizza
    (
        SELECT id
        FROM menu
        WHERE pizza_name = 'sicilian pizza'
        LIMIT 1
    ),
    
    -- Дата заказа
    '2022-02-24'
);

-- РАЗБОР:
-- Логика идентична INSERT для Denis, только меняется person_id

-- ПОДЗАПРОС 2: (SELECT id FROM person WHERE name = 'Irina')
-- Результат: 6 (из model.sql)

-- ВАЖНАЯ ДЕТАЛЬ:
-- (SELECT MAX(id) + 1 FROM person_order) выполняется ЗАНОВО!
-- После первого INSERT MAX(id) стал = 21
-- Поэтому второй INSERT получит MAX(id) + 1 = 21 + 1 = 22

-- ПОСЛЕДОВАТЕЛЬНОСТЬ ВЫПОЛНЕНИЯ ID:
-- 
-- До первого INSERT:
-- MAX(id) в person_order = 20
-- 
-- Первый INSERT (Denis):
-- SELECT MAX(id)+1 → 20+1 = 21
-- INSERT VALUES (21, 4, 20, '2022-02-24')
-- 
-- После первого INSERT:
-- MAX(id) в person_order = 21 ← ИЗМЕНИЛОСЬ!
-- 
-- Второй INSERT (Irina):
-- SELECT MAX(id)+1 → 21+1 = 22 ← НОВОЕ ЗНАЧЕНИЕ!
-- INSERT VALUES (22, 6, 20, '2022-02-24')

-- ВЫЧИСЛЕННЫЕ ЗНАЧЕНИЯ ДЛЯ ВТОРОГО INSERT:
-- ┌─────────────────────────────┬───────────┐
-- │ Подзапрос                   │ Результат │
-- ├─────────────────────────────┼───────────┤
-- │ MAX(id)+1 FROM person_order │ 22        │ ← Увеличился!
-- │ id WHERE name='Irina'       │ 6         │
-- │ id WHERE pizza='sicilian..' │ 20        │
-- │ order_date                  │ 2022-02-24│
-- └─────────────────────────────┴───────────┘

-- ВИЗУАЛИЗАЦИЯ РЕЗУЛЬТАТА:
-- person_order (новые записи)
-- ┌────┬───────────┬─────────┬────────────┐
-- │ id │ person_id │ menu_id │ order_date │
-- ├────┼───────────┼─────────┼────────────┤
-- │ 20 │ 9         │ 6       │ 2022-01-10 │ ← Старые записи
-- │ 21 │ 4         │ 20      │ 2022-02-24 │ ← Denis → sicilian (НОВАЯ)
-- │ 22 │ 6         │ 20      │ 2022-02-24 │ ← Irina → sicilian (НОВАЯ)
-- └────┴───────────┴─────────┴────────────┘
--        ↑           ↑
--     Denis      sicilian pizza
--     (id=4)     из Dominos (id=20)

-- ============================================================================
-- ШАГ 4: Проверка корректности вставки
-- ============================================================================

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

-- НАЗНАЧЕНИЕ ПРОВЕРКИ:
-- Убедиться, что созданы РОВНО ДВА заказа:
-- 1. Denis заказал sicilian pizza 24.02.2022
-- 2. Irina заказала sicilian pizza 24.02.2022

-- ЛОГИКА:
-- COUNT(*) подсчитывает количество заказов, соответствующих условиям
-- = 2 создаёт булево значение:
--   - TRUE (t) если найдено ровно 2 заказа ✅
--   - FALSE (f) если найдено 0, 1, 3+ заказов ❌

-- ФИЛЬТРЫ WHERE:
-- 1. order_date = '2022-02-24'    → Только эта дата
-- 2. person_id IN (4, 6)          → Только Denis и Irina
-- 3. menu_id IN (20, ...)         → Только sicilian pizza

-- ВОЗМОЖНЫЕ РЕЗУЛЬТАТЫ:
-- ┌──────────────────────────┬────────────────────────────┐
-- │ sicilian_orders_created  │ Интерпретация              │
-- ├──────────────────────────┼────────────────────────────┤
-- │ t (TRUE)                 │ ✅ Оба заказа созданы      │
-- │ f (FALSE)                │ ❌ Проблема:               │
-- │                          │    0 записей: INSERT не    │
-- │                          │              сработали     │
-- │                          │    1 запись: создан только │
-- │                          │             один INSERT    │
-- │                          │    3+ записей: дубликаты   │
-- └──────────────────────────┴────────────────────────────┘

-- ОЖИДАЕМЫЙ РЕЗУЛЬТАТ:
-- ┌──────────────────────────┐
-- │ sicilian_orders_created  │
-- ├──────────────────────────┤
-- │ t                        │
-- └──────────────────────────┘

-- ============================================================================
-- ТЕХНИЧЕСКИЕ ДЕТАЛИ ДЛЯ ЗАЩИТЫ:
-- ============================================================================

-- 1. ПОЧЕМУ ДВА ОТДЕЛЬНЫХ INSERT:
--    Каждый INSERT создаёт одну строку с уникальным ID
--    
--    Нельзя сделать один INSERT с VALUES для двух строк:
--    ❌ INSERT ... VALUES 
--       ((SELECT MAX(id)+1 ...), 4, 20, '2022-02-24'),
--       ((SELECT MAX(id)+1 ...), 6, 20, '2022-02-24');
--    
--    Проблема: Оба подзапроса MAX(id)+1 выполнятся ОДНОВРЕМЕННО,
--    получат ОДИНАКОВОЕ значение → ошибка PRIMARY KEY!
--    
--    Правильно: Два последовательных INSERT
--    ✅ INSERT #1: id=21 (Denis)
--    ✅ INSERT #2: id=22 (Irina) ← MAX(id) уже изменился!

-- 2. КРИТИЧЕСКАЯ ВАЖНОСТЬ LIMIT 1:
--    
--    БЕЗ LIMIT 1:
--    SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'
--    
--    Если несколько пицц с таким названием:
--    ┌────┬─────────────┬─────────────────┐
--    │ id │ pizzeria_id │ pizza_name      │
--    ├────┼─────────────┼─────────────────┤
--    │ 20 │ 2           │ sicilian pizza  │ ← Dominos
--    │ 30 │ 1           │ sicilian pizza  │ ← Pizza Hut
--    └────┴─────────────┴─────────────────┘
--    
--    Подзапрос вернёт: {20, 30} (два значения!)
--    INSERT ожидает: ОДНО значение
--    → ❌ ERROR: more than one row returned by a subquery
--    
--    С LIMIT 1:
--    Подзапрос вернёт: 20 (первое значение)
--    → ✅ INSERT работает
--    
--    АЛЬТЕРНАТИВА (более точная):
--    SELECT id FROM menu 
--    WHERE pizza_name = 'sicilian pizza'
--      AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos')
--    
--    Но LIMIT 1 проще и работает для задания

-- 3. СВЯЗЬ МЕЖДУ ТАБЛИЦАМИ (FOREIGN KEY):
--    
--    person_order имеет FOREIGN KEY constraints:
--    - fk_order_person_id: person_id → person(id)
--    - fk_order_menu_id: menu_id → menu(id)
--    
--    PostgreSQL автоматически проверяет:
--    ✅ person_id=4 существует в person? ДА (Denis)
--    ✅ person_id=6 существует в person? ДА (Irina)
--    ✅ menu_id=20 существует в menu? ДА (sicilian pizza из задания 08)
--    
--    Если бы menu_id=20 не существовал:
--    ❌ ERROR: insert or update violates foreign key constraint
--           "fk_order_menu_id"

-- 4. ЦЕПОЧКА ЗАВИСИМОСТЕЙ МЕЖДУ ЗАДАНИЯМИ:
--    
--    Задание 08: INSERT sicilian pizza
--    ┌────┬─────────────┬─────────────────┬───────┐
--    │ 20 │ 2           │ sicilian pizza  │ 900   │
--    └────┴─────────────┴─────────────────┴───────┘
--         ↓
--    Задание 10: INSERT заказы (ссылаются на menu.id=20)
--    ┌────┬───────────┬─────────┬────────────┐
--    │ 21 │ 4         │ 20 ─────→ (sicilian) │
--    │ 22 │ 6         │ 20 ─────→ (sicilian) │
--    └────┴───────────┴─────────┴────────────┘
--    
--    Если бы не было задания 08:
--    menu_id=20 не существует → ❌ FOREIGN KEY ERROR

-- 5. ИДЕМПОТЕНТНОСТЬ:
--    
--    Сценарий многократного запуска:
--    
--    1-й запуск:
--      DELETE ... → 0 строк (заказов нет)
--      INSERT Denis → id=21
--      INSERT Irina → id=22
--      SELECT ... → sicilian_orders_created = t
--    
--    2-й запуск:
--      DELETE ... → 2 строки (удалили id=21,22)
--      INSERT Denis → id=21 (или другой, если MAX изменился)
--      INSERT Irina → id=22 (или другой)
--      SELECT ... → sicilian_orders_created = t
--    
--    Результат одинаковый: 2 заказа созданы

-- 6. ПОЧЕМУ ДАТА ЗАХАРДКОЖЕНА:
--    '2022-02-24' - это условие задания
--    
--    Задание говорит: "заказы 24 февраля 2022"
--    Поэтому дату можно и нужно хардкодить
--    
--    ✅ Допустимо хардкодить в этом задании:
--    - Дату заказа (из условия)
--    - Название пиццы (из условия)
--    
--    ❌ Нельзя хардкодить:
--    - ID заказа (вычисляется через MAX)
--    - person_id (ищется по имени)
--    - menu_id (ищется по названию пиццы)

-- 7. АЛЬТЕРНАТИВНЫЕ ПОДХОДЫ К ПОДЗАПРОСУ menu_id:
--    
--    -- Вариант A: С LIMIT 1 (используется в задании)
--    SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1
--    → Берёт первую попавшуюся
--    
--    -- Вариант B: С фильтром по пиццерии (более точно)
--    SELECT id FROM menu 
--    WHERE pizza_name = 'sicilian pizza'
--      AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos')
--    → Берёт только из Dominos
--    
--    -- Вариант C: С фильтром по цене
--    SELECT id FROM menu 
--    WHERE pizza_name = 'sicilian pizza' AND price = 900
--    → Берёт с ценой 900₽
--    
--    Все варианты правильные, но LIMIT 1 проще

-- 8. EDGE CASES (Граничные случаи):
--    
--    A) Если sicilian pizza не существует:
--       SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1
--       → Возвращает: NULL
--       INSERT ... VALUES (..., ..., NULL, ...)
--       → ❌ ERROR: null value violates not-null constraint
--    
--    B) Если Denis или Irina не существуют:
--       SELECT id FROM person WHERE name = 'Denis'
--       → Возвращает: NULL
--       INSERT ... VALUES (..., NULL, ..., ...)
--       → ❌ ERROR: null value violates not-null constraint
--    
--    В нашей базе все записи гарантированно существуют

-- 9. ПРОИЗВОДИТЕЛЬНОСТЬ:
--    Каждый INSERT выполняет 3 подзапроса:
--    - SELECT MAX(id)+1 FROM person_order  (полное сканирование)
--    - SELECT id FROM person WHERE name=... (индексированный поиск)
--    - SELECT id FROM menu WHERE pizza=...  (сканирование + LIMIT 1)
--    
--    Для двух INSERT это приемлемо
--    Для массовой вставки лучше использовать generate_series (задание 12)

-- 10. СВЯЗЬ С ЗАДАНИЕМ 13:
--     В задании 13 мы будем ОТКАТЫВАТЬ эти изменения:
--     - Удалим эти заказы (id=21,22)
--     - Удалим sicilian pizza из меню
--     
--     Порядок удаления будет обратный созданию:
--     1. Сначала person_order (зависимые данные)
--     2. Потом menu (главная таблица)

-- ============================================================================
-- ВИЗУАЛИЗАЦИЯ ПОЛНОГО ПОТОКА:
-- ============================================================================
/*
1. DELETE person_order
   ┌──────────────────────────────┐
   │ person_order                 │
   ├────┬──────────┬──────────────┤
   │ 21 │ Denis    │ sicilian     │ (если были)
   │ 22 │ Irina    │ sicilian     │ (если были)
   └────┴──────────┴──────────────┘
          ↓ DELETE
   ┌──────────────────────────────┐
   │ [пусто]                      │
   └──────────────────────────────┘

2. INSERT #1 (Denis)
   Вычисляем:
   - id = MAX(20) + 1 = 21
   - person_id = 4 (Denis)
   - menu_id = 20 (sicilian pizza)
   
   ┌────┬───────────┬─────────┬────────────┐
   │ 21 │ 4         │ 20      │ 2022-02-24 │ ← НОВАЯ
   └────┴───────────┴─────────┴────────────┘

3. INSERT #2 (Irina)
   Вычисляем:
   - id = MAX(21) + 1 = 22  ← Увеличилось!
   - person_id = 6 (Irina)
   - menu_id = 20 (sicilian pizza)
   
   ┌────┬───────────┬─────────┬────────────┐
   │ 21 │ 4         │ 20      │ 2022-02-24 │
   │ 22 │ 6         │ 20      │ 2022-02-24 │ ← НОВАЯ
   └────┴───────────┴─────────┴────────────┘

4. SELECT (проверка)
   COUNT(*) WHERE ... = 2
   
   ┌──────────────────────────┐
   │ sicilian_orders_created  │
   ├──────────────────────────┤
   │ t                        │ ✅ Успех!
   └──────────────────────────┘
*/

-- ============================================================================
```

---

## 📋 Краткая версия (минималистичная)

```sql
-- ============================================================================
-- Day 03 Exercise 10: Регистрация заказов Denis и Irina на sicilian pizza
-- ============================================================================

-- Шаг 1: Удаляем старые заказы (идемпотентность)
DELETE FROM person_order
WHERE order_date = '2022-02-24'
  AND person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
  AND menu_id IN (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza');

-- Шаг 2: Добавляем заказ Denis
INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES (
    (SELECT MAX(id) + 1 FROM person_order),
    (SELECT id FROM person WHERE name = 'Denis'),
    (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1), -- LIMIT 1 критичен!
    '2022-02-24'
);

-- Шаг 3: Добавляем заказ Irina
INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES (
    (SELECT MAX(id) + 1 FROM person_order),  -- MAX изменился после 1-го INSERT!
    (SELECT id FROM person WHERE name = 'Irina'),
    (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1),
    '2022-02-24'
);

-- Шаг 4: Проверяем, что созданы ровно 2 заказа
SELECT COUNT(*) = 2 AS sicilian_orders_created
FROM person_order
WHERE order_date = '2022-02-24'
  AND person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
  AND menu_id IN (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza');
-- Ожидаемый результат: sicilian_orders_created = t

-- ============================================================================
-- КРИТИЧЕСКИ ВАЖНО:
-- - LIMIT 1 в подзапросе menu_id! Без него может вернуться несколько строк → ERROR
-- - Два отдельных INSERT для уникальных ID (MAX вычисляется заново)
-- - Заказы ссылаются на sicilian pizza из задания 08 (menu.id=20)
-- ============================================================================
```

---

## 🎓 Комментарий для УСТНОЙ защиты

```markdown
## Объяснение скрипта для защиты

**Задача:**
Зарегистрировать заказы от Denis и Irina на новое блюдо "sicilian pizza" 24 февраля 2022.

**Контекст:**
Это продолжение цепочки заданий:
- Задание 08: Добавили sicilian pizza в меню Dominos (menu.id=20)
- Задание 09: Зафиксировали посещения Denis и Irina в Dominos
- Задание 10: Регистрируем заказы на sicilian pizza

**Структура скрипта (4 шага):**

### **Шаг 1: DELETE (идемпотентность)**
```sql
DELETE FROM person_order
WHERE order_date = '2022-02-24'
  AND person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
  AND menu_id IN (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza');
```

**Зачем три условия:**
1. order_date: только эта дата
2. person_id IN: только Denis и Irina
3. menu_id IN: только sicilian pizza

### **Шаг 2: INSERT для Denis**
```sql
INSERT INTO person_order VALUES (
    (SELECT MAX(id) + 1 FROM person_order),
    (SELECT id FROM person WHERE name = 'Denis'),
    (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1),
    '2022-02-24'
);
```

**КРИТИЧЕСКИ ВАЖНО: LIMIT 1**

Почему нужен LIMIT 1:
- Может быть несколько пицц с названием 'sicilian pizza' в разных пиццериях
- Подзапрос без LIMIT 1 может вернуть НЕСКОЛЬКО значений: {20, 30, 40}
- INSERT ожидает ОДНО значение
- Без LIMIT 1: ERROR "more than one row returned by a subquery"

С LIMIT 1:
- Подзапрос вернёт только первое значение: 20
- INSERT работает корректно

Альтернатива (более точная):
```sql
SELECT id FROM menu 
WHERE pizza_name = 'sicilian pizza'
  AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos')
```
Но LIMIT 1 проще и работает для задания.

### **Шаг 3: INSERT для Irina**
```sql
INSERT INTO person_order VALUES (
    (SELECT MAX(id) + 1 FROM person_order),  ← Выполняется ЗАНОВО!
    (SELECT id FROM person WHERE name = 'Irina'),
    (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza' LIMIT 1),
    '2022-02-24'
);
```

**ВАЖНО: MAX(id) вычисляется заново!**
- После 1-го INSERT: MAX(id) стал = 21
- Во 2-м INSERT: MAX(id)+1 = 22 (новое значение!)

### **Почему два отдельных INSERT?**

Нельзя сделать один INSERT с VALUES для двух строк:
```sql
❌ INSERT VALUES
   ((SELECT MAX(id)+1 ...), 4, 20, '2022-02-24'),
   ((SELECT MAX(id)+1 ...), 6, 20, '2022-02-24');
```

Проблема: Оба подзапроса MAX(id)+1 выполнятся ОДНОВРЕМЕННО,
получат ОДИНАКОВОЕ значение → ошибка PRIMARY KEY!

Правильно: Два последовательных INSERT.

### **Шаг 4: SELECT (проверка)**
```sql
SELECT COUNT(*) = 2 AS sicilian_orders_created
FROM person_order
WHERE ...;
```

Проверяем, что созданы ровно 2 заказа.

**Ожидаемый результат:**
```
sicilian_orders_created = t (TRUE)
```

### **Важные детали:**

**1. FOREIGN KEY constraints:**
PostgreSQL автоматически проверяет:
- person_id=4,6 существуют в person? ✅
- menu_id=20 существует в menu? ✅ (из задания 08)

**2. Связь между заданиями:**
Заказы ссылаются на menu.id=20 (sicilian pizza из задания 08)
Без задания 08 этот скрипт упадёт с FOREIGN KEY error.

**3. Идемпотентность:**
Скрипт можно запускать многократно — результат одинаковый.
```

---

**Используй любой вариант комментария для защиты!** 🎯  
Рекомендую **подробный вариант** — он объясняет критическую важность LIMIT 1 и связь между заданиями.