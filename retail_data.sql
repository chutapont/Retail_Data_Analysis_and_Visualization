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