USE salesshort; -- Using the salesshort database

#Task 1. 
-- Show the customerNumber, customerName, city, state, and country for all customers from the country ‘Germany.’ Order by customerName (A-Z).
SELECT
	customerNumber,
    customerName,
    city,
    state,
    country
FROM customers
WHERE country = 'Germany'
ORDER BY customerName;

#Task 2. 
-- Show everything from the products table where ‘Harley’ is somewhere in the productName. Order by productLine (A-Z), then by quantityInStock (lowest to highest).
SELECT *
FROM products
WHERE productName LIKE '%Harley%'
ORDER BY
	productLine,
    quantityInStock;

#Task 3. 
-- Show productCode, productName, and margin (msrp – buyPrice). Show only the products with margins greater than 50. Order by margin (highest to lowest). 
SELECT
	productCode,
    productName,
    msrp - buyPrice AS margin
FROM products
WHERE msrp - buyPrice > 50
ORDER BY margin DESC;

#Task 4. 
-- Show everything from the orders table that have a comment (i.e., do not include missing comments, comments with NULL values).
SELECT *
FROM orders
WHERE comments IS NOT NULL;

#Task 5. 
-- Show everything from the orders table where the status is not ‘Shipped.’ 
SELECT *
FROM orders
WHERE status <> 'Shipped';

-- OR...
SELECT *
FROM orders
WHERE status != 'Shipped';

-- OR...
SELECT *
FROM orders
WHERE status NOT IN ('Shipped'); -- somthing to this effect, should return 23 rows where status does not equal 'Shipped'

#Task 6. 
-- Show everything from the products table where ‘Car’ is somewhere in the productLine. Then, order by MSRP (largest to smallest). Show only the first twenty rows. 
SELECT *
FROM products
WHERE productLine LIKE '%car%' -- you can ProperCase or lowercase 'car', does not matter
ORDER BY msrp DESC
LIMIT 20;

#Task 7. 
-- Show customerName, contactFirstName, contactLastName, and creditLimit where the contactFirstName only has 5 characters (i.e., 5 characters exactly, spacing not included). Order by contactLastName (A-Z). You should use a TRIM function around contactFirstName in your SELECT statement to remove any leading and/or trailing spaces from this string field. You should also use the TRIM function, TRIM(contactFirstName), with your WHERE clause to ensure you filter on people with only 5-character first names. There are a few ways to solve for this.  
SELECT
	customerName,
    contactFirstName,
    contactLastName,
    creditLimit,
    TRIM(LENGTH(contactFirstName)) AS 'No. of Characters' -- TRIM function not needed here
FROM customers
WHERE LENGTH(TRIM(contactFirstName)) = 5 -- but, the TRIM function is needed here
ORDER BY contactLastName;

-- OR...
select customerName, contactFirstName, contactLastName, creditLimit from customers
	where trim(contactFirstName) like '_____'
    order by contactLastName;

#Task 8. 
-- Show productName, productLine, and productDescription where the productScale is 1:10. Order by productLine (A-Z), then order by productName (Z-A).
SELECT
	productName,
    productLine,
    productDescription,
    productScale
FROM products
WHERE productScale = '1:10' -- this needs to be a string
ORDER BY
	productLine,
    productName DESC;

#Task 9. 
-- Show everything from the orderdetails table where the ‘Total Price’ (quantityOrdered * priceEach) is greater than 500 and lower than 1000 (i.e., between 500.01 and 999.99). Order by ‘Total Price’ in descending order. 
SELECT 
	*,
    quantityOrdered * priceEach AS 'Total Price'
FROM orderdetails
WHERE 
	quantityOrdered * priceEach > 500 AND
    quantityOrdered * priceEach < 1000
ORDER BY quantityOrdered * priceEach DESC;

-- OR...
SELECT 
	*,
    quantityOrdered * priceEach AS 'Total Price'
FROM orderdetails
WHERE 
	quantityOrdered BETWEEN 500 AND 1000
ORDER BY quantityOrdered * priceEach DESC;

#Task 10. 
-- Show everything from the customers table where the customer is from the country USA with a creditLimit greater than 100000.
SELECT *
FROM customers
WHERE
	country = 'USA' AND
    creditLimit > 100000;
