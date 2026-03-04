DELETE FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND pizzeria_id = (
      SELECT id
      FROM pizzeria
      WHERE name = 'Dominos'
  );





INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    (
        SELECT MAX(id) + 1
        FROM person_visits
    ),
    (
        SELECT id
        FROM person
        WHERE name = 'Denis'
    ),
    (
        SELECT id
        FROM pizzeria
        WHERE name = 'Dominos'
    ),
    '2022-02-24'
);

INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    (
        SELECT MAX(id) + 1
        FROM person_visits
    ),
    (
        SELECT id
        FROM person
        WHERE name = 'Irina'
    ),
    (
        SELECT id
        FROM pizzeria
        WHERE name = 'Dominos'
    ),
    '2022-02-24'
);







SELECT COUNT(*) = 2 AS new_visits_created
FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND pizzeria_id = (
      SELECT id
      FROM pizzeria
      WHERE name = 'Dominos'
  );






# 📝 SQL Комментарий для Задания 09


-- ============================================================================
-- SQL Bootcamp Day 03 — Exercise 09
-- ============================================================================
-- Задание: Зафиксировать посещения ресторана Dominos Денисом и Ириной
--          24 февраля 2022 года
-- Требование: НЕ использовать прямые числовые значения для ID и pizzeria_id
-- ============================================================================

-- ОПИСАНИЕ ПОДХОДА:
-- 1. DELETE: Удаляем старые посещения Denis и Irina в Dominos (если есть)
-- 2. INSERT #1: Добавляем посещение Denis
-- 3. INSERT #2: Добавляем посещение Irina
-- 4. SELECT: Проверяем, что создано ровно 2 записи
--
-- КОНТЕКСТ:
-- Это продолжение заданий 07 и 08:
-- - Задание 07: Добавили greek pizza
-- - Задание 08: Добавили sicilian pizza в Dominos
-- - Задание 09: Фиксируем, что Denis и Irina посетили Dominos (→ МЫ ЗДЕСЬ)
-- - Задание 10: Denis и Irina закажут sicilian pizza

-- ============================================================================
-- ШАГ 1: Удаление существующих посещений (для идемпотентности)
-- ============================================================================

DELETE FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (
      -- Подзапрос: находим ID Denis и Irina
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND pizzeria_id = (
      -- Подзапрос: находим ID пиццерии Dominos
      SELECT id
      FROM pizzeria
      WHERE name = 'Dominos'
  );

-- ЗАЧЕМ ЭТОТ DELETE:
-- Делает скрипт идемпотентным - можно запускать многократно
-- - При первом запуске: удалит 0 строк (посещений ещё нет)
-- - При повторном запуске: удалит 2 строки (предыдущие посещения)
-- - Освобождает место для новых INSERT

-- ЛОГИКА ПОДЗАПРОСОВ:
-- 1. WHERE name IN ('Denis', 'Irina')
--    → Возвращает ID: {4, 6}  (Denis=4, Irina=6)
--
-- 2. WHERE name = 'Dominos'
--    → Возвращает ID: 2
--
-- 3. DELETE удаляет записи где:
--    - visit_date = '2022-02-24'
--    - person_id IN (4, 6)
--    - pizzeria_id = 2

-- ПОЧЕМУ ТРИ УСЛОВИЯ:
-- 1. visit_date: Удаляем только посещения 24 февраля
--    (могут быть другие посещения Denis и Irina в Dominos)
-- 2. person_id IN: Только Denis и Irina (не других людей)
-- 3. pizzeria_id: Только Dominos (не другие пиццерии)

-- ============================================================================
-- ШАГ 2: Вставка посещения для Denis
-- ============================================================================

INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    -- Подзапрос 1: Автоматический ID
    (
        SELECT MAX(id) + 1
        FROM person_visits
    ),
    
    -- Подзапрос 2: ID Denis
    (
        SELECT id
        FROM person
        WHERE name = 'Denis'
    ),
    
    -- Подзапрос 3: ID Dominos
    (
        SELECT id
        FROM pizzeria
        WHERE name = 'Dominos'
    ),
    
    -- Дата посещения (из условия задания)
    '2022-02-24'
);

-- РАЗБОР ПОДЗАПРОСОВ:

-- ПОДЗАПРОС 1: (SELECT MAX(id) + 1 FROM person_visits)
-- Вычисляет следующий свободный ID
-- Пример: если MAX(id) = 19, то новый ID = 20

-- ПОДЗАПРОС 2: (SELECT id FROM person WHERE name = 'Denis')
-- Находит ID Denis в таблице person
-- Результат: 4 (из model.sql: Denis имеет id=4)

-- ПОДЗАПРОС 3: (SELECT id FROM pizzeria WHERE name = 'Dominos')
-- Находит ID Dominos
-- Результат: 2 (из model.sql: Dominos имеет id=2)

-- ВИЗУАЛИЗАЦИЯ:
-- Вычисленные значения:
-- ┌─────────────────────────────┬───────────┐
-- │ Подзапрос                   │ Результат │
-- ├─────────────────────────────┼───────────┤
-- │ MAX(id)+1                   │ 20        │
-- │ id WHERE name='Denis'       │ 4         │
-- │ id WHERE name='Dominos'     │ 2         │
-- │ visit_date (из задания)     │ 2022-02-24│
-- └─────────────────────────────┴───────────┘
--
-- Эквивалентный INSERT:
-- INSERT INTO person_visits VALUES (20, 4, 2, '2022-02-24');

-- ============================================================================
-- ШАГ 3: Вставка посещения для Irina
-- ============================================================================

INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    -- Подзапрос 1: Автоматический ID
    (
        SELECT MAX(id) + 1
        FROM person_visits
    ),
    
    -- Подзапрос 2: ID Irina
    (
        SELECT id
        FROM person
        WHERE name = 'Irina'
    ),
    
    -- Подзапрос 3: ID Dominos
    (
        SELECT id
        FROM pizzeria
        WHERE name = 'Dominos'
    ),
    
    -- Дата посещения (из условия задания)
    '2022-02-24'
);

-- РАЗБОР:
-- Логика идентична INSERT для Denis, только меняется person_id

-- ПОДЗАПРОС 2: (SELECT id FROM person WHERE name = 'Irina')
-- Находит ID Irina
-- Результат: 6 (из model.sql: Irina имеет id=6)

-- ВАЖНАЯ ДЕТАЛЬ:
-- (SELECT MAX(id) + 1 FROM person_visits) будет выполнен ЗАНОВО
-- После первого INSERT MAX(id) стал = 20
-- Поэтому второй INSERT получит MAX(id) + 1 = 20 + 1 = 21

-- Вычисленные значения для второго INSERT:
-- ┌─────────────────────────────┬───────────┐
-- │ Подзапрос                   │ Результат │
-- ├─────────────────────────────┼───────────┤
-- │ MAX(id)+1                   │ 21        │ ← Увеличился!
-- │ id WHERE name='Irina'       │ 6         │
-- │ id WHERE name='Dominos'     │ 2         │
-- │ visit_date                  │ 2022-02-24│
-- └─────────────────────────────┴───────────┘
--
-- Эквивалентный INSERT:
-- INSERT INTO person_visits VALUES (21, 6, 2, '2022-02-24');

-- ВИЗУАЛИЗАЦИЯ РЕЗУЛЬТАТА:
-- person_visits (новые записи)
-- ┌────┬───────────┬─────────────┬────────────┐
-- │ id │ person_id │ pizzeria_id │ visit_date │
-- ├────┼───────────┼─────────────┼────────────┤
-- │ 19 │ 9         │ 6           │ 2022-01-10 │ ← Старые записи
-- │ 20 │ 4         │ 2           │ 2022-02-24 │ ← Denis в Dominos (НОВАЯ)
-- │ 21 │ 6         │ 2           │ 2022-02-24 │ ← Irina в Dominos (НОВАЯ)
-- └────┴───────────┴─────────────┴────────────┘
--              ↑         ↑
--           Denis     Dominos
--           (id=4)    (id=2)

-- ============================================================================
-- ШАГ 4: Проверка корректности вставки
-- ============================================================================

SELECT COUNT(*) = 2 AS new_visits_created
FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (
      SELECT id
      FROM person
      WHERE name IN ('Denis', 'Irina')
  )
  AND pizzeria_id = (
      SELECT id
      FROM pizzeria
      WHERE name = 'Dominos'
  );

-- НАЗНАЧЕНИЕ ПРОВЕРКИ:
-- Убедиться, что созданы РОВНО ДВЕ записи:
-- 1. Denis посетил Dominos 24.02.2022
-- 2. Irina посетила Dominos 24.02.2022

-- ЛОГИКА:
-- COUNT(*) подсчитывает количество посещений, соответствующих условиям
-- = 2 создаёт булево значение:
--   - TRUE (t) если найдено ровно 2 записи ✅
--   - FALSE (f) если найдено 0, 1, 3+ записей ❌

-- ФИЛЬТРЫ WHERE:
-- 1. visit_date = '2022-02-24'     → Только эта дата
-- 2. person_id IN (4, 6)           → Только Denis и Irina
-- 3. pizzeria_id = 2               → Только Dominos

-- ВОЗМОЖНЫЕ РЕЗУЛЬТАТЫ:
-- ┌──────────────────────┬──────────────────────────────┐
-- │ new_visits_created   │ Интерпретация                │
-- ├──────────────────────┼──────────────────────────────┤
-- │ t (TRUE)             │ ✅ Оба посещения созданы     │
-- │ f (FALSE)            │ ❌ Проблема:                 │
-- │                      │    0 записей: INSERT не      │
-- │                      │              сработали       │
-- │                      │    1 запись: создан только   │
-- │                      │             один INSERT      │
-- │                      │    3+ записей: дубликаты     │
-- └──────────────────────┴──────────────────────────────┘

-- ОЖИДАЕМЫЙ РЕЗУЛЬТАТ:
-- ┌──────────────────────┐
-- │ new_visits_created   │
-- ├──────────────────────┤
-- │ t                    │
-- └──────────────────────┘

-- ============================================================================
-- ТЕХНИЧЕСКИЕ ДЕТАЛИ ДЛЯ ЗАЩИТЫ:
-- ============================================================================

-- 1. ПОЧЕМУ ДВА ОТДЕЛЬНЫХ INSERT:
--    Каждый INSERT создаёт одну строку с уникальным ID
--    
--    Нельзя сделать один INSERT для двух человек:
--    ❌ INSERT ... VALUES (..., 4, ...), (..., 6, ...);
--    Потому что id вычисляется подзапросом - будет одинаковый!
--    
--    Правильно: Два отдельных INSERT
--    ✅ INSERT #1: id=20, person_id=4 (Denis)
--    ✅ INSERT #2: id=21, person_id=6 (Irina)

-- 2. ПОСЛЕДОВАТЕЛЬНОСТЬ ВЫПОЛНЕНИЯ ID:
--    
--    До первого INSERT:
--    MAX(id) в person_visits = 19
--    
--    Первый INSERT (Denis):
--    SELECT MAX(id)+1 → 19+1 = 20
--    INSERT ... VALUES (20, 4, 2, '2022-02-24')
--    
--    После первого INSERT:
--    MAX(id) в person_visits = 20 (изменилось!)
--    
--    Второй INSERT (Irina):
--    SELECT MAX(id)+1 → 20+1 = 21 (новое значение!)
--    INSERT ... VALUES (21, 6, 2, '2022-02-24')
--    
--    Результат: id=20 и id=21 (разные ID!)

-- 3. UNIQUE CONSTRAINT:
--    В таблице person_visits есть ограничение:
--    CONSTRAINT uk_person_visits UNIQUE (person_id, pizzeria_id, visit_date)
--    
--    Это значит: один человек не может посетить одну пиццерию
--    дважды в один день
--    
--    Проверка при INSERT:
--    - Denis (4) + Dominos (2) + 2022-02-24 → Уникально ✅
--    - Irina (6) + Dominos (2) + 2022-02-24 → Уникально ✅
--    
--    Если попытаться вставить третий раз:
--    - Denis (4) + Dominos (2) + 2022-02-24 → ❌ ERROR: duplicate key

-- 4. ИДЕМПОТЕНТНОСТЬ:
--    
--    Сценарий многократного запуска:
--    
--    1-й запуск:
--      DELETE ... → 0 строк
--      INSERT Denis → id=20
--      INSERT Irina → id=21
--      SELECT ... → new_visits_created = t
--    
--    2-й запуск:
--      DELETE ... → 2 строки (удалили id=20,21)
--      INSERT Denis → id=20 (или 22, если были другие вставки)
--      INSERT Irina → id=21 (или 23)
--      SELECT ... → new_visits_created = t
--    
--    Результат одинаковый: 2 посещения созданы

-- 5. ПОЧЕМУ ДАТА ЗАХАРДКОЖЕНА:
--    '2022-02-24' - это прямое значение из условия задания
--    
--    Задание говорит: "зафиксировать посещения 24 февраля 2022"
--    Поэтому дату можно (и нужно) хардкодить
--    
--    ✅ Допустимо хардкодить:
--    - Дату (из условия задания)
--    - Название пиццы (из условия)
--    - Цену (из условия)
--    - Имена людей (из условия)
--    
--    ❌ Нельзя хардкодить:
--    - ID (должны вычисляться)
--    - pizzeria_id (должен искаться)
--    - person_id (должен искаться)

-- 6. СВЯЗЬ С ДРУГИМИ ЗАДАНИЯМИ:
--    
--    Задание 08: INSERT sicilian pizza в Dominos (menu.id=20)
--    Задание 09: INSERT посещения Denis и Irina в Dominos  ← МЫ ЗДЕСЬ
--    Задание 10: INSERT заказы Denis и Irina на sicilian pizza
--                (будут ссылаться на:
--                 - person_visits.id из этого задания
--                 - menu.id=20 из задания 08)

-- 7. АЛЬТЕРНАТИВНЫЕ ПОДХОДЫ:
--    
--    -- Вариант A: Использовать generate_series (для задания 12)
--    -- Но для двух конкретных людей проще два INSERT
--    
--    -- Вариант B: VALUES с несколькими строками
--    -- НЕ РАБОТАЕТ из-за подзапроса MAX(id)+1:
--    ❌ INSERT INTO person_visits VALUES
--       ((SELECT MAX(id)+1 FROM person_visits), 4, 2, '2022-02-24'),
--       ((SELECT MAX(id)+1 FROM person_visits), 6, 2, '2022-02-24');
--       ↑ Оба получат ОДИНАКОВЫЙ id! Ошибка PRIMARY KEY!
--    
--    -- Вариант C: CTE для читаемости
--    WITH denis_id AS (SELECT id FROM person WHERE name='Denis'),
--         irina_id AS (SELECT id FROM person WHERE name='Irina'),
--         dominos_id AS (SELECT id FROM pizzeria WHERE name='Dominos')
--    INSERT INTO person_visits ...
--    
--    -- Но два отдельных INSERT проще и понятнее

-- 8. ПРОВЕРКА FOREIGN KEY:
--    
--    person_visits имеет два FOREIGN KEY:
--    - fk_person_visits_person_id: person_id → person(id)
--    - fk_person_visits_pizzeria_id: pizzeria_id → pizzeria(id)
--    
--    PostgreSQL автоматически проверяет:
--    ✅ person_id=4 существует в person? ДА (Denis)
--    ✅ person_id=6 существует в person? ДА (Irina)
--    ✅ pizzeria_id=2 существует в pizzeria? ДА (Dominos)
--    
--    Если бы указали несуществующий ID:
--    ❌ person_id=999 → ERROR: foreign key violation

-- 9. ПРОИЗВОДИТЕЛЬНОСТЬ:
--    Каждый INSERT выполняет 3 подзапроса:
--    - SELECT MAX(id)+1 FROM person_visits    (полное сканирование)
--    - SELECT id FROM person WHERE name=...   (индексированный поиск)
--    - SELECT id FROM pizzeria WHERE name=... (индексированный поиск)
--    
--    Для двух INSERT это приемлемо
--    Для массовой вставки (100+ записей) лучше использовать SEQUENCE

-- 10. EDGE CASES:
--     
--     A) Если Denis или Irina не существуют:
--        SELECT id FROM person WHERE name='Denis' → NULL
--        INSERT ... VALUES (..., NULL, ...) → ERROR: violates not-null
--        
--     B) Если Dominos не существует:
--        SELECT id FROM pizzeria WHERE name='Dominos' → NULL
--        INSERT ... VALUES (..., ..., NULL, ...) → ERROR: FK violation
--        
--     В нашей базе все эти записи гарантированно существуют

-- ============================================================================
-- ВИЗУАЛИЗАЦИЯ ПОЛНОГО ПОТОКА:
-- ============================================================================
/*
1. DELETE person_visits
   ┌───────────────────────────────┐
   │ person_visits                 │
   ├────┬──────────┬──────────────┤
   │ 20 │ Denis    │ 2022-02-24   │ (если были)
   │ 21 │ Irina    │ 2022-02-24   │ (если были)
   └────┴──────────┴──────────────┘
          ↓ DELETE
   ┌───────────────────────────────┐
   │ [пусто]                       │
   └───────────────────────────────┘

2. INSERT #1 (Denis)
   Вычисляем:
   - id = MAX(19) + 1 = 20
   - person_id = 4 (Denis)
   - pizzeria_id = 2 (Dominos)
   
   ┌────┬───────────┬─────────────┬────────────┐
   │ 20 │ 4         │ 2           │ 2022-02-24 │ ← НОВАЯ
   └────┴───────────┴─────────────┴────────────┘

3. INSERT #2 (Irina)
   Вычисляем:
   - id = MAX(20) + 1 = 21  ← Увеличилось!
   - person_id = 6 (Irina)
   - pizzeria_id = 2 (Dominos)
   
   ┌────┬───────────┬─────────────┬────────────┐
   │ 20 │ 4         │ 2           │ 2022-02-24 │
   │ 21 │ 6         │ 2           │ 2022-02-24 │ ← НОВАЯ
   └────┴───────────┴─────────────┴────────────┘

4. SELECT (проверка)
   COUNT(*) WHERE ... = 2
   
   ┌──────────────────────┐
   │ new_visits_created   │
   ├──────────────────────┤
   │ t                    │ ✅ Успех!
   └──────────────────────┘
*/

-- ============================================================================
```

---

## 📋 Краткая версия (минималистичная)

```sql
-- ============================================================================
-- Day 03 Exercise 09: Фиксация посещений Denis и Irina в Dominos
-- ============================================================================

-- Шаг 1: Удаляем старые посещения (идемпотентность)
DELETE FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
  AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos');

-- Шаг 2: Добавляем посещение Denis
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    (SELECT MAX(id) + 1 FROM person_visits),      -- Автоматический ID
    (SELECT id FROM person WHERE name = 'Denis'), -- ID Denis = 4
    (SELECT id FROM pizzeria WHERE name = 'Dominos'), -- ID Dominos = 2
    '2022-02-24'
);

-- Шаг 3: Добавляем посещение Irina
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    (SELECT MAX(id) + 1 FROM person_visits),      -- MAX изменился после 1-го INSERT
    (SELECT id FROM person WHERE name = 'Irina'), -- ID Irina = 6
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    '2022-02-24'
);

-- Шаг 4: Проверяем, что созданы ровно 2 записи
SELECT COUNT(*) = 2 AS new_visits_created
FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
  AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos');
-- Ожидаемый результат: new_visits_created = t

-- ============================================================================
-- ВАЖНО:
-- - Два отдельных INSERT нужны, чтобы каждый получил уникальный ID
-- - MAX(id)+1 вычисляется заново во втором INSERT (увеличивается)
-- - Дата '2022-02-24' захардкожена - это из условия задания
-- ============================================================================
```

---

## 🎓 Комментарий для УСТНОЙ защиты

```markdown
## Объяснение скрипта для защиты

**Задача:**
Зафиксировать посещения ресторана Dominos Денисом и Ириной 24 февраля 2022 года.

**Контекст:**
Это продолжение задания 08 — мы добавили sicilian pizza в Dominos,
теперь фиксируем, что Denis и Irina посетили этот ресторан.

**Структура скрипта (4 шага):**

### **Шаг 1: DELETE (идемпотентность)**
```sql
DELETE FROM person_visits
WHERE visit_date = '2022-02-24'
  AND person_id IN (SELECT id FROM person WHERE name IN ('Denis', 'Irina'))
  AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'Dominos');
```

**Зачем:**
Убрать старые записи перед вставкой новых — скрипт можно запускать многократно.

**Три условия:**
1. Только дата 24.02.2022
2. Только Denis и Irina
3. Только Dominos

### **Шаг 2: INSERT для Denis**
```sql
INSERT INTO person_visits VALUES (
    (SELECT MAX(id) + 1 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Denis'),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    '2022-02-24'
);
```

**Подзапросы:**
- MAX(id)+1: Вычисляет следующий свободный ID (например, 20)
- person.id для Denis: находит 4
- pizzeria.id для Dominos: находит 2

### **Шаг 3: INSERT для Irina**
```sql
INSERT INTO person_visits VALUES (
    (SELECT MAX(id) + 1 FROM person_visits),  ← Выполняется ЗАНОВО!
    (SELECT id FROM person WHERE name = 'Irina'),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    '2022-02-24'
);
```

**ВАЖНО:**
MAX(id)+1 вычисляется ЗАНОВО после первого INSERT!
- После 1-го INSERT: MAX(id) стал = 20
- Во 2-м INSERT: MAX(id)+1 = 21 (новое значение!)

### **Почему два отдельных INSERT?**

Нельзя сделать один INSERT с двумя строками:
```sql
❌ INSERT VALUES
   ((SELECT MAX(id)+1 ...), 4, ...),
   ((SELECT MAX(id)+1 ...), 6, ...);
```

Проблема: Оба подзапроса MAX(id)+1 выполнятся ОДНОВРЕМЕННО,
получат ОДИНАКОВОЕ значение → ошибка PRIMARY KEY!

Правильно: Два последовательных INSERT — каждый получит уникальный ID.

### **Шаг 4: SELECT (проверка)**
```sql
SELECT COUNT(*) = 2 AS new_visits_created
FROM person_visits
WHERE ...;
```

**Проверяем:**
- Созданы ровно 2 записи (не 0, не 1, не 3+)
- Denis посетил Dominos 24.02.2022
- Irina посетила Dominos 24.02.2022

**Ожидаемый результат:**
```
new_visits_created = t (TRUE)
```

### **Важные детали:**

**1. Дата захардкожена:**
'2022-02-24' — это из условия задания, хардкодить можно и нужно.

**2. UNIQUE constraint:**
В person_visits есть ограничение:
```sql
UNIQUE (person_id, pizzeria_id, visit_date)
```
Один человек не может дважды посетить одну пиццерию в один день.

**3. Последовательность ID:**
```
До INSERT: MAX(id) = 19
1-й INSERT: id = 20
После 1-го: MAX(id) = 20
2-й INSERT: id = 21
```

**4. Связь с другими заданиями:**
- Задание 08: Добавили sicilian pizza (menu.id=20)
- Задание 09: Добавили посещения (person_visits.id=20,21)
- Задание 10: Добавим заказы на sicilian pizza
```

---

**Используй любой вариант комментария для защиты!** 🎯  
Рекомендую **подробный вариант** — он объясняет, почему два INSERT и как работает MAX(id)+1 при повторном выполнении.