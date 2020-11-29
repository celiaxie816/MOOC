
#db_hw2 is the database name for table Region, Product and Sales_Totals.

INSERT INTO db_hw2.Region
(region_id, region_name, super_region_id)
VALUES 
(101, 'North America', null),
(102, 'USA', 101),
(103, 'Canada', 101),
(104, 'USA-Northeast',  102),
(105, 'USA-Southeast',  102),
(106, 'USA-West',  102),
(107, 'Mexico',  101);
select * from db_hw2.Region;

INSERT INTO db_hw2.Product
(product_id, product_name)
VALUES 
(1256, 'Gear-Large'),
(4437, 'Gear-Small'),
(5567, 'Crankshaft'),
(7684, 'Sprocket');
select * from db_hw2.Product;

INSERT INTO db_hw2.Sales_Totals
(product_id, region_id, year, month, sales)
VALUES 
(1256, 104, 2020, 1, 1000),
(4437, 105, 2020, 2, 1200),
(7684, 106, 2020, 3, 800),
(1256, 103, 2020, 4, 2200), 
(4437, 107, 2020, 5, 1700),
(7684, 104, 2020, 6, 750),
(1256, 104, 2020, 7, 1100),
(4437, 105, 2020, 8, 1050), 
(7684, 106, 2020, 9, 600),
(1256, 103, 2020, 10, 1900),
(4437, 107, 2020, 11, 1500),
(7684, 104, 2020, 12, 900);
select * from db_hw2.Sales_Totals;

#Q1 
select  *
       ,case when month between 1 and 3 then 1 
            when month between 3 and 6 then 2
            when month between 6 and 9 then 3
            when month between 9 and 12 then 4
		end as quarter 
from db_hw2.sales_Totals
order by month;

#Q2
select sum(case product_id when 1256 then sales else 0 end) as tot_sales_large_gears,
	   sum(case product_id when 4437 then sales else 0 end) as tot_sales_small_gears,
	   sum(case product_id when 5567 then sales else 0 end) as tot_sales_crankshafts, 
	   sum(case product_id when 7684 then sales else 0 end) as tot_sales_sprockets
from db_hw2.Sales_Totals 
group by year;

#Q3
select * 
 	  ,RANK() over(order by sales desc)sales_rank 
from db_hw2.Sales_Totals;

#Q4
select *
       ,RANK() over (partition by product_id order by sales desc) as product_sales_rank
from db_hw2.Sales_Totals;

#Q5
select *
from 
	(select *
		   ,RANK() over (partition by product_id order by sales desc) as product_sales_rank
	from db_hw2.Sales_Totals
    )a
where product_sales_rank between 1 and 2;

#Q6 
START TRANSACTION;
insert into db_hw2.Region(region_id, region_name, super_region_id) 
VALUES(108, 'Europe', NULL);

SAVEPOINT sales_totals_savepoint;

Insert into db_hw2.Sales_Totals(product_id,region_id, year, month, sales) 
VALUES(7684, 108, '2020', '10', 1500);

COMMIT;

#Q7
CREATE VIEW
db_hw2.Product_Sales_Totals_View AS
select product_id 
      ,year
	  ,sum(sales) as product_sales
      ,sum(sum(case when product_id in (1256, 4437) then sales else 0 end)) over() as gear_sales
from db_hw2.Sales_Totals
group by product_id, year;

#Q8
select product_id
      ,region_id
      ,month
      ,sales
      ,sales / sum(sales) over() * 100 as pct_product_sales
from db_hw2.sales_totals;    

#Q9
select year 
      ,month
      ,sales
      ,lag(sales) over (order by month asc) as prior_month
from db_hw2.Sales_Totals;

#Q10
describe sales.product;



