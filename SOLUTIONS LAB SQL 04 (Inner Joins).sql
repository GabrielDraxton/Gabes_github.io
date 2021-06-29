use salesshort;

#01 Show all customers (number and name) and their cancelled orders only (order number, order date, and status).
-- Returns 6 rows, or 6 cancelled orders. 
select c.customernumber, customername, ordernumber, orderdate, status from customers c
	join orders o on c.customernumber = o.customernumber
    where status = 'cancelled';
    
-- OR...This query leads with the customers table. We also use the USING clause vs. an ON clause as seen in the query directly above.   
select c.customernumber, customername, ordernumber, orderdate, status from customers c
join orders o using (customernumber)
where status = 'cancelled';

-- OR...This query makes the orders table the leading table now. We still get the same results because it's an inner join (i.e., everthing from the left must match the right, and vice versa).  
select c.customernumber, customername, ordernumber, orderdate, status from orders o
join customers c using (customernumber)
where status = 'cancelled';
    
    
#02 Show the customerNumber, customerName, and each customer’s number of orders (i.e., count(orderNumber)). Group by the customerNumber. Order by the number of orders (most to least).
-- Returns 98 customerNumber groups with their number of orders. The most orderes is coming from customerNumber 141 with 26 orders, followed by customerNumber 124 with 17 orders.  
select c.customernumber, customername, count(*) as 'Number of Orders' from customers c
	join orders o on c.customernumber = o.customernumber
    group by customernumber
    order by count(*) desc;
    
-- OR...This query makes the orders table the leading table now. We also use the USING clause vs. an ON clause as seen in the query directly above. We also COUNT(column) vs. count(*).    
select c.customernumber, customername, count(orderNumber) as 'Number of Orders' from orders o
join customers c using (customerNumber)
group by customernumber
order by count(orderNumber) desc;


#03 Show the product line, text description of the product line, and the number of products in the product line. Group by the product line. Order by the product line (A-Z).
-- Returns 7 productLine groups with Classic Cars at the top with 38 products, followed by Motorcycles with 13 products.  
select pl.productline, textdescription, count(*) as 'Number of Products per Productline' from productlines pl
	join products p on pl.productline = p.productline
    group by pl.productline
    order by productline;
    
-- OR...Same query as above, just using an ORDER BY based on column position numbers and not column names. 
select pl.productline, textdescription, count(*) as 'Number of Products per Productline' from productlines pl
	join products p on pl.productline = p.productline
    group by pl.productline
    order by 1;
    
-- OR...This query makes the products table the leading table now. We also COUNT(column) vs. count(*) using COUNT(p.productCode).  
select pl.productline, textdescription, count(p.productCode) as 'Number of Products per Productline' from products p 
	join productlines pl on pl.productline = p.productline
    group by pl.productline
    order by productline;
    
-- OR...If you got an error 1055, through/add textdescription to your GROUP BY clause. Noticed I switched out COUNT(productCode) with COUNT(productName)...Aha! Here we have function dependency between productLine and textdescription ('1:1 relationship').   
select pl.productline, textdescription, count(p.productName) as 'Number of Products per Productline' from products p 
	join productlines pl on pl.productline = p.productline
    group by pl.productline, textdescription
    order by productline;
    
    
#04 Show all orders (order number, order date, status) with product code, product name, and sum(quantityOrdered). Group by the order number, then group by the product code. Order by the order number, then order by the product name.
-- Return 2996 groups (i.e., grouped by orderNumber, then grouped by productCode). OrderNumber 10100 and ProductName 1911 Ford Town Car (i.e., code S18_2248) are at the top with 50 orders.  
select o.ordernumber, orderdate, status, p.productcode, productname, sum(quantityordered) as 'order qty' from orderdetails od
	join orders o on od.ordernumber = o.ordernumber
    join products p on od.productCode = p.productCode
    group by ordernumber, p.productcode
    order by ordernumber, productname;
    
-- OR...This query makes the products table the leading table now. ORDER BY based on column position numbers and not column names.  
select o.ordernumber, orderdate, status, p.productcode, productname, sum(quantityordered) as 'order qty' from products p
join orderdetails od on od.productCode = p.productCode
join orders o on od.ordernumber = o.ordernumber
group by ordernumber, p.productcode   
order by 1, 5;

-- OR...Same query as above, just doing some nested join optimization per https://dev.mysql.com/doc/refman/8.0/en/nested-join-optimization.html. 
select o.ordernumber, orderdate, status, p.productcode, productname, sum(quantityordered) as 'order qty' from products p
join (orderdetails od, orders o) on od.productCode = p.productCode and od.ordernumber = o.ordernumber 
group by ordernumber, p.productcode   
order by 1, 5;
    
    
#05 Show all orders (order number, order date) with the ‘Total Revenue’ (quantityOrdered * priceEach) for the order. Group by the order number. Order by highest ‘Total Revenue’ to lowest.
-- Returns 326 orderNumber groups with orderNumber 10165 at the top with 67,392.85 in total revenue at the top.  
select o.ordernumber, orderdate, sum(quantityordered * priceeach) as 'Order Total' from orderdetails od -- You can lead with the orders table too. I'm not showing this swapped scenario again, try it out yourself.
	join orders o on od.ordernumber = o.ordernumber
    group by ordernumber
    order by sum(quantityordered * priceeach) desc;
    
    
#06 Show the ‘Total Revenue’ by product (code and name). Show only orders that have been cancelled. Group by the product code. Order by ‘total revenue’ (highest to lowest).
-- Returns 53 groups based on product codes related to orders that have been cancelled.  
select p.productcode, productname, sum(quantityordered * priceeach) as 'Revenue' from products p
	join orderdetails od on p.productcode = od.productcode
    join orders o on od.ordernumber = o.ordernumber
    where status = 'cancelled'
    group by productcode
    order by sum(quantityordered * priceeach) desc;
    
-- OR...Same query as above, just doing some nested join optimization per https://dev.mysql.com/doc/refman/8.0/en/nested-join-optimization.html. 
select p.productcode, productname, sum(quantityordered * priceeach) as 'Revenue' from products p
	join (orderdetails od, orders o) on p.productcode = od.productcode AND od.ordernumber = o.ordernumber
    where status = 'cancelled'
    group by productcode
    order by sum(quantityordered * priceeach) desc;
    
    
#07 Show the ‘Total Revenue’ by customer (customer number and name). Show only orders with a status of resolved or shipped. Group by the customer number. Order by ‘total revenue’ (highest to lowest).
-- Returns 98 customerNumber groups with customerNumber 141 at the top with $715,738.98 in total revenue.  
select c.customernumber, customername, sum(quantityordered * priceeach) as 'Revenue' from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    where status = 'resolved' or status = 'shipped'
    group by c.customernumber
    order by sum(quantityOrdered * priceEach) desc;


#08 Show all orders (number and date) with the product name, quantity ordered, msrp, price each, buy price, the difference between msrp and buy price (‘Potential Profit’), and the difference between price each and buy price (‘Actual Profit’). Show also the percentage of actual profit compared to potential profit (i.e., actual profit divided by the potential profit). Order by this percentage in descending order. 
-- Returns 2996 rows (i.e., no groups in this questions/task) reflecting difference between msrp and buyPrice for 'potential profit', then the difference between priceEach and buyPrice for 'actual profit.'
select o.ordernumber, orderdate, productname, quantityordered, priceeach, buyprice, msrp,
		(msrp-buyprice) as 'potential profit', (priceeach-buyprice) as 'actual profit',  
        round((priceeach-buyprice)/(msrp-buyprice)*100,2) as '% actual profit from potential profit'  from orders o
	join orderdetails od on o.ordernumber = od.ordernumber
    join products p on od.productcode = p.productcode
    order by (priceeach-buyprice)/(msrp-buyprice)*100 desc;
    
-- OR...Same query as above, just using an ORDER BY based on column position numbers and not column names.
select o.ordernumber, orderdate, productname, quantityordered, priceeach, buyprice, msrp,
		(msrp-buyprice) as 'potential profit', (priceeach-buyprice) as 'actual profit',  
        round((priceeach-buyprice)/(msrp-buyprice)*100,2) as '% actual profit from potential profit'  from orders o
join orderdetails od on o.ordernumber = od.ordernumber
join products p on od.productcode = p.productcode
order by 10 desc;
    
    
#09 Show all customers (customer number and name), and total quantity they ordered per product (code and name). Group by the customer number, then group by the product code. Order by the customer number, then by the product code. 
-- Returns 2532 groups (i.e., grouped by customerNumber, then grouped by productCode), with a bunch of productCodes bought by customerNumber 103 showing up first towards the top.   
select c.customernumber, customername, od.productcode, productname, sum(quantityordered) as 'qty ordered' from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    join products p on od.productcode = p.productcode
    group by customernumber, od.productcode
    order by customernumber, od.productcode;
    
-- OR...Same query as above, just doing some nested join optimization per https://dev.mysql.com/doc/refman/8.0/en/nested-join-optimization.html and just using an ORDER BY based on column position numbers and not column names.
select c.customernumber, customername, od.productcode, productname, sum(quantityordered) as 'qty ordered' from customers c
	join (orders o, orderdetails od, products p) on c.customernumber = o.customernumber and o.ordernumber = od.ordernumber and od.productcode = p.productcode
    group by customernumber, od.productcode
    order by 1, 3;
    
    
#10 Show all United States customers (customer number and name), the products (code and name) the customer bought, the product line, and the product text description. Group by the customer number, then group by the product code. Order by the customer number, then by the product code.
-- Returns 851 groups (i.e., grouped by customerNumber, then grouped by productCode), showing a bunch of product codes bought by customerNumber 112 first at the top.  
select c.customernumber, c.customername, p.productcode, productname, pl.productline, textdescription from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    join products p on od.productcode = p.productcode
    join productlines pl on p.productline = pl.productline
    where country = 'USA'
    group by customernumber, productcode
    order by customernumber, productcode;

-- OR...Same query as above, just flipped my leading table and sequence of the tables being applied to inner joins to show you that you get the same results because we are dealing with INNER JOINS.
select c.customernumber, c.customername, p.productcode, productname, pl.productline, textdescription from productlines pl
	join products p on p.productline = pl.productline
    join orderdetails od on od.productcode = p.productcode
    join orders o  on o.ordernumber = od.ordernumber
    join customers c on c.customernumber = o.customernumber
    where country = 'USA'
    group by customernumber, productcode
    order by customernumber, productcode;
    

#11 Show ‘Total Revenue’ by country. Group by the country. Order by the highest to lowest ‘Total Revenue’. Show only shipped orders. Show only countries with a ‘total revenue’ greater than $500,000.
-- Returns 4 country groups with total revenue over $500,000. Only the USA, France, Spain, and Australia meet this search/filter criteria. 
select country, format(sum(quantityordered * priceeach),0) as 'Revenue' from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    where status = 'shipped'
    group by country having sum(quantityordered * priceeach) > 500000
    order by sum(quantityOrdered * priceEach) desc;
    
-- OR...Same query, just returns 21 country groups with total revenue over $500, assuming things are in the 'thousands' place. 
select country, sum(quantityordered * priceeach) as 'Revenue' from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    where status = 'shipped'
    group by country having sum(quantityordered * priceeach) > 500000/1000 -- I threw this example in the mix just in case any of you did this one based on MSRP, buyPrice, priceEach, etc... being in the 'thousands' place (or, something like that for this fake car, planes, ships, etc... database). It does bring in all country groups though where orders were placed.  
    order by sum(quantityOrdered * priceEach) desc;
    
-- Just seeing how many distinct countries we have where orders were placed.
select distinct country from customers c
join orders o using (customerNumber) 
where orderNumber is not NULL;
    

