-- 1159. Market Analysis II

/*
Table: Users
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id is the primary key of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.

Table: Orders
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the primary key of this table.
item_id is a foreign key to the Items table.
buyer_id and seller_id are foreign keys to the Users table.

Table: Items
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the primary key of this table.
 
Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. 
If a user sold less than two items, report the answer for that user as no.

It is guaranteed that no seller sold more than one item on a day.

The query result format is in the following example:

Users table:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2019-01-01 | Lenovo         |
+---------+------------+----------------+

Orders table:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
+----------+------------+---------+----------+-----------+

Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
+---------+------------+

Result table:
+-----------+--------------------+
| seller_id | 2nd_item_fav_brand |
+-----------+--------------------+
*/

-- MS SQL with CTE
WITH Item_ranks AS
(SELECT seller_id,
        item_id,
        RANK() OVER(PARTITION BY seller_id ORDER BY order_date ASC) AS item_rank
    FROM Orders)

SELECT U.user_id AS seller_id,
   CASE WHEN U.favorite_brand = I.item_brand THEN 'yes' ELSE 'no' END AS '2nd_item_fav_brand'
FROM Users U
LEFT JOIN
    (SELECT seller_id, item_id
    FROM Item_ranks
    WHERE item_rank = 2) tmp
    ON U.user_id = tmp.seller_id
LEFT JOIN Items I
    ON tmp.item_id = I.item_id
