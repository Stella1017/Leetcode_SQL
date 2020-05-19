-- 1164. Product Price at a Given Date

/*
Table: Products
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Result table:
+------------+-------+
| product_id | price |
+------------+-------+
*/

-- Solution with CTE
WITH price_rank AS(
    SELECT *,
        RANK() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS pr
    FROM Products
    WHERE change_date <= '2019-08-16'
)

SELECT tmp.product_id,
    COALESCE(pr.new_price, 10) AS price
FROM 
    (SELECT DISTINCT product_id
    FROM Products) tmp
LEFT JOIN 
    (SELECT * 
     FROM price_rank
     WHERE pr = 1) pr
    ON tmp.product_id = pr.product_id
