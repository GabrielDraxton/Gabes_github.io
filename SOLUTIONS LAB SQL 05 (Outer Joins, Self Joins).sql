#SQL LAB 05: OUTER JOINS, SELF JOINS
use salesshort;

#Q1: Show all customers (customerNumber and customerName) without any orders.
-- Returns 24 rows (i.e., a list of 24 customers) that do not have any associated orders per the orders table. 
select c.customernumber, customername from customers c
left join orders o on c.customernumber = o.customernumber
where ordernumber IS NULL;
   
   
#Q2: How many products (i.e., via a count) don't have an order?
-- Returns a count of 1 product not associated with an order (i.e., where the orderNumber is NULL; NULL <> 0). 
SELECT
COUNT(productName) 
FROM products
LEFT JOIN orderdetails
USING (productCode)
LEFT JOIN orders
USING(orderNUmber)
WHERE orders.orderNumber IS NULL;

-- OR...
SELECT
COUNT(*)
FROM products
LEFT JOIN orderdetails
USING (productCode)
LEFT JOIN orders
USING(orderNUmber)
WHERE orders.orderNumber IS NULL;

-- This is just a list of those proudctCodes with no associated orders.
SELECT p.productCode from products p
LEFT JOIN orderdetails od on p.productcode = od.productcode
LEFT JOIN orders o on o.orderNumber = od.orderNumber
where o.ordernumber IS NULL;


#Q3: Show all productlines (productLine and textDescription) that don’t have products.
-- Returns 1 NULL productLine, but we have a textDescription
select p.productline, textdescription from productlines pl
left join products p on pl.productline = p.productline
where p.productline IS NULL;

-- OR...same query as above, we are just seeing how many productLines have a NULL using the productCode column from the productLines table.
select p.productline, textdescription from productlines pl
left join products p on pl.productline = p.productline
where p.productCode IS NULL;


#Q4: How many customers (i.e., via a count)  don’t have orders?
-- Returns a count of 24 customers with no associated order. 
select count(*) as 'Number of Customers without Orders' from customers c
left join orders o on c.customernumber = o.customernumber
where ordernumber IS NULL;


/*Q5: Write a SELECT statement to answer the following using a union while createing a list with the following four fields: 
    * under one column aliased name, combine both the customerName and productVendor fields together (i.e., mix your customers and vendors together in one column);
    * the productCode;
    * under one column aliased quantity, combine both the quantityOrdered (for customers) and the quantityInStock (for vendors) fields together; and
    * a new column labeled source as a calculated field that identifies (i.e., stamps) the table source (e.g., ‘customer,’ ‘vendor’) depending on where the information comes from. If the data comes from the customers table, stamp the string/text: ‘customer’. If the data comes from the products table, stamp the string/text: ‘vendor’.

Order by productCode (A-Z), then order by quantity (highest qty to lowest qty). 
  */ 

select * from (
	select 'customer' as source, customername as name, productcode, sum(quantityordered) as quantity 
    from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber, productcode
    
    union    
	
    select 'vendor' as source, productvendor, productcode, quantityinstock as quantity from products p
    ) sq
order by productcode, quantity desc; 


#Q6: Which country is ‘Rovelli Gifts’ in? Show all customers (including ‘Rovelli Gifts’) from that country to include their customerNumber, customerName, city, and country. Order by customerName (A-Z).
-- Returns 4 customers associated with the country of Italy. 'Rovelli Gifts' is an Italian customer.
select c2.customernumber, c2.customername, c2.city, c2.country from customers c1
join customers c2 on c1.country = c2.country
where c1.customername = 'Rovelli Gifts'
order by c2.customername;

-- Check if the answer is correct or back into the self join used in Q6. 
-- Step 1: Determine the country associated with the customer 'Rovelli Gifts'.
select country from customers
where customername = 'Rovelli Gifts';

-- Step 2: Determine all Italian customers.
select customerName, customerNumber from customers
where country = 'Italy';


#Q7: Determine the vendor for ‘1968 Ford Mustang’ and show the other products sold/offered by that vendor (do not include ‘1968 Ford Mustang’). Show the productCode, productName, and productLine of these other products. Order by productCode (A-Z).
-- Returns 7 products associated with the vendor 'Autoart Studio Design' who also sold the '1968 Ford Mustang' but does not include the '1968 Ford Mustang' productName. 
select p2.productcode, p2.productname, p2.productline from products p1
join products p2 on p1.productVendor = p2.productVendor and p1.productname <> p2.productname
where p1.productname = '1968 Ford Mustang'
order by p2.productcode;

-- Check if the answer is correct or back into the self join used in Q7. 
-- Step 1: Determine who sold the productName '1968 Ford Mustang'.
 select productVendor from products
where productname = '1968 Ford Mustang'
order by productcode;

-- Step 2: Determine which other productCodes where sold/offered by the vendor 'Autoart Studio Design'. 
select productCode, productName from products
where productVendor = 'Autoart Studio Design'
order by productCode; -- then remove the productName '1968 Ford Mustang' from this list 
	
    
#Q8: Which products did ‘Boards & Toys Co.’ buy? Show the other customers (not including ‘Boards & Toys Co.’) who bought these same products. Show the customerNumber, customerName, productCode, and productName of these other customers. Order by productCode (A-Z). This SELECT statement is worth 2 points. 
-- Returns 78 customers who also bought productCodes 'S12_3380', 'S24_3151', 'S700_2610', but do not include productCodes associated with ‘Boards & Toys Co.’ 
select c2.customernumber, c2.customername, p2.productcode, p2.productname  

-- this part is just inner joins going from the customers table to the products table
from customers c1
join orders o1 on c1.customernumber = o1.customernumber
join orderdetails od1 on o1.ordernumber = od1.ordernumber
join products p1 on od1.productcode = p1.productcode
    
-- SELF JOINS bridging ON p1.productCode = p2.productCode, starting with the products table and eventually returning to the customers table
join products p2 on p1.productcode = p2.productcode 
join orderdetails od2 on od2.productcode = p2.productcode
join orders o2 on od2.ordernumber = o2.ordernumber
join customers c2 on o2.customernumber = c2.customernumber 

where c1.customername = 'Boards & Toys Co.' and c2.customername != 'Boards & Toys Co.'
order by p2.productcode;
    
-- Check if the answer is correct or back into the self join used in Q8. 
-- Step 1: Find products bought by 'Boards & Toys Co'.
select c.customernumber, customername, p.productcode, productname from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
	join products p on od.productcode = p.productcode
    where c.customername = 'Boards & Toys Co.';
    
-- Step 2: Find other customers associated with the following products: 'S12_3380', 'S24_3151', 'S700_2610'.
select c.customernumber, customername, p.productcode, productname from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
	join products p on od.productcode = p.productcode
    where p.productcode IN ('S12_3380', 'S24_3151', 'S700_2610') ; -- then...kick out 'Boards & Toys Co.' from this list of customers. 




