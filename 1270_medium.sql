-- 1270. All People Report to the Given Manager

/*
Table: Employees
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id 
and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.

Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

The query result format is in the following example:
Result table:
+-------------+
| employee_id |
+-------------+
*/

SELECT E.employee_id
FROM Employees E
LEFT JOIN Employees L1
    ON E.manager_id = L1.employee_id
LEFT JOIN Employees L2
    ON L1.manager_id = L2.employee_id
LEFT JOIN Employees L3
    ON L2.manager_id = L3.employee_id
WHERE (E.manager_id = 1
    OR L1.manager_id = 1
    OR L2.manager_id = 1
    OR L3.manager_id = 1)
    AND E.employee_id != 1
;

