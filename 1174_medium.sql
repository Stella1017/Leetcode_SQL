-- 1174. Immediate Food Delivery II

/*
Table: Delivery
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a 
preferred delivery date (on the same order date or after it).

If the preferred delivery date of the customer is the same as the order date 
then the order is called immediate otherwise it's called scheduled.

The first order of a customer is the order with the earliest order date that customer made. 
It is guaranteed that a customer has exactly one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers, 
rounded to 2 decimal places.

Result table:
+----------------------+
| immediate_percentage |
+----------------------+
*/

-- Solution with CTE:

WITH Order_Rank AS (
    SELECT *,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rk
    FROM Delivery
)

SELECT CAST(AVG(CASE WHEN order_date = customer_pref_delivery_date THEN 100.0 ELSE 0 END) AS DECIMAL(10,2)) AS immediate_percentage
FROM Order_Rank
WHERE rk = 1
