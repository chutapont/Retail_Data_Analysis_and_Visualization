-- Customer Demographics

--1. Age Group Distribution.
SELECT
	CASE WHEN age < 20 THEN '15-19'
	WHEN age >= 20 AND age < 30 THEN '20-29'
	WHEN age >= 30 AND age < 40 THEN '30-39'
	WHEN age >= 40 AND age < 50 THEN '40-49'
	WHEN age >= 50 AND age < 60 THEN '50-59'
	WHEN age >= 60 THEN '60 or older' END AS age_group,
	COUNT(age) AS age_distribution
FROM retail_data
WHERE age IS NOT NULL
GROUP BY age_group;

--2. Gender Distribution.
SELECT gender, COUNT(gender) AS gender_distribution
FROM retail_data
WHERE gender IS NOT NULL
GROUP BY gender
ORDER BY gender_distribution DESC;

--3. Gender Distribution of Each Age Group.
SELECT	
	CASE WHEN age < 20 THEN '15-19'
	WHEN age >= 20 AND age < 30 THEN '20-29'
	WHEN age >= 30 AND age < 40 THEN '30-39'
	WHEN age >= 40 AND age < 50 THEN '40-49'
	WHEN age >= 50 AND age < 60 THEN '50-59'
	WHEN age >= 60 THEN '60 or older' END AS age_group,
	gender,
	COUNT(gender) AS count_gender
FROM retail_data
WHERE gender IS NOT NULL and age IS NOT NULL
GROUP BY age_group, gender;

--4. Income Level Distribution.
SELECT income, COUNT(income) AS income_distribution
FROM retail_data
WHERE income IS NOT NULL
GROUP BY income;

--5. Customer Segment Distribution.
SELECT customer_segment, COUNT(customer_segment) AS count_customer_segment
FROM retail_data
WHERE customer_segment IS NOT NULL
GROUP BY customer_segment
ORDER BY customer_segment DESC;

--6. Customer Segment Distribution of Each Age Group, ranking from the highest to lowest count within each age group.
SELECT 
	CASE WHEN age < 20 THEN '15-19'
	WHEN age >= 20 AND age < 30 THEN '20-29'
	WHEN age >= 30 AND age < 40 THEN '30-39'
	WHEN age >= 40 AND age < 50 THEN '40-49'
	WHEN age >= 50 AND age < 60 THEN '50-59'
	WHEN age >= 60 THEN '60 or older' END AS age_group,
	customer_segment, COUNT(age)
FROM retail_data
WHERE customer_segment IS NOT NULL AND age IS NOT NULL
GROUP BY customer_segment, age_group
ORDER BY age_group, COUNT(age) DESC;

--7. Age Group Distribution of Each Customer Segment, ranking from the highest to lowest count within each customer segment.
SELECT customer_segment,
	CASE WHEN age < 20 THEN '15-19'
	WHEN age >= 20 AND age < 30 THEN '20-29'
	WHEN age >= 30 AND age < 40 THEN '30-39'
	WHEN age >= 40 AND age < 50 THEN '40-49'
	WHEN age >= 50 AND age < 60 THEN '50-59'
	WHEN age >= 60 THEN '60 or older' END AS age_group, 
	COUNT(age)
FROM retail_data
WHERE customer_segment IS NOT NULL AND age IS NOT NULL
GROUP BY customer_segment, age_group
ORDER BY customer_segment, COUNT(age) DESC;

--8. Transaction Counts By Countries, ranking from the highest to lowest count.
SELECT country, COUNT(country)
FROM retail_data
WHERE country IS NOT NULL
GROUP BY country
ORDER BY COUNT(country) DESC;

-- Purchasing Behaviors

--9. Total Purchases By Age Group, ranking from the highest to lowest purchase.
SELECT	
	CASE WHEN age < 20 THEN '15-19'
	WHEN age >= 20 AND age < 30 THEN '20-29'
	WHEN age >= 30 AND age < 40 THEN '30-39'
	WHEN age >= 40 AND age < 50 THEN '40-49'
	WHEN age >= 50 AND age < 60 THEN '50-59'
	WHEN age >= 60 THEN '60 or older' END AS age_group,
	SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE total_purchases IS NOT NULL AND age IS NOT NULL
GROUP BY age_group
ORDER BY total_purchase DESC;

--10. Total Amount of Spending and Average Spending Per Purchase By Each Customer Segment, ranking from the highest to lowest amount.
SELECT customer_segment, ROUND(SUM(total_amount),-3) AS amount_spent, 				
	ROUND(AVG(amount),2) AS avg_spending_each_time
FROM retail_data
WHERE customer_segment IS NOT NULL
GROUP BY customer_segment
ORDER BY amount_spent DESC;

--11. Total Purchases By Product Category Purchased By the ‘Premium’ Customer Segment, ranking from the highest to lowest purchase.
SELECT product_category, SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE product_category IS NOT NULL 
GROUP BY product_category, customer_segment
HAVING customer_segment = 'Premium'
ORDER BY COUNT(product_category) DESC;

--12. Total Purchases By Product Category Purchased By the ‘Regular’ Customer Segment, ranking from the highest to lowest purchase.
SELECT product_category, SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE product_category IS NOT NULL 
GROUP BY product_category, customer_segment
HAVING customer_segment = 'Regular'
ORDER BY COUNT(product_category) DESC;

--13. Total Purchases By Product Category Purchased By the ‘New’ Customer Segment, ranking from the highest to lowest purchase.

SELECT product_category, SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE product_category IS NOT NULL 
GROUP BY product_category, customer_segment
HAVING customer_segment = 'New'
ORDER BY COUNT(product_category) DESC;

-- Product Sales

--14. Top-performing Product Categories in terms of total purchases, ranking from the highest to lowest purchase.
SELECT product_category, SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE product_category IS NOT NULL
GROUP BY product_category
ORDER BY total_purchase DESC;

--15. Top-performing Product Categories in terms of the total amount of spending by customers, ranking from the highest to the lowest amount.
SELECT product_category, ROUND(SUM(total_amount),-3) AS total_amount_spent
FROM retail_data
WHERE product_category IS NOT NULL 
GROUP BY product_category
ORDER BY total_amount_spent DESC;

--16. Top-performing Product Brands in terms of total purchases, ranking from the highest to lowest purchase.
SELECT product_brand, SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE product_brand IS NOT NULL
GROUP BY product_brand
ORDER BY total_purchase DESC;

--17. Top-performing Product Brands Within Each Product Category in terms of total amount of spending by customers, ranking from the highest to lowest amount.
SELECT product_category, product_brand, SUM(total_purchases) AS total_purchase,
	ROUND(SUM(total_amount),-3) AS total_amount_spent
FROM retail_data
WHERE product_category IS NOT NULL AND product_brand IS NOT NULL
GROUP BY product_category, product_brand
ORDER BY product_category, total_amount_spent DESC;

--18. Top-performing Product Types Within Each Product Brand Under Each Product Category in terms of total purchases, ranking from the highest to lowest purchase.
SELECT product_category, product_brand, product_type, SUM(total_purchases) AS total_purchase
FROM retail_data
WHERE product_category IS NOT NULL AND product_brand IS NOT NULL AND product_type IS NOT NULL
GROUP BY product_category, product_brand, product_type
ORDER BY product_category, product_brand, total_purchase DESC;

-- Customer Satisfaction

--19. Average Ratings Received By Each Product Brand.
SELECT product_brand, ROUND(avg(ratings),1) AS avg_ratings
FROM retail_data
WHERE product_brand IS NOT NULL
GROUP BY product_brand
ORDER BY avg_ratings DESC;

--20. Feedback Counts For Each Product Brand Under the ‘Electronics’ Product Category.
SELECT product_brand, feedback, COUNT(feedback) AS feedback_count
FROM retail_data
WHERE product_brand IS NOT NULL AND feedback IS NOT NULL 
GROUP BY product_brand, feedback, product_category
HAVING product_category = 'Electronics'
ORDER BY product_brand, COUNT(feedback) DESC;

--21. Feedback Counts For Each Product Brand Under the ‘Grocery’ Product Category.
SELECT product_brand, feedback, COUNT(feedback) AS feedback_count
FROM retail_data
WHERE product_brand IS NOT NULL AND feedback IS NOT NULL 
GROUP BY product_brand, feedback, product_category
HAVING product_category = 'Grocery'
ORDER BY product_brand, feedback_count DESC;

--22. Feedback Counts For Each Product Brand Under the ‘Clothing’ Product Category.
SELECT product_brand, feedback, COUNT(feedback) AS feedback_count
FROM retail_data
WHERE product_brand IS NOT NULL AND feedback IS NOT NULL 
GROUP BY product_brand, feedback, product_category
HAVING product_category = 'Clothing'
ORDER BY product_brand, feedback_count DESC;

--23. Feedback Counts For Each Product Brand Under the ‘Books’ Product Category.
SELECT product_brand, feedback, COUNT(feedback) AS feedback_count
FROM retail_data
WHERE product_brand IS NOT NULL AND feedback IS NOT NULL 
GROUP BY product_brand, feedback, product_category
HAVING product_category = 'Books'
ORDER BY product_brand, feedback_count DESC;

--24. Feedback Counts For Each Product Brand Under the ‘Home Decor’ Product Category.
SELECT product_brand, feedback, COUNT(feedback) AS feedback_count
FROM retail_data
WHERE product_brand IS NOT NULL AND feedback IS NOT NULL 
GROUP BY product_brand, feedback, product_category
HAVING product_category = 'Home Decor'
ORDER BY product_brand, feedback_count DESC;

-- Transaction Logistics

--25. Top Chosen Shipping Methods, ranking from the highest to lowest count.
SELECT shipping_method, COUNT(shipping_method)
FROM retail_data
WHERE shipping_method IS NOT NULL
GROUP BY shipping_method
ORDER BY COUNT(shipping_method) DESC;

--26. Top Chosen Payment Methods, ranking from the highest to lowest count.
SELECT payment_method, COUNT(payment_method)
FROM retail_data
WHERE payment_method IS NOT NULL
GROUP BY payment_method
ORDER BY COUNT(payment_method) DESC;

--27. Order Status By Count.
SELECT order_status, COUNT(order_status)
FROM retail_data
WHERE order_status IS NOT NULL
GROUP BY order_status;

----------- END ----------------
