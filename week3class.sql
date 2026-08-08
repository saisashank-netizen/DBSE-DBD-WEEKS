CREATE DATABASE IF NOT EXISTS class;
USE class;
CREATE TABLE class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE class_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO class VALUES
(1,'abhi'),
(2,'adam'),
(4,'alex');

INSERT INTO class_info VALUES
(1,'DELHI'),
(2,'MUMBAI'),
(3,'CHENNAI');

-- CROSS JOIN

SELECT *
FROM class
CROSS JOIN class_info;

-- ===========================================
-- PART 2 : INNER JOIN
-- ===========================================

DROP TABLE class;
DROP TABLE class_info;

CREATE TABLE class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE class_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO class VALUES
(1,'abhi'),
(2,'adam'),
(3,'alex'),
(4,'anu');

INSERT INTO class_info VALUES
(1,'DELHI'),
(2,'MUMBAI'),
(3,'CHENNAI');

-- INNER JOIN

SELECT *
FROM class
INNER JOIN class_info
ON class.id = class_info.id;

-- INNER JOIN (Selected Columns)

SELECT class.name,
       class_info.address
FROM class
INNER JOIN class_info
ON class.id = class_info.id;

-- ===========================================
-- PART 3 : NATURAL JOIN
-- ===========================================

SELECT *
FROM class
NATURAL JOIN class_info;

-- ===========================================
-- PART 4 : LEFT OUTER JOIN
-- ===========================================

INSERT INTO class VALUES
(5,'ashish');

INSERT INTO class_info VALUES
(7,'NOIDA'),
(8,'PANIPAT');

SELECT *
FROM class
LEFT OUTER JOIN class_info
ON class.id = class_info.id;

SELECT *
FROM class
LEFT JOIN class_info
ON class.id = class_info.id
WHERE class_info.id IS NULL;

-- ===========================================
-- PART 5 : RIGHT OUTER JOIN
-- ===========================================

SELECT *
FROM class
RIGHT OUTER JOIN class_info
ON class.id = class_info.id;

SELECT *
FROM class
RIGHT JOIN class_info
ON class.id = class_info.id
WHERE class.id IS NULL;

-- ===========================================
-- PART 6 : FULL OUTER JOIN
-- ===========================================

SELECT *
FROM class
FULL OUTER JOIN class_info
ON class.id = class_info.id;

SELECT *
FROM class
FULL OUTER JOIN class_info
ON class.id = class_info.id
WHERE class.id IS NULL
OR class_info.id IS NULL;

-- ===========================================
-- PART 7 : UNION
-- ===========================================

CREATE TABLE first_table(
    id INT,
    name VARCHAR(30)
);

CREATE TABLE second_table(
    id INT,
    name VARCHAR(30)
);

INSERT INTO first_table VALUES
(1,'abhi'),
(2,'adam');

INSERT INTO second_table VALUES
(2,'adam'),
(3,'chester');

SELECT *
FROM first_table
UNION
SELECT *
FROM second_table;

SELECT name
FROM first_table
UNION
SELECT name
FROM second_table;

-- ===========================================
-- PART 8 : UNION ALL
-- ===========================================

SELECT *
FROM first_table
UNION ALL
SELECT *
FROM second_table;

SELECT COUNT(*)
FROM
(
    SELECT *
    FROM first_table
    UNION ALL
    SELECT *
    FROM second_table
) A;

-- ===========================================
-- PART 9 : INTERSECT
-- ===========================================

SELECT *
FROM first_table
INTERSECT
SELECT *
FROM second_table;

SELECT name
FROM first_table
INTERSECT
SELECT name
FROM second_table;

-- ===========================================
-- PART 10 : MINUS
-- ===========================================

SELECT *
FROM first_table
MINUS
SELECT *
FROM second_table;

SELECT name
FROM first_table
MINUS
SELECT name
FROM second_table;

-- ===========================================
-- ADVANCED QUESTION 19
-- ===========================================

SELECT c.id,
       c.name,
       ci.address
FROM class c
INNER JOIN class_info ci
ON c.id = ci.id;

-- ===========================================
-- ADVANCED QUESTION 20
-- ===========================================

SELECT c.id,
       c.name,
       CASE
           WHEN ci.address IS NULL
           THEN 'Address Missing'
           ELSE 'Address Available'
       END AS Status
FROM class c
LEFT JOIN class_info ci
ON c.id = ci.id;