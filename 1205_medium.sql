-- 1205. Monthly Transactions II

/*

Table: Transactions
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

Table: Chargebacks
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| charge_date    | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.
 

Write an SQL query to find for each month and country, the number of approved transactions 
and their total amount, the number of chargebacks and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

The query result format is in the following example:

Result table:
+----------+---------+----------------+-----------------+-------------------+--------------------+
| month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
+----------+---------+----------------+-----------------+-------------------+--------------------+

*/

SELECT COALESCE(T.month, C.month) AS month,
    COALESCE(T.country, C.country) AS country,
    COALESCE(T.approved_count, 0) AS approved_count,
    COALESCE(T.approved_amount, 0) AS approved_amount,
    COALESCE(C.chargeback_count, 0) AS chargeback_count,
    COALESCE(C.chargeback_amount, 0) AS chargeback_amount
FROM
    (
    SELECT
        country,
        LEFT(CAST(trans_date AS varchar), 7) AS month,
        COUNT(id) AS approved_count,
        SUM(amount) AS approved_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY country, LEFT(CAST(trans_date AS varchar), 7)
    ) T -- create a sub-table only considering "approved" transactions
FULL OUTER JOIN 
    (
    SELECT 
        LEFT(CAST(C.trans_date AS varchar), 7) AS month,
        T.country,
        COUNT(C.trans_id) AS chargeback_count,
        SUM(T.amount) AS chargeback_amount
    FROM Chargebacks C
    LEFT JOIN Transactions T
        ON C.trans_id = T.id
    GROUP BY LEFT(CAST(C.trans_date AS varchar), 7), T.country
    ) C -- create a sub-table only considering "chargeback" transactions
    ON T.month = C.month 
        AND T.country = C.country

