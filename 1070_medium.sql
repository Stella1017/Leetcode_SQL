# 1070. Product Sales Analysis III

# Table: Sales

# +-------------+-------+
# | Column Name | Type  |
# +-------------+-------+
# | sale_id     | int   |
# | product_id  | int   |
# | year        | int   |
# | quantity    | int   |
# | price       | int   |
# +-------------+-------+
# sale_id is the primary key of this table.
# product_id is a foreign key to Product table.
# Note that the price is per unit.
# Table: Product

# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | product_id   | int     |
# | product_name | varchar |
# +--------------+---------+
# product_id is the primary key of this table.
 

# Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

# Result table:
# +------------+------------+----------+-------+
# | product_id | first_year | quantity | price |
# +------------+------------+----------+-------+ 

# MS SQL with Window Function
SELECT 
    product_id, 
    first_year,
    quantity,
    price
FROM
    (SELECT 
        product_id, 
        year AS first_year,
        quantity,
        price,
        RANK() OVER(PARTITION BY product_id ORDER BY year, sale_id ASC) AS YearRank
    FROM Sales) t
WHERE YearRank = 1;

# MySQL (faster)
SELECT 
    S.product_id,
    tmp.first_year,
    S.quantity, 
    S.price
FROM 
    (SELECT product_id, MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id) tmp
LEFT JOIN Sales S
    ON S.product_id = tmp.product_id 
    AND S.year = tmp.first_year;
    
# There could be multiple sales records for one product in the first year, the question didn't specify how to deal with it, 
# and the "expected answer" just kept all the records

