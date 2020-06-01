-- 1225. Report Contiguous Dates

/*
Table: Failed
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
Primary key for this table is fail_date.
Failed table contains the days of failed tasks.

Table: Succeeded
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.
 

A system is running one task every day. Every task is independent of the previous tasks. 
The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of 
days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in 
this interval succeeded. Interval of days are retrieved as start_date and end_date.

Order result by start_date.

The query result format is in the following example:
Result table:
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+

*/

SELECT *
FROM (
    SELECT 'succeeded' AS period_state,
        MIN(success_date) AS start_date,
        MAX(success_date) AS end_date
    FROM (
        SELECT *,
            RANK() OVER(ORDER BY success_date) AS r
        FROM Succeeded
        WHERE success_date >= '2019-01-01' AND success_date <= '2019-12-31'
        ) s
    GROUP BY DATEADD(day, -r, success_date) -- get a sub-table for all 'succeeded' periods

    UNION

    SELECT 'failed' AS period_state,
        MIN(fail_date) AS start_date,
        MAX(fail_date) AS end_date
    FROM (
        SELECT *,
            RANK() OVER(ORDER BY fail_date) AS r
        FROM Failed
        WHERE fail_date >= '2019-01-01' AND fail_date <= '2019-12-31'
        ) f
    GROUP BY DATEADD(day, -r, fail_date) -- get a sub-table for all 'failed' periods
    ) tmp
ORDER BY start_date

