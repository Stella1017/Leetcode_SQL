-- 1127. User Purchase Platform

/*
Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').
Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

The query result format is in the following example:

Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+

Result table:
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.
*/

WITH purchase AS (
SELECT 
    COALESCE(m.user_id, d.user_id) AS user_id,
    COALESCE(m.spend_date, d.spend_date) AS spend_date,
    CASE
        WHEN m.amount IS NOT NULL AND d.amount IS NOT NULL THEN m.amount + d.amount
        WHEN m.amount IS NOT NULL AND d.amount IS NULL THEN m.amount
        ELSE d.amount END AS total_amount,
    CASE
        WHEN m.amount IS NOT NULL AND d.amount IS NOT NULL THEN 'both'
        WHEN m.amount IS NOT NULL AND d.amount IS NULL THEN 'mobile'
        ELSE 'desktop' END AS platform     
FROM 
    (SELECT *
    FROM Spending
    WHERE platform = 'mobile') m
FULL OUTER JOIN 
    (SELECT *
    FROM Spending
    WHERE platform = 'desktop') d
    ON m.user_id = d.user_id
        AND m.spend_date = d.spend_date
),

date_plat AS (
    SELECT *
    FROM 
        (SELECT DISTINCT spend_date FROM purchase) d
    CROSS JOIN
        (SELECT DISTINCT platform FROM purchase) p
)


SELECT dp.spend_date,
    dp.platform,
    COALESCE(p.total_amount, 0) AS total_amount,
    COALESCE(p.total_users, 0) AS total_users
FROM date_plat dp
LEFT JOIN 
    (SELECT spend_date,
        platform,
        total_amount,
        COUNT(user_id) AS total_users
     FROM purchase
     GROUP BY spend_date,
        platform,
        total_amount
    ) p
    ON dp.spend_date = p.spend_date
        AND dp.platform = p.platform
        
        
