-- 1077. Project Employees III

/*
Table: Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.

Table: Employee
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.
 
Write an SQL query that reports the most experienced employees in each project. 
In case of a tie, report all employees with the maximum number of experience years.

Result table:
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
*/

-- MS SQL
SELECT project_id, employee_id
FROM
    (SELECT 
        P.project_id, 
        P.employee_id, 
        DENSE_RANK() OVER(
            PARTITION BY P.project_id ORDER BY E.experience_years DESC) AS rk
    FROM Project P
    LEFT JOIN Employee E
        ON P.employee_id = E.employee_id) tmp
WHERE rk = 1
