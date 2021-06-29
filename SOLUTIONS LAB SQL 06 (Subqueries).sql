#LAB SQL 06: Subqueries.
use salesshort;


#Q1: Show all the orders where quantityOrdered is larger than the average quantityOrdered. Show the customerNumber, customerName, orderNumber, sum (quantityOrdered), and average (quantityOrdered). Order by customerName.

# 1) Find order quantity per order.
select sum(quantityOrdered) from orderdetails od
	group by ordernumber;
    
# 2) Find average.
select avg(ordQty) from
	(select sum(quantityOrdered) as OrdQty from orderdetails od
		group by ordernumber) orderQty;
        
# 3) Find orders that are larger than average.
select ordernumber, sum(quantityOrdered) as 'order quantity' from orderdetails od
	group by ordernumber having sum(quantityOrdered) > 
		(select avg(ordQty) from
			(select sum(quantityOrdered) as OrdQty from orderdetails od
			group by ordernumber) orderQty);
            
# 4) Add customer information.
select c.customernumber, c.customername, o.ordernumber, sum(quantityOrdered) as 'order quantity' from orderdetails od
	join orders o on od.ordernumber = o.ordernumber
    join customers c on o.customernumber = c.customernumber
	group by ordernumber having sum(quantityOrdered) > 
		(select avg(ordQty) from
			(select sum(quantityOrdered) as OrdQty from orderdetails od
			group by ordernumber) orderQty);
            
# 5) Add average 'constant value'.
select c.customernumber, c.customername, o.ordernumber, sum(quantityOrdered) as 'order quantity',
	(select avg(ordQty) from
		(select sum(quantityOrdered) as OrdQty from orderdetails od
			group by ordernumber) orderQty) as 'Avg Order Qty'
from orderdetails od
	join orders o on od.ordernumber = o.ordernumber
    join customers c on o.customernumber = c.customernumber
	group by ordernumber having sum(quantityOrdered) > 
		(select avg(ordQty) from
			(select sum(quantityOrdered) as OrdQty from orderdetails od
			group by ordernumber) orderQty)
	order by customername;


#Q2: Show the customer with the most ‘revenue’ (i.e., ‘revenue’ = quanitityOrdered * priceEach). Show the customerNumber, customerName, and ‘revenue’ columns. Make sure that if two or more customers have the same ‘revenue’, both/all ties are listed. 

# 1) Find revenue per customer.
select sum(quantityOrdered * priceeach) from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber;
    
# 2) Find max revenue.
select max(rev) from 
	(select sum(quantityOrdered * priceeach) as rev from customers c
    join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber) custRev;
    
# 3) Find customers with max revenue.
select c.customernumber, customerName, sum(quantityOrdered * priceeach) as rev from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber having sum(quantityOrdered * priceeach) = 
		(select max(rev) from 
			(select sum(quantityOrdered * priceeach) as rev from customers c
				join orders o on c.customernumber = o.customernumber
                join orderdetails od on o.ordernumber = od.ordernumber
                group by c.customernumber) custRev);


#Q3: Show the top three customers based on ‘revenue’. Show the customerNumber, customerName, and ‘revenue’ columns. Make sure that if two or more customers have the same ‘revenue’, both/all ties are listed. 

# 1) Find revenue per customer.
select sum(quantityOrdered * priceeach) from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber;
    
# 2) Order "unique" revenue desc and limit to 3.
select distinct sum(quantityOrdered * priceeach) from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber
    order by sum(quantityOrdered * priceeach) desc
    limit 3;
    
# 3) select minimum.
select min(rev3) from 
	(select distinct sum(quantityOrdered * priceeach) as rev3 from customers c
		join orders o on c.customernumber = o.customernumber
		join orderdetails od on o.ordernumber = od.ordernumber
		group by c.customernumber
		order by sum(quantityOrdered * priceeach) desc
		limit 3) minRev3;
        
# 4) Select orders that are equal or larger than minumum.
select c.customernumber, customerName, sum(quantityOrdered * priceeach) as 'revenue' from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber having sum(quantityOrdered * priceeach) >=
		(select min(rev3) from 
			(select distinct sum(quantityOrdered * priceeach) as rev3 from customers c
				join orders o on c.customernumber = o.customernumber
				join orderdetails od on o.ordernumber = od.ordernumber
				group by c.customernumber
				order by sum(quantityOrdered * priceeach) desc
				limit 3) minRev3)
	order by sum(quantityOrdered * priceeach) desc;


#Q4: Show all customers whose ‘revenue’ is more than 30% above the average ‘revenue’. Show the customerNumber, customerName, ‘revenue,’ and the following calculated field: average revenue + 30% (i.e., 30% above the average ‘revenue’ = average (revenue) * 1.3). Order by customer ‘revenue’ (highest to lowest).

# 1) Find revenue per customer.
select c.customernumber, customername, sum(quantityOrdered * priceeach) from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber;
    
#2) Find average customer revenue.
select avg(revenue) from 
	(select sum(quantityOrdered * priceeach)as revenue from customers c
			join orders o on c.customernumber = o.customernumber
			join orderdetails od on o.ordernumber = od.ordernumber
			group by c.customernumber) rev;
            
#3) Find customers who's revenue is more than 30% over step #2.
select c.customernumber, customername, sum(quantityOrdered * priceeach) as revenue from customers c
	join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber 
		having sum(quantityOrdered * priceeach) > 1.3 * (
			select avg(revenue) from 
				(select sum(quantityOrdered * priceeach)as revenue from customers c
					join orders o on c.customernumber = o.customernumber
					join orderdetails od on o.ordernumber = od.ordernumber
					group by c.customernumber) rev);
                    
#4) Add average revenue * 1.3.
select c.customernumber, customername, sum(quantityOrdered * priceeach) as revenue,
	round((select avg(revenue) from 
		(select sum(quantityOrdered * priceeach)as revenue from customers c
			join orders o on c.customernumber = o.customernumber
			join orderdetails od on o.ordernumber = od.ordernumber
			group by c.customernumber) rev) * 1.3 ,2) as 'avgRev + 30%'
	from customers c
		join orders o on c.customernumber = o.customernumber
		join orderdetails od on o.ordernumber = od.ordernumber
		group by c.customernumber 
			having sum(quantityOrdered * priceeach) > 1.3 * (
				select avg(revenue) from 
					(select sum(quantityOrdered * priceeach)as revenue from customers c
						join orders o on c.customernumber = o.customernumber
						join orderdetails od on o.ordernumber = od.ordernumber
						group by c.customernumber) rev)
		order by sum(quantityOrdered * priceeach) desc;


#Q5: Show the ‘revenue’ per productLine, average quantityInStock per productLine, ‘revenue’ per productCode, and average quantityInStock per productCode. Show the productCode’s ‘revenue’ as a % of the productLine’s ‘revenue’. Order by (1) the productLine and then (2) the  productCode’s ‘revenue’ as a % of the productLine’s ‘revenue’.

 # 1) Show revenue per product line, average quantity in stock per product line.
select pl.productline, sum(quantityOrdered * priceeach)as revenue, 
		avg(quantityInStock) as plAvgQty from orderdetails od
	join products p on od.productCode = p.productCode
	join productlines pl on p.productline = pl.productline
	group by pl.productline;
    
# 2) Show revenue per product and quantity in stock per product.
select pl.productline, p.productcode, sum(quantityOrdered * priceeach)as revenue, 
				quantityInStock from orderdetails od
			join products p on od.productCode = p.productCode
            join productlines pl on p.productline = pl.productline
            group by p.productcode;

# 3) Put these two subqueries together with the outer query.
select pl2.productline, pl2.revenue as 'Productline Revenue', plAvgQty as 'Productline Avg. Qty in Stock', 
	p2.productcode, p2.revenue as 'Product Revenue', quantityInStock as 'Product Qty in Stock',
    round(p2.revenue/pl2.revenue * 100,2) as '% product revenue of productline revenue' from 
		(select pl.productline, sum(quantityOrdered * priceeach)as revenue, 
				avg(quantityInStock) as plAvgQty from orderdetails od
			join products p on od.productCode = p.productCode
			join productlines pl on p.productline = pl.productline
			group by pl.productline) pl2
		join 
		(select pl.productline, p.productcode, sum(quantityOrdered * priceeach)as revenue, 
				quantityInStock from orderdetails od
			join products p on od.productCode = p.productCode
            join productlines pl on p.productline = pl.productline
            group by p.productcode) p2
		on pl2.productline = p2.productline
		order by pl2.productline, p2.revenue/pl2.revenue * 100 desc;