-- Using the salesshort database
USE salesshort;

#01. How many customers are in the customers table?
-- Returns 122 rows (i.e., 122 customers).  
SELECT COUNT(customerName) AS 'No. of Customers' 
FROM customers;

-- OR...
SELECT COUNT(*) AS 'No. of Customers'
FROM customers;

#02. How many German customers are in the customers table (i.e., from 'Germany')? 
-- Returns 13 customers from Germany. 
SELECT COUNT(*) AS 'No. of German Customers'
FROM customers
WHERE country = 'Germany';

-- OR...
SELECT COUNT(customerName) AS 'No. of German Customers'
FROM customers
WHERE country = 'Germany';

#03 How many customers does the customers table have from each country? Order by most to least customers. 
-- Returns 27 rows (i.e., country groups) with USA at the top and 36 customers, followed by Germany and 13 customers. 
SELECT
	country,
    COUNT(customerName) AS 'No. of Customers in Country'
FROM customers
GROUP BY country
ORDER BY COUNT(customerName) DESC;

-- OR...
SELECT
	country,
    COUNT(*) AS 'No. of Customers in Country'
FROM customers
GROUP BY country
ORDER BY COUNT(*) DESC;

#04. What is the average MSRP across all products in the products table? 
-- Returns average of MSRP of 100.44. 
SELECT ROUND(AVG(MSRP),2) AS 'Average MSRP'
FROM products;

#05. What is the total revenue of the company using the orderdetails table?
-- Returns a total revenue of $9,603,658. 
SELECT FORMAT(SUM(quantityOrdered * priceEach),0) AS 'Total Revenue'
FROM orderdetails;

#06. How many products (i.e., productName) does each productline have? Order by most to least. 
-- Returns 7 productline groups with Classic Cars at the top and 38 products, followed by Vintage Cars and 24 products.  
SELECT 
	productLine,
    COUNT(productName) AS 'No. of Products'
FROM products
GROUP BY productLine
ORDER BY COUNT(productName) DESC;

-- This does not follow the instructions, but works out because there is a 1:1 relationship between rows in the table and productName, meaning productName is granular to the 'row-level.' 
SELECT 
	productLine,
    COUNT(*) AS 'No. of Products'
FROM products
GROUP BY productLine
ORDER BY COUNT(*) DESC;

#07. How many products does each productline have? Show only the productline(s) with 10 or more products. Order by most to least. 
-- Returns 5 productline groups with cutoff at Trucks and Buses and 11 products. 
SELECT 
	productLine,
    COUNT(productName) AS 'No. of Products'
FROM products
GROUP BY productLine
HAVING COUNT(productName) >= 10
ORDER BY COUNT(productName) DESC;

-- Does not follow the instructions, but similar results:
SELECT 
	productLine,
    COUNT(*) AS 'No. of Products'
FROM products
GROUP BY productLine
HAVING COUNT(*) >= 10
ORDER BY COUNT(*) DESC;

#08. Show the 'total revenue' (i.e., sum (quantityOrdered * priceEach)) for each orderNumber. Order by highest to lowest revenue. 
-- Returns 326 orderNumber groups. 
SELECT
	orderNumber,
    FORMAT(SUM(quantityOrdered * priceEach),0) AS 'revenue' -- you do not need to format this. 
FROM orderdetails
GROUP BY orderNumber
ORDER BY SUM(quantityOrdered * priceEach) DESC;

#09. How many orders have been cancelled (i.e., status = 'cancelled')?
-- Returns 6 cancelled orders.
SELECT COUNT(orderNumber) AS 'No. of Orders Cancelled'
FROM orders
WHERE status = 'cancelled';

-- OR...
SELECT COUNT(*) AS 'No. of Orders Cancelled'
FROM orders
WHERE status = 'cancelled';

#10. Show the 'total quantity in stock value' (i.e., sum(quantityInStock * buyPrice)) by productVendor. Order by highest to lowest quantity in stock value.
-- Returns 13 productVendor groups. 
SELECT
	productVendor,
    FORMAT(SUM(quantityInStock * buyPrice),0) AS 'Quantity in Stock Value'
FROM products
GROUP BY productVendor
ORDER BY SUM(quantityInStock * buyPrice) DESC;

#11. How many customers from the customers table have no sales representative?
-- Returns 22 customers without an assigned sales rep. 
SELECT COUNT(customerName) AS 'No. customers w/out sales rep'
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- OR...
SELECT COUNT(*) AS 'No. customers w/out sales rep'
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

#12. Show the 'total revenue' by productCode. Show only products with more than 50,000 in total revenue. Order by highest to lowest revenue. 
-- Returns 94 productCode groups. 
SELECT
	productCode,
    FORMAT(SUM(quantityOrdered * priceEach),0) AS 'Total Revenue'
FROM orderDetails
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY SUM(quantityOrdered * priceEach) DESC;

#13. How many customers does the company have in each country/city (i.e., group by country, city) with a creditLimit over 100,000? Order by most to least while showing only cities with 2 or more customers. 
-- Returns two groups, group by both country and city. Only two cities meet these conditions: NYC and Madrid. 
SELECT
	country,
    city,
    COUNT(customerName) AS 'No. Customers w/ creditLimit > 100,000'
FROM customers
WHERE creditLimit > 100000
GROUP BY
	country,
    city
HAVING 
    COUNT(customerName) >= 2
ORDER BY COUNT(customerName) DESC;

#14. How many customers does each sales representative (i.e., salesRepEmployeeNumber) have in each city? Remove/exclude any rows where the salesRepEmployeenNumber is NULL. Order by the number of customers (i.e., count of customers) in descending order.
-- Returns 87 groups, grouped by salesRepEmployeeNumber and city
SELECT
	salesRepEmployeeNumber,
    city,
    COUNT(customerName) AS 'No. Customers'
FROM customers
WHERE salesRepEmployeeNumber IS NOT NULL
GROUP BY
	salesRepEmployeeNumber,
    city
ORDER BY 
    COUNT(customerName) DESC;

-- OR...
SELECT
	salesRepEmployeeNumber,
    city,
    COUNT(*) AS 'No. Customers'
FROM customers
WHERE salesRepEmployeeNumber IS NOT NULL
GROUP BY
	salesRepEmployeeNumber,
    city
ORDER BY 
    COUNT(*) DESC;

#15. Show the number of products for each productScale. Order by productScale in ascending order.
-- Returns 8 productScale groups. The sorting is based on a string/text field, so the productScale order will look a little goofy (e.g., 1:700 before 1:72).   
SELECT 
	productScale,
    COUNT(productName) AS 'No. of Products'
FROM products
GROUP BY productScale
ORDER BY productScale;

-- OR...
SELECT 
	productScale,
    COUNT(*) AS 'No. of Products'
FROM products
GROUP BY productScale
ORDER BY productScale;