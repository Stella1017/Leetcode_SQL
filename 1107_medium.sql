-- 1107. New Users Daily Count

/*
Table: Traffic
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| activity      | enum    |
| activity_date | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 
Write an SQL query that reports for every date within at most 90 days from today, the number of 
users that logged in for the first time on that date. Assume today is 2019-06-30.

The query result format is in the following example:

Traffic table:
+---------+----------+---------------+
| user_id | activity | activity_date |
+---------+----------+---------------+

Result table:
+------------+-------------+
| login_date | user_count  |
+------------+-------------+

Note that we only care about dates with non zero user count.
*/

-- MS SQL with window function
SELECT activity_date AS login_date,
    COUNT(DISTINCT user_id) AS user_count
FROM (
    SELECT 
        user_id,
        RANK() OVER(PARTITION BY user_id ORDER BY activity_date) AS first_login,
        activity_date
    FROM Traffic
    WHERE activity = 'login') tmp
WHERE first_login = 1 
    AND DATEDIFF(day, activity_date, '2019-06-30') <= 90
GROUP BY activity_date
;

-- MySQL with Left Join (much faster)
SELECT t1.activity_date AS login_date,
    COUNT(DISTINCT t2.user_id) AS user_count
FROM
    (SELECT user_id, activity_date
    FROM Traffic
    WHERE activity = 'login' 
        AND DATEDIFF('2019-06-30', activity_date) <= 90) t1

LEFT JOIN 

    (SELECT user_id,
        MIN(activity_date) AS first_login
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id) t2
    ON t1.user_id = t2.user_id
        AND t1.activity_date = t2.first_login
GROUP BY t1.activity_date
HAVING COUNT(DISTINCT t2.user_id) > 0 
; 

    
