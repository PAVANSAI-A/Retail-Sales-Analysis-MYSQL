select * from retail_sales
where 
	transactions_id is null
    or
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR 
	category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs is null
    or
    total_sale is null;
    
SELECT * FROM retail_sales LIMIT 20;

-- WRITE A SQL QUERY TO RETIRIEVE ALL THE COLUMNS FOR SALES MADE ON "2022-11-05'

SELECT * FROM retail_sales 
WHERE sale_date='2022-11-05';

-- RETRIEVE ALL THE TRANSCATIONS WHERE CATEGORY IS CLOTHING AND SOLD MORE THAN 3 IN THE MONTH NOV-2022

WITH CLOTHING_CAT AS(
	SELECT * FROM retail_sales
    WHERE category='Clothing'
),
sale_more3 as(
	SELECT * FROM CLOTHING_CAT
    WHERE quantiy > 3
),
sale_nov as(
	SELECT * FROM sale_more3 
    where month(sale_date)=11
    
)

select * from sale_nov order by quantiy desc;

select * from retail_sales
	where category='clothing'
    and
    month(sale_date)=11
    and
    quantiy > 3;
    
-- write sql to calculate the total sales (total_sale) for each category

select category, sum(total_sale) as total_cat_sale from retail_sales
group by category order by total_cat_sale desc;

-- find the avg age of customers who purchased items from the 'beauty' category

select round(avg(age),0) from retail_sales
where category='Beauty';

-- find all the transcations where total_sale is greater than 1000

select * from retail_sales
where total_sale > 1000;

-- find the total number of transactions (transactions_id) made by each gender in each catefory

select category, gender, count(*) as total_tra from retail_sales
group by category, gender order by 1;

-- calculate avg sale for each month. find out best selling month in each year.alter

select * from (
select 
	year(sale_date) as y1, 
    month(sale_date) as m1, 
    avg(total_sale) as avg_t,
    rank() over(partition  by year(sale_date) order by avg(total_sale) desc) as ranks
    from retail_sales
group by y1, m1 order by y1, avg_t desc
) as t1
where ranks=1;

-- find the top 5 customers based on the highest total sales

select * from (
select 
	customer_id, 
	sum(total_sale) as total_sale_cust,
    rank() over( order by sum(total_sale) desc) as ranks
	from retail_sales
	group by customer_id 
) as t1
where ranks < 6
order by  total_sale_cust desc;


-- find the number of unique customers who purchased items from each category

select category, count( distinct customer_id)
from retail_sales 
group by 1;

-- sql query to create each shift and number of orders ( ex: morning <12 , afternoon b/w 12 & 17, evening >17)
select shift,count(transactions_id) from(
select * ,
case
	when hour(sale_time) < 12 then 'morning'
    when hour(sale_time) between 12 and 17 then 'afternoon'
    when hour(sale_time) > 17 then 'evening'
end as shift
from retail_sales
) as t1
group by shift;




