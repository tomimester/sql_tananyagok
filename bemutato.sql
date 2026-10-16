-------------------
-- ALAPLEKÉRÉSEK --
-------------------

-- Az összes adat lekérése a zoo táblából
SELECT * FROM zoo;

-- Csak az állat neve és vízigényeinek lekérése
SELECT animal, water_need FROM zoo;

-- Az összes adat lekérése a zoo táblából, de csak az első 10 sor
SELECT * FROM zoo LIMIT 10;

-- Csak az 'elephant' sorok lekérése
SELECT * FROM zoo WHERE animal = 'elephant';

------------------------
-- RELÁCIÓS MŰVELETEK --
------------------------
-- Az összes állat lekérése, amelyek NEM 'elephant'
SELECT * FROM zoo WHERE animal != 'elephant';

-- Az összes állat lekérése, amelyek vízigénye nagyobb, mint 500
SELECT * FROM zoo WHERE water_need > 500;

-- Az összes állat lekérése, amelyek nevében szerepel az 'e' betű
SELECT * FROM zoo WHERE animal LIKE '%e%';

-- Az összes állat lekérése, amelyek nevében szerepel az 'e' betű, függetlenül a kis- és nagybetűktől
SELECT * FROM zoo WHERE animal ILIKE '%e%';

--------------------------
-- TÖBB SZŰRŐ EGYSZERRE --
--------------------------
-- Az összes 'tiger' állat lekérése, amelyek vízigénye kisebb, mint 320
SELECT
  *
FROM
  zoo
WHERE
  water_need < 320
  AND
  animal = 'tiger';

-- Az összes állat lekérése, amelyek vízigénye kisebb, mint 320 VAGY az állat neve 'tiger'
SELECT
  *
FROM
  zoo
WHERE
  water_need < 320
  OR
  animal = 'tiger';

--------------------------
-- AGGREGÁLÓ FÜGGVÉNYEK --
--------------------------
-- Az összes sor megszámlálása a zoo táblában
SELECT COUNT(*) FROM zoo;

-- Az összes állat vízigényének összege a zoo táblában
SELECT SUM(water_need) FROM zoo;

-- Az összes állat vízigényének átlagos értéke a zoo táblában
SELECT AVG(water_need) FROM zoo;

-- Az összes állat vízigényének minimum értéke a zoo táblában
SELECT MIN(water_need) FROM zoo;

-- Az összes állat vízigényének maximum értéke a zoo táblában
SELECT MAX(water_need) FROM zoo;

-- Az összes állat vízigényének minimum és maximum értéke a zoo táblában
SELECT MIN(water_need), MAX(water_need) FROM zoo;   

-- Az összes egyedi állat a zoo táblában
SELECT DISTINCT(animal) FROM zoo;

-- Az összes egyedi állat megszámlálása a zoo táblában
SELECT COUNT(DISTINCT(animal)) FROM zoo; 

--------------
-- RENDEZÉS --
--------------
-- Az összes állat lekérése a zoo táblából, vízigény szerint növekvő sorrendben
SELECT * FROM zoo ORDER BY water_need ASC;

-- Az összes állat lekérése a zoo táblából, vízigény szerint csökkenő sorrendben
SELECT * FROM zoo ORDER BY water_need DESC;

--------------
-- GROUP BY --
--------------
-- Az állatok száma állatonként
SELECT animal, COUNT(*) FROM zoo GROUP BY animal;   

-- Az állatok vízigényének összege állatonként
SELECT animal, SUM(water_need) FROM zoo GROUP BY animal;

-- Az állatok vízigényének átlagos értéke állatonként
SELECT animal, AVG(water_need) FROM zoo GROUP BY animal;

-- Az állatok vízigényének minimum és maximum értéke állatonként
SELECT
  animal,
  MIN(water_need),
  MAX(water_need)
FROM
  zoo
GROUP BY
  animal;

----------
-- JOIN --
----------
-- A zoo és zoo_food táblák összekapcsolása az animal oszlop alapján
SELECT
  *
FROM
  zoo
JOIN
  zoo_food
ON
  zoo.animal = zoo_food.animal;

-- A zoo és zoo_food táblák összekapcsolása az animal oszlop alapján
-- csak a vízigény, az állat és a szükséges élelem mennyiségének lekérése
SELECT
  zoo.animal, -- FONTOS! Ha nem adjuk meg a táblanevet, akkor a lekérdezés hibát fog dobni, mert mindkét táblában van egy 'animal' oszlop.
  zoo.water_need, -- Érdemes megadni a táblanevet, hogy egyértelmű legyen, honnan származik az adat.
  zoo_food.food_amount
FROM
  zoo
JOIN
  zoo_food
ON
  zoo.animal = zoo_food.animal;

----------------------------
-- FULL, LEFT, RIGHT JOIN --
----------------------------
-- A zoo és zoo_food táblák összekapcsolása az animal oszlop alapján
-- de csak a zoo táblában szereplő állatok lekérése
SELECT
  *
FROM
  zoo
LEFT JOIN
  zoo_food
ON
  zoo.animal = zoo_food.animal;

-- A zoo és zoo_food táblák összekapcsolása az animal oszlop alapján
-- de csak a zoo_food táblában szereplő állatok lekérése
SELECT
  *
FROM
  zoo
RIGHT JOIN
  zoo_food
ON
  zoo.animal = zoo_food.animal; 

-- A zoo és zoo_food táblák összekapcsolása az animal oszlop alapján
-- minden állat lekérése, függetlenül attól, hogy melyik táblában szerepel
SELECT
  *
FROM
  zoo
FULL JOIN
  zoo_food
ON
  zoo.animal = zoo_food.animal;

----------------
-- SUBQUERIES --
----------------
-- Az összes egyedi állat száma a zoo táblában
SELECT COUNT(*) FROM (
    SELECT
      COUNT(*),
      animal
    FROM
      zoo
    GROUP BY
      animal) AS allatok_szama;