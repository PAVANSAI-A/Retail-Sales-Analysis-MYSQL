# Retail-Sales-Analysis-MYSQL
MySQL-based retail sales analysis covering data cleaning, null checks, date filtering, category-wise sales insights, customer age analysis, high-value transactions, gender-wise counts, monthly ranking using window functions, top customer identification, unique customer counts, and shift-based order classification using CASE logic.


# 🛒 Retail Sales Analysis (MySQL)

This project contains MySQL queries used to analyze a retail sales dataset.  
The focus is on data cleaning, exploratory analysis, sales insights, customer 
segmentation, and analytical SQL using window functions and CASE expressions.

---

## 📁 Dataset Description

The dataset includes retail transaction-level details:  
- `transactions_id`  
- `sale_date`, `sale_time`  
- `customer_id`, `gender`, `age`  
- `category`  
- `quantiy`, `price_per_unit`, `cogs`, `total_sale`  

---

## 🔍 Key Analysis Performed

### **1️⃣ Data Cleaning & NULL Checks**
```sql
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
    
SELECT * FROM retail_sales;
```
Identified missing or incomplete values across all critical fields.

### **2️⃣ Daily Sales Extraction**
```sql
SELECT * FROM retail_sales 
WHERE sale_date='2022-11-05';
```
Retrieved all sales made on a specific date (e.g., 2022-11-05).

### **3️⃣ Category-Specific Filtering**
```sql
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

---without cte

select * from retail_sales
	where category='clothing'
    and
    month(sale_date)=11
    and
    quantiy > 3;
```
Extracted Clothing category sales where quantity > 3 in November 2022

(using CTEs and a simplified version).

### **4️⃣ Category-level Total Sales**
```sql
select category, sum(total_sale) as total_cat_sale from retail_sales
group by category order by total_cat_sale desc;
```
Computed total revenue generated per category.

### **5️⃣ Customer Age Insights**
```sql
select round(avg(age),0) from retail_sales
where category='Beauty';
```
Found average age of Beauty category customers.

### **6️⃣ High-Value Transaction Detection**
```sql
select * from retail_sales
where total_sale > 1000;
```
Listed all transactions where total sale exceeded 1000.

### **7️⃣ Gender-wise Transaction Counts**
```sql
select category, gender, count(*) as total_tra from retail_sales
group by category, gender order by 1;
```
Calculated number of transactions by gender within each category.

### **8️⃣ Monthly Performance Ranking**
```sql
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
```

Used window functions to identify the best-performing month of each year  
based on average sales.

### **9️⃣ Top Customers by Revenue**
```sql
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
```
Ranked customers based on total sales and extracted the top 5.

### **🔟 Unique Customer Count per Category**
```sql
select category, count( distinct customer_id)
from retail_sales 
group by 1;
```
Counted distinct customers in each product category.

### **1️⃣1️⃣ Shift-Based Sales Classification**
```sql
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
```
Used CASE logic to classify transactions into:  
- Morning (< 12:00)  
- Afternoon (12:00–17:00)  
- Evening (> 17:00)

Then counted total orders in each shift.

---

## 🧠 SQL Concepts Demonstrated

- Data Cleaning  
- Filtering & Conditional Logic  
- CTEs (WITH Clause)  
- Window Functions (`RANK`, `PARTITION BY`)  
- Aggregate Functions (`SUM`, `AVG`, `COUNT`)  
- Date & Time Functions  
- CASE Expressions  
- Grouping & Ordering  

---

## 📌 Purpose

This project highlights practical SQL analysis skills applied to a real-world retail dataset, demonstrating the ability to clean data,
