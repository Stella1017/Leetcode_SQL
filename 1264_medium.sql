-- 1264. Page Recommendations

/*
Table: Friendship
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.
 
Table: Likes
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key for this table.
Each row of this table indicates that user_id likes page_id.
 
Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. 
It should not recommend pages you already liked.

Return result table in any order without duplicates.

The query result format is in the following example:
Result table:
+------------------+
| recommended_page |
+------------------+
*/

-- Solution 1: (however it will return "null" instead of an empty cell if the table created by left-joins return null)
SELECT DISTINCT page_id AS recommended_page
FROM 
    (SELECT L.page_id
    FROM Friendship F
    LEFT JOIN Likes L
        ON F.user2_id = L.user_id
    WHERE F.user1_id = 1
    UNION
    SELECT L.page_id
    FROM Friendship F
    LEFT JOIN Likes L
        ON F.user1_id = L.user_id
    WHERE F.user2_id = 1
    ) tmp
WHERE page_id NOT IN (
    SELECT page_id
    FROM Likes
    WHERE user_id = 1
    )

-- Solution 2:
SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (
    SELECT user2_id
    FROM Friendship
    WHERE user1_id = 1
    UNION 
    SELECT user1_id
    FROM Friendship
    WHERE user2_id = 1)
AND page_id NOT IN (
    SELECT page_id
    FROM Likes
    WHERE user_id = 1
    )

