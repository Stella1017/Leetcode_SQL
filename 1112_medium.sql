-- 1112. Highest Grade For Each Student

/*
Table: Enrollments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key of this table.

Write a SQL query to find the highest grade with its corresponding course for each student. 
In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

The query result format is in the following example:

Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+

Result table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+

*/

-- MS SQL_1 with CTE (too slow)
WITH max_grade AS (
SELECT student_id, MAX(grade) AS grade
FROM Enrollments
GROUP BY student_id
    )

SELECT 
    student_id,
    MIN(course_id) AS course_id,
    grade
FROM Enrollments
GROUP BY student_id, grade
HAVING CONCAT(student_id, grade) IN 
    (SELECT CONCAT(student_id, grade) FROM max_grade)
ORDER BY student_id ASC

-- MS SQL_2 with Left Join
SELECT
    g.student_id,
    c.min_course AS course_id,
    g.grade
FROM (
    SELECT
        student_id,
        MAX(grade) AS grade
    FROM Enrollments
    GROUP BY student_id
    ) g -- find highest grade for each student
LEFT JOIN (
    SELECT 
        student_id,
        MIN(course_id) AS min_course,
        grade
    FROM Enrollments
    GROUP BY student_id, grade
    ) c -- for each (student, grade) combination, find the smallest course_id
ON g.student_id = c.student_id
    AND g.grade = c.grade
