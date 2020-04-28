-- 1098. Unpopular Books

/*
Table: Books
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key of this table.

Table: Orders
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key of this table.
book_id is a foreign key to the Books table.
 

Write an SQL query that reports the books that have sold less than 10 copies in the last year, 
excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

The query result format is in the following example:

Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+

Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+

Result table:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
*/

WITH less_pop AS (
    SELECT book_id
    FROM Orders
    WHERE DATEDIFF(day, dispatch_date, '2019-06-23') <= 365 --"last year" means in the past 365 days...
    GROUP BY book_id
    HAVING SUM(quantity) >= 10
)

SELECT book_id, name
FROM Books
WHERE available_from < '2019-05-23' 
    AND book_id NOT IN (SELECT book_id FROM less_pop)
