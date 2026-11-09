### Product and Category Analysis:
# Problem Statement 1: Which product categories saw the most significant lift in sales from the promotions? 
# Solution Code:
WITH cte AS (
	SELECT 
		p.category, 
		SUM(`quantity_sold(after_promo)`*base_price) AS sales_ap, 
		SUM(`quantity_sold(before_promo)`*base_price) AS sales_bp 
	FROM fact_events f
	JOIN dim_products p
		ON f.product_code = p.product_code
	GROUP BY p.category    
)
SELECT *, sales_ap-sales_bp AS sales_lift 
FROM cte
ORDER BY sales_lift DESC;

# Problem Statement 2: Are there specific products that respond exceptionally well or poorly to promotions?
# Solution Code: 1 highest_sales_lift
WITH cte AS (
	SELECT
		p.product_name,
		p.category, 
		SUM(`quantity_sold(after_promo)`*base_price) AS sales_ap, 
		SUM(`quantity_sold(before_promo)`*base_price) AS sales_bp 
	FROM fact_events f
	JOIN dim_products p
		ON f.product_code = p.product_code
	GROUP BY p.product_name, p.category    
)
SELECT *, sales_ap-sales_bp AS highest_sales_lift 
FROM cte
ORDER BY highest_sales_lift DESC;

# Solution Code: 2 Lowest_sales_lift
WITH cte AS (
	SELECT
		p.product_name,
		p.category, 
		SUM(`quantity_sold(after_promo)`*base_price) AS sales_ap, 
		SUM(`quantity_sold(before_promo)`*base_price) AS sales_bp 
	FROM fact_events f
	JOIN dim_products p
		ON f.product_code = p.product_code
	GROUP BY p.product_name, p.category    
)
SELECT *, sales_ap-sales_bp AS lowest_sales_lift 
FROM cte
ORDER BY lowest_sales_lift ASC;

# Problem Statement 3: What is the correlation between product category and promotion type effectiveness?
# Solution Code:
WITH cte AS (
	SELECT
		p.product_name,
		f.promo_type, 
		SUM(`quantity_sold(after_promo)`*base_price) AS sales_ap, 
		SUM(`quantity_sold(before_promo)`*base_price) AS sales_bp 
	FROM fact_events f
	JOIN dim_products p
		ON f.product_code = p.product_code
	GROUP BY p.product_name, f.promo_type   
)
SELECT *, sales_ap-sales_bp AS sales_lift
FROM cte
ORDER BY sales_lift DESC;
