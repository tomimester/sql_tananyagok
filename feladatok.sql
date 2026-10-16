-------------------
-- ALAPLEKÉRÉSEK --
-------------------

-- Kérd le az egész ecom_visit táblát!
SELECT * FROM ecom_visit;

-- Kérd le az egész ecom_visit tábla első 10 sorát!
SELECT * FROM ecom_visit LIMIT 10;

-- Kérd le az ecom_visit táblából azokat a sorokat, ahol a channel 'Facebook'!
SELECT * FROM ecom_visit WHERE channel = 'Facebook';

-- Kérd le az ecom_visit táblából a datetime, visitor_id, channel oszlopokat, 
-- de csak azokat a sorokat, ahol a channel 'Facebook'!
SELECT
  datetime,
  visitor_id,
  channel
FROM
  ecom_visit
WHERE
  channel = 'Facebook';

-----------------------
-- EGYSZERŰ SZŰRÉSEK --
-----------------------

-- Kérd le azokat a sorokat, ahol a visitor ID kisebb, mint 100001000!
SELECT * FROM ecom_visit WHERE visitor_id < 100001000;

-- Kérd le azokat az értékekeket, ahol a channel nevében van "a" betű!
SELECT * FROM ecom_visit WHERE channel LIKE '%a%';

--------------
-- SZŰRÉSEK --
--------------

-- Kérd le az egész ecom_buy táblát!
SELECT * FROM ecom_buy;

-- Kérd le az ecom_buy táblából, ahol a quantity kisebb, mint 8, ÉS nagyobb, mint 5!
SELECT * FROM ecom_buy WHERE quantity < 8 AND quantity > 5;

-- Kérd le az ecom_buy táblából, ahol a quantity kisebb, mint 8, ÉS nagyobb, mint 5
-- és a vásárlás 2019-02-05 előtt történt!
SELECT
  *
FROM
  ecom_buy
WHERE
  quantity < 8 AND
  quantity > 5 AND
  datetime < '2019-02-05';

-- Kérd le az ecom_buy táblából, ahol a quantity nagyobb, mint 8, VAGY kisebb, mint 5!
SELECT
  *
FROM
  ecom_buy
WHERE
  quantity > 8 OR
  quantity < 5;

-- Kérd le az ecom_buy táblából, ahol a quantity nagyobb, mint 8, VAGY kisebb, mint 5
-- ÉS a visitor_id < 100001000! (Vigyázz, trükkös...)
SELECT
  *
FROM
  ecom_buy
WHERE
  (quantity > 8 OR quantity < 5) AND
  visitor_id < 100001000;

--------------------------
-- MINDEN EDDIGI EGYBEN --
--------------------------

-- Kérd le az ecom_visit táblából:
-- a dátum, visitor_id és browser oszlopokat
-- ahol a csatorna Facebook
-- ahol a dátum 2019 márciusában van
-- csak az első 100 sort!
SELECT
  datetime,
  visitor_id,
  browser
FROM
  ecom_visit
WHERE
  channel = 'Facebook' AND
  datetime >= '2019-03-01' AND
  datetime < '2019-04-01'
LIMIT 100;

-------------------
-- SORBARENDEZÉS --
-------------------
-- Kérd le az ecom_buy táblát és rendezd növekvő sorrendbe visitor_id szerint!
SELECT * FROM ecom_buy ORDER BY visitor_id ASC;

------------------
-- AGGREGÁCIÓK --
------------------
-- Hány vásárlás volt összesen?
SELECT COUNT(*) FROM ecom_buy;

-- Hány terméket adtunk el összesen?
SELECT SUM(quantity) FROM ecom_buy;

-- Mekkora volt az átlagos kosárméret? (quantity oszlop alapján)
SELECT AVG(quantity) FROM ecom_buy;

-- Mekkora volt az átlagos kosárméret 2019 februárjában? 
SELECT AVG(quantity) FROM ecom_buy
WHERE datetime < '2019-03-01';

-- Mekkora volt az átlagos kosárméret 2019 márciusában?
SELECT AVG(quantity) FROM ecom_buy
WHERE datetime >= '2019-03-01' AND datetime < '2019-04-01';

--------------
-- DISTINCT --
--------------
-- Kérd le az ecom_visitből, az összes egyedi csatornát!
SELECT DISTINCT(channel) FROM ecom_visit;

-- Kérd le az ecom_visitből, az összes egyedi böngészőt!
SELECT DISTINCT(browser) FROM ecom_visit;

--------------
-- GROUP BY --
--------------
-- Számold meg a látogatások számát channel-enként!
SELECT channel, COUNT(*) 
FROM ecom_visit 
GROUP BY channel;

-- Számold meg a látogatások számát channel-enként, de csak azokra az esetekre, ahol a device 'phone'!
SELECT channel, COUNT(*) 
FROM ecom_visit 
WHERE device = 'phone'
GROUP BY channel;

-- Látogatások száma channel-enként, ahol a device az 'phone'
-- majd az eredmény növekvő sorrendben látogatások száma szerint.
SELECT channel, COUNT(*) 
FROM ecom_visit 
WHERE device = 'phone'
GROUP BY channel
ORDER BY COUNT(*) ASC;

-- Kérd le, hogy buy_size-onként hány eladott termék volt?
SELECT buy_size, SUM(quantity)
FROM ecom_buy
GROUP BY buy_size;

--BÓNUSZ: az eddig megismert eszközökkel, hogyan tudod megállapítani,
-- hogy melyik buy_size címke (small, medium, big) milyen quantity-t takar? (Bármilyen módszer megengedett.)
SELECT buy_size, MIN(quantity), MAX(quantity)
FROM ecom_buy
GROUP BY buy_size;

----------
-- JOIN --
----------
-- JOIN-old az ecom_buy és az ecom_visit táblákat!
SELECT *
FROM ecom_buy
JOIN ecom_visit
ON ecom_buy.visitor_id = ecom_visit.visitor_id;

-- Válaszd ki (és nevezd át) az alábbi oszlopokat:
-- ecom_visit datetime --» visit_dt
-- ecom_buy datetime --» buy_dt
-- channel
-- visitor_id
-- browser
-- continent
-- device
-- buy_size
-- quantity
SELECT
  ecom_visit.datetime AS visit_dt,
  ecom_buy.datetime AS buy_dt,
  channel,
  ecom_visit.visitor_id,
  browser,
  continent,
  device,
  buy_size,
  quantity
FROM
  ecom_buy
JOIN
  ecom_visit
ON
  ecom_buy.visitor_id = ecom_visit.visitor_id;


-- EXTRA: ellenőrizd, hogy a visit táblában minden user csak egyszer szerepel-e!
-- (Nem feltétlen JOIN-os megoldás, több jó megoldás is van.)
---- Megoldás #1: COUNT, GROUP BY és ORDER BY használata:
SELECT visitor_id, COUNT(*)
FROM ecom_visit
GROUP BY visitor_id
ORDER BY COUNT(*) DESC;

SELECT visitor_id, COUNT(*)
FROM ecom_visit
GROUP BY visitor_id
ORDER BY COUNT(*) ASC;

---- Megoldás #2 JOIN típusok összehasonlítása és megnézni hány sor van az eredmény táblában:
---- LEFT JOIN: minden sor az ecom_visit táblából, még akkor is, ha nincs hozzá vásárlás
---- (azaz az összes látogató, függetlenül attól, hogy vásárolt-e)
    SELECT *
    FROM ecom_visit
    LEFT JOIN ecom_buy
    ON ecom_visit.visitor_id = ecom_buy.visitor_id;

-- RIGHT JOIN: minden sor az ecom_buy táblából, még akkor is, ha nincs hozzá látogatás
-- (gyakorlatilag minden vásárló, de ebben az adathalmazban valószínűleg minden vásárlónak volt látogatása)
    SELECT *
    FROM ecom_visit
    RIGHT JOIN ecom_buy
    ON ecom_visit.visitor_id = ecom_buy.visitor_id;

-- FULL JOIN: minden sor mindkét táblából
-- (minden látogató ÉS minden vásárló, még akkor is, ha valamelyik táblában nincs megfelelő sor)
    SELECT *
    FROM ecom_visit
    FULL JOIN ecom_buy
    ON ecom_visit.visitor_id = ecom_buy.visitor_id;

--------------------------
-- MINDEN EDDIGI EGYBEN --  
--------------------------
-- Van-e eltérés device-onként a vásárolt termékek számában? (KÖZÖSEN)
SELECT
  device,
  SUM(quantity) AS total_quantity
FROM
  ecom_buy
JOIN
  ecom_visit
ON
  ecom_buy.visitor_id = ecom_visit.visitor_id
GROUP BY
  device
ORDER BY
  total_quantity DESC;

-- Van-e különbség channel-önként az átlagos kosárméretben?
SELECT
  ecom_visit.channel,
  AVG(ecom_buy.quantity) AS avg_quantity
FROM
  ecom_buy
JOIN
  ecom_visit
ON
  ecom_buy.visitor_id = ecom_visit.visitor_id
GROUP BY
  ecom_visit.channel
ORDER BY
  avg_quantity DESC;

-- És ha csak telefonról nézzük?
SELECT
  ecom_visit.channel,
  AVG(ecom_buy.quantity) AS avg_quantity
FROM
  ecom_buy
JOIN
  ecom_visit
ON
  ecom_buy.visitor_id = ecom_visit.visitor_id
WHERE
  ecom_visit.device = 'phone'
GROUP BY
  ecom_visit.channel
ORDER BY
  avg_quantity DESC;

------------------------------
--- AI-SEGÍTETT MEGOLDÁSOK ---
------------------------------

-- Mennyi eladott termék volt hónaponként? (AI-segített megoldás)
SELECT
  DATE_TRUNC('month', datetime) AS month,
  SUM(quantity) AS total_quantity
FROM
  ecom_buy
GROUP BY
  month
ORDER BY
  month ASC;

-- Most számold meg hány eladás volt aszerint, hogy hány nap telt el a visit és a buy között!
SELECT
  DATE_PART('day', ecom_buy.datetime - ecom_visit.datetime) AS days_diff,
  SUM(quantity)
FROM ecom_buy
JOIN ecom_visit ON ecom_buy.visitor_id = ecom_visit.visitor_id
GROUP BY days_diff;

----------------
-- SUBQUERIES --
----------------
-- Hány fajta csatorna van az ecom_visit táblában? (subquery-s megoldás)
SELECT COUNT(*)
FROM (
  SELECT DISTINCT channel
  FROM ecom_visit
) AS subquery;

-- Kérd le azokat a channel-öket, ahol az eladott darabszám 1000 alatt van!
SELECT channel
FROM (
  SELECT
    ecom_visit.channel,
    SUM(ecom_buy.quantity) AS total_quantity
  FROM
    ecom_buy
  JOIN
    ecom_visit
  ON
    ecom_buy.visitor_id = ecom_visit.visitor_id
  GROUP BY
    ecom_visit.channel
) AS subquery
WHERE total_quantity < 1000;