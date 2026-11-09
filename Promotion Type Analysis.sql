### Promotion Type Analysis:
# Problem Statement 1: What are the top 2 promotion types that resulted in the highest Incremental Revenue?
# Solution Code:
SELECT f.promo_type,
	SUM(f.base_price * f.`quantity_sold(after_promo)`) 
    - SUM(f.base_price * f.`quantity_sold(before_promo)`) AS incremental_revenue
FROM fact_events f
GROUP BY f.promo_type
ORDER BY incremental_revenue DESC
LIMIT 2;

# Problem Statement 2: What are the bottom 2 promotion types in terms of their impact on Incremental Sold Units?    
# Solution Code:
SELECT f.promo_type	,SUM(f.`quantity_sold(after_promo)`)
    - SUM(f.`quantity_sold(before_promo)`) AS isu
FROM fact_events f
GROUP BY f.promo_type
ORDER BY isu ASC
LIMIT 2;
    
# Problem Statement 3: Is there a significant difference in the performance of 
# discount-based promotions versus BOGOF (Buy One Get One Free) or cashback promotions?  
# Solution Code:
SELECT 
	CASE 
		WHEN promo_type = 'BOGOF' THEN 'BOGOF'
        WHEN promo_type LIKE '%Cashback%' THEN 'Cashback'
        ELSE 'Discount-based'
    END AS promotion_group,
    SUM(`quantity_sold(after_promo)`)
	- SUM(`quantity_sold(before_promo)`) AS isu
FROM fact_events
GROUP BY promotion_group
ORDER BY isu DESC;

# Problem Statement 4: Which promotions strike the best balance between Incremental Sold Units and maintaining healthy margins? 
# Solution Code:
SELECT 
	promo_type, 
	SUM(`quantity_sold(after_promo)`)
	- SUM(`quantity_sold(before_promo)`) AS isu,
	SUM(base_price * `quantity_sold(after_promo)`)
	- SUM(base_price * `quantity_sold(before_promo)`)
	AS incremental_revenue
FROM fact_events
GROUP BY promo_type
ORDER BY isu DESC;
