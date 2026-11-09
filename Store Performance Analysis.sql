### Store performance Analysis
# Problem statement 1: Which are the top 1O stores in terms of Incremental Revenue IR generated from the promotions?
# Solution Code:
SELECT s.store_id, 
	SUM(f.base_price * f.`quantity_sold(after_promo)`)
    - SUM(f.base_price * f.`quantity_sold(before_promo)`) AS ir
FROM dim_stores s
JOIN fact_events f
ON s.store_id = f.store_id    
GROUP BY s.store_id  
ORDER BY ir DESC
LIMIT 10 ; 

# Problem statement 2: Which are the bottom 10 stores when it comes to Incremental Sold Units (ISU) during the promotional period?
# Solution Code:
SELECT 
	s.store_id, 
	SUM(f.`quantity_sold(after_promo)`)
    - SUM(f.`quantity_sold(before_promo)`) AS isu
FROM dim_stores s
JOIN fact_events f
ON s.store_id = f.store_id    
GROUP BY s.store_id  
ORDER BY isu ASC
LIMIT 10; 

# Problem Statement 3: Calculate total incremental revenue for each city and ranks cities by performance.
# Solution Code:
SELECT
    s.city,
    COUNT(DISTINCT s.store_id) AS total_stores,
    SUM(f.base_price * f.`quantity_sold(after_promo)`) 
    - SUM(f.base_price * f.`quantity_sold(before_promo)`) AS incremental_revenue
FROM dim_stores s
JOIN fact_events f
    ON s.store_id = f.store_id
GROUP BY s.city
ORDER BY incremental_revenue DESC;

SELECT
    s.store_id,
    s.city,
    SUM(f.base_price * f.`quantity_sold(after_promo)`) 
    - SUM(f.base_price * f.`quantity_sold(before_promo)`) AS incremental_revenue
FROM dim_stores s
JOIN fact_events f
    ON s.store_id = f.store_id
GROUP BY s.store_id, s.city
ORDER BY incremental_revenue DESC
LIMIT 10;