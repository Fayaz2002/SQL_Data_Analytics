-- =============================================================
-- Create Database and Tables for Data Warehouse Analytics (MySQL)
-- =============================================================

-- Create the new database
CREATE DATABASE DataWarehouseAnalytics;

-- Use the newly created database
USE DataWarehouseAnalytics;

-- Create gold.dim_customers table
CREATE TABLE dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

-- Create gold.dim_products table
CREATE TABLE dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

-- Create gold.fact_sales table
CREATE TABLE fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);

-- ------------------------------------EXPLORATORY DATA ANALYSIS--------------------------------------------           --

-- DATABASE EXPLORATIONS
select * from information_schema.tables where table_schema ='datawarehouseanalytics';

select * from information_schema.columns where table_schema ='datawarehouseanalytics';

-- Explore all the countries our customer come from 
select distinct country as Countries from dim_customers;

-- Explore all categories "The Major Divisions" and "Sub Categories" and "Products"
Select distinct category as Major_Categories , subcategory as Sub_Categories,
product_name as Products from dim_products
order by Major_categories;

-- Date Exploration (Time Spans)
-- Find the Date of the first and the last order and How many years of sale are available
Select Max(Order_date) as Latest_Order ,
 Min(Order_date) as Oldest_Order,
 timestampdiff(year,Min(Order_date),Max(Order_date)) as Time_Span_in_Years
 from fact_sales;

-- Find the Youngest and the Oldest Customers
select Max(birthdate) as Oldest_Customer, Min(Birthdate) as Youngest_Customer, 
timestampdiff(Year,Min(Birthdate),Max(birthdate)) as AgeDifference,
timestampdiff(year,Max(birthdate),now()) as Youngest_Age,
timestampdiff(year,Min(birthdate),now()) as Oldest_Age
from dim_customers;

-- Details of the Youngest and the Oldest Customers
select * from (select * ,
max(birthdate) over() as Oldest,
min(birthdate) over() as youngest
from dim_customers)t
where birthdate in (Oldest,Youngest);

-- Measures Exploration
-- Find the Total Sales 
select 	sum(sales_amount) as Total_sales from fact_sales;

-- find How many items are sold 
select 	sum(sales_amount) as Total_sales , sum(quantity) as Items_sold from fact_sales;

-- Find the Average Selling Price 
select avg(price) as Average_Selling_price, 
sum(sales_amount) as Total_sales , 
sum(quantity) as Items_sold from fact_sales;

-- Find the Total Number of orders
select avg(price) as Average_Selling_price, 
count(order_number) as Total_Orders,
sum(sales_amount) as Total_sales , 
sum(quantity) as Items_sold from fact_sales;

-- Find the Total Number of Products
select avg(price) as Average_Selling_price, 
count(order_number) as Total_Orders,
sum(sales_amount) as Total_sales , 
sum(quantity)as Items_sold
,(select count(product_key) from dim_products) as Total_Products from fact_sales;

-- Find the Total number of Customers
select avg(price) as Average_Selling_price, 
count(order_number) as Total_Orders,
sum(sales_amount) as Total_sales , 
sum(quantity)as Items_sold
,(select count(product_id) from dim_products) as Total_Products,
(select count(customer_id) from dim_customers) as Total_Customers,
(select Count(distinct customer_key) from fact_sales where order_date is not null)as Customers_with_Orders 
 from fact_sales;
 
 -- Find the total Number of customer who placed an order
select avg(price) as Average_Selling_price, 
count(distinct order_number) as Total_Orders,
sum(sales_amount) as Total_sales , 
sum(quantity)as Items_sold
,(select count(distinct product_id) from dim_products) as Total_Products,
(select count(distinct customer_id) from dim_customers) as Total_Customers,
(select Count(distinct customer_key) from fact_sales where order_date is not null)as Customers_with_Orders 
 from fact_sales;
 
 -- Generate a report that shows all keu metircs of thr buisness
 create table Aggregated_Table as(
select "Average Sales" as Measure_Name ,avg(price) as Measure_Value from fact_sales
 Union all
select "Order Count" as Measure_Name, count(distinct order_number) as Measure_Value from fact_sales
union all
select "Total Sales" as Measure_name ,sum(sales_amount) as Measure_Value from fact_sales
union all
select "Total Items Sold" as Measure_Name ,sum(quantity)as Measure_Value from fact_sales
union all
select "Total Products" as Measure_Name,count(distinct product_id) as Measure_Value from dim_products
Union all
select "Total customers" as Measure_Name ,count(distinct customer_id) as Measure_Value from dim_customers
union all
select "Customers with Orders " as Measure_Name ,Count(distinct customer_key) as Measure_Value from fact_sales where order_date is not null);

select * from aggregated_table;

-- Magnitude oe Dimend=sion Exploration

-- Fid the total customers by country 
select country , count(distinct customer_id) as customers from dim_customers group by country;

-- Find total customers by gender
select Gender , count(distinct customer_id) as customers from dim_customers group by Gender;

-- Find total products by category
select Category,count(product_id) as products from dim_products group by Category;

-- whats the average cost of each category 
select category ,avg(Cost) as average_cost from dim_products group by category;

-- whats the total revenue generated for each category
select  p.category ,
sum(sales_amount) as Revenue_per_category
from dim_products p left join fact_sales fs   on fs.product_key = p.product_key
group by p.category;

-- Find the total revenue gennerated by each customers 
select distinct c.customer_id,fs.customer_key ,concat(c.first_name," ",c.last_name) as full_Name
,sum(fs.sales_amount)  as Revenue_per_customer
from fact_sales fs left join dim_customers c
on fs.customer_key=c.customer_key
group by c.customer_id,fs.customer_key ,
concat(c.first_name," ",c.last_name)  order by sum(sales_amount) desc;

-- whats the distribution of sold items accross countries
select distinct c.country , 
sum(fs.quantity) as quantity_per_country 
from dim_customers c left join fact_sales fs on 
c.customer_key =fs.customer_key
 group by country;
 
 -- Ranking Analysis
 
 -- Which 5 products generate highest reveue 
select * from(
select p.product_name ,fs.product_key ,sum(fs.sales_amount) as sales,
dense_rank()over(order by sum(fs.sales_amount) desc) as ranks 
from fact_sales fs left join dim_products p
on fs.product_key = p.product_key
 group by p.product_name ,fs.product_key)y
 where ranks < 6;
 
 -- which 5 products are worst performing with respect to sales 
 select * from(
select p.product_name ,fs.product_key ,sum(fs.sales_amount) as sales,
dense_rank()over(order by sum(fs.sales_amount)) as ranks 
from fact_sales fs left join dim_products p
on fs.product_key = p.product_key
 group by p.product_name ,fs.product_key)y
 where ranks < 6;
 
 -- which are the top categories in terms of sales ?
 select p.category,
 dense_rank()over(order by sum(fs.sales_amount) desc) as ranks,
 sum(fs.sales_amount) as total_sales from
 fact_sales fs left join dim_products p on
 fs.product_key=p.product_key
 group by p.category;
 
 -- find top 10 customers who have generated the highest revenue  
 select * from(select c.first_name,
 sum(fs.sales_amount) as Revenue ,
 dense_rank()over(order by  sum(fs.sales_amount) desc) as Top_Customers
 from fact_sales fs left join  dim_customers c on
 fs.customer_key = c.customer_key
 group by c.first_name)t
 where top_customers < 11;
 
 -- ---------------------------------------ADVANCED DATA ANALYTICS------------------------------------------
 
 -- Change over Time Trends
 select year(order_date) as years, month(order_date) as months,
 sum(sales_amount) as total_sales_per_year,
 avg(sales_amount) as Average_sales_per_year,
 sum(quantity) as total_items_sold_per_year,
 count(distinct customer_key) as total_customers_per_year
 from fact_sales where order_date is not null 
 group by year(order_date),month(order_date)
 order by year(order_date),month(order_date);
 
 -- How many new customers were added each year 
 select year(create_date) as years
 , count(create_date) as new_customers
 from dim_customers group by year(create_date);
 
-- calculate the total sales per month and the running total overtime 
select  distinct year(order_date) as years ,month(order_date)  as months,
sum(sales_amount) over(partition by year(order_date),month(order_date )) as sales_month,
sum(sales_amount) over(partition by year(order_date) order by year(order_date),month(order_date )) as sales_overtime,
avg(sales_amount) over(partition by year(order_date),month(order_date )) as avg_month,
avg(sales_amount) over(partition by year(order_date) order by year(order_date),month(order_date )) as avg_overtime
from fact_sales;

 -- Analyze the yearly performance of products by comparing each products sales to both its
 -- average sales performance and previous year sales (Year over Year Analysis)
with cte_Current_sales as( 
select year(fs.order_date) as Order_Year, p.Product_name ,
sum(sales_amount) as Current_Yearly_sales
from fact_sales fs left join dim_products p on
fs.product_key=p.product_key
group by year(fs.order_date) ,p.Product_name
order by p.Product_name)

select cs.*,
avg(current_yearly_sales)over(partition by product_name) as Average,
(current_yearly_sales - avg(current_yearly_sales)over(partition by product_name)) as Diff_CY_AVG,
Case when (current_yearly_sales - avg(current_yearly_sales)over(partition by product_name)) > 0 Then "Above Average"
	when (current_yearly_sales - avg(current_yearly_sales)over(partition by product_name)) < 0 then "Below Average"
    end as Average_Flag,
lag(current_yearly_sales)over(partition by product_name order by order_year) as Previous_yearly_sales,
(current_yearly_sales - lag(current_yearly_sales)over(partition by product_name order by order_year)) as Diff_CY_PS,
Case when (current_yearly_sales - lag(current_yearly_sales)over(partition by product_name order by order_year))> 0 then "High Performace"
     when (current_yearly_sales - lag(current_yearly_sales)over(partition by product_name order by order_year))<0 Then "Low Performance"
     end as Performance_Flag
from cte_Current_sales cs;

-- Part to whole Analysis
-- which categories the most to overal sales
with  categories as
(
select p.category, sum(fs.sales_amount) as sales_per_category
from dim_products p left join fact_sales fs 
on p.product_key=fs.product_key
group by p.category
)
, overall as(
select c.*, 
sum(sales_per_category)over() as overall from categories c)

select o.*,
concat((sales_per_category/overall)*100,"%") as contribution
from overall o;

-- Data Segmentation
-- segment products into ranges above or below average and count how many products fall into each segement 
with cte as
(
select *,
case when cost = maximum then "Alpha Value Product"
     when cost = Minimum then "Beta Value Product"
     when cost > average then "High Value Product"
     when cost < average then "Low Value Product"
     End as Value_Category from(
select distinct product_name , cost ,
avg(cost) over() as average,
max(cost) over() as maximum,
min(cost) over() as minimum
from dim_products)t)

select *, count(*) over(partition by Value_Category) as Product_count
 from cte order by value_category;
 
 -- segment products into cost ranges and count how many products fall into each segement
 select *, count(*) over(partition by Ranges) Product_Count from(
 select distinct product_name , cost ,
 case when cost < 100 then "Below 100"
      when cost between 100 and 500 then "100-500"
      when cost between 500 and 1000 then "500-100"
      else "Above 1000"
      end as Ranges
from dim_products order by cost desc)t;

 with cte as
 (
 select *, count(*) over(partition by Ranges) Product_Count from(
 select distinct product_name , cost ,
 case when cost < 100 then "Below 100"
      when cost between 100 and 500 then "100-500"
      when cost between 500 and 1000 then "500-100"
      else "Above 1000"
      end as Ranges
from dim_products order by cost desc)t
)
select Ranges , count(product_name)  as counts
from cte group by Ranges;

-- group customers into 3 segment (VIP/Regular/New) based on their spending behaviour  
with cte as(
select * , 
case when months_spent >= 12 and money_spent > 5000 then "VIP"
     When months_spent >= 12 and money_spent <= 5000 then "Regular"
     Else "New"
     end as Segments
from(
select distinct customer_key ,
timestampdiff(month,min(order_date),max(order_date)) as months_spent,
sum(sales_amount) as money_spent
from fact_sales group by customer_key)t)

 select segments , count(distinct customer_key) as counts from cte group by segments;
 
/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

Create view Customer_report as 
(
with Base_Query as
(
select fs.*,c.customer_id,concat(c.first_name," ",c.last_name) as Full_Name ,
timestampdiff(year,c.birthdate,now()) as Age,c.gender,c.country,c.create_date
from fact_sales fs left join dim_customers c on
fs.customer_key=c.customer_key
where order_date is not null)
, Aggregation as
(
select customer_id,Full_Name ,
 Age,gender,
 count(distinct order_number)as Total_Orders,
 sum(sales_amount)as Total_Sales,
 count(quantity) as Total_Quantity,
 count(distinct Product_key)as Total_Products,
 timestampdiff(month,min(order_date),max(order_date)) as months_spent,
 max(order_date) as Last_order
 from Base_Query
 group by customer_id,Full_Name ,
 Age,gender)
 
 select a.*, 
 timestampdiff(month ,last_order,now()) as Recency,
 case when months_spent = 0 then Total_Sales else (Total_sales/months_spent)end as Average_Monthly_Sales,
 case when total_sales = 0 then 0 else (Total_sales/Total_Orders) end as Average_Order_Value,
 case when age < 30 then "Below 30"
      when age between 30 and 50 then "30-50"
      when age > 50 then "Above 50"
      end as Age_Range,
case when months_spent >= 12 and total_sales > 5000 then "VIP"
     When months_spent >= 12 and Total_sales <= 5000 then "Regular"
     Else "New"
     end as Segments
 from Aggregation a
 );

select * from customer_report;

/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
create view product_details as
(
with product_cte as
(
select fs.*, p.product_name,p.category,p.subcategory,p.cost
from dim_products p right join fact_sales fs 
on p.product_key=fs.product_key
order by product_name)
, aggregation_product as 
(
select product_name,category,subcategory,
count(distinct order_number) as Total_orders,
sum(sales_amount) as Total_sales,
sum(quantity) as Total_quantity,
count(distinct customer_key) as Total_Customers,
timestampdiff(month,min(order_date),max(order_date)) as Life_span,
MAX(order_date) as Lastorder
 from  product_cte group by product_name,category,subcategory)
 
 select ap.*,
 timestampdiff(month,lastorder,now()) as Recency,
 (Total_sales/Total_orders) as Average_order_revenue,
 (Total_sales/life_span) as Average_monthly_reveue,
 case when total_sales < 15000 then "Low Performace"
      when total_sales between 15000 and 50000 then "Mid Performace"
      else "High Performace"
      end as Performace_Flag
 from aggregation_product ap
 );
select * from product_details;