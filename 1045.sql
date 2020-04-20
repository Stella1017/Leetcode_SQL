# Table: Customer
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | customer_id | int     |
# | product_key | int     |
# +-------------+---------+
# product_key is a foreign key to Product table.

# Table: Product
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | product_key | int     |
# +-------------+---------+
# product_key is the primary key column for this table.
 
#  Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(product_key) FROM Product);
