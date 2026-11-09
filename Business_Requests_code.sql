# Problem statemen 1: Provide a list of products with a base price greater than 500 and 
# that are featured in promo type of 'BOGOF' (Buy One Get One Free).

# Solution Code:
SELECT p.product_name
FROM dim_products p
JOIN fact_events f
	ON P.product_code = f.product_code
WHERE f.base_price > 500
	AND f.promo_type = 'BOGOF';

# Problem statement 2: Generate a report that provides an overview of the number of stores in each city. 	
# The results will be sorted in descending order Of store counts allowing us to identify the cities with the highest store presence.
	
# Solution Code:	
SELECT city,
	   COUNT(store_id) AS store_count
FROM dim_stores 	
GROUP BY city	
ORDER BY store_count DESC;

# Problem Statement 3: Generate a report that displays each campaign along with the total revenue generated before and after the campaign? 	
	
# Solution Code:	
SELECT c.campaign_name,	 
    SUM(f.base_price * f.`quantity_sold(before_promo)`)/1000000 AS total_revenue_before_promo,	
    SUM(f.base_price * f.`quantity_sold(after_promo)`)/1000000 AS total_revenue_after_promo	
FROM dim_campaigns c	
JOIN fact_events f	
ON c.campaign_id = f.campaign_id	
GROUP BY c.campaign_name;

# Problem Statement 4: Produce a report that calculates the Incremental Sold Quantity (ISU%) for each	
# category during the Diwali campaign. Additionally	 provide rankings for the categories based on their ISU%. 
	
# Solution Code:	
SELECT p.category,	 
        ((SUM(f.`quantity_sold(after_promo)`) 	
        - SUM(f.`quantity_sold(before_promo)`))	
        / SUM(f.`quantity_sold(before_promo)`)) * 100 AS isu_pct,	
		RANK() OVER (	
        ORDER BY(	
            (SUM(f.`quantity_sold(after_promo)`)	
            - SUM(f.`quantity_sold(before_promo)`))	
            / SUM(f.`quantity_sold(before_promo)`)	
        ) DESC	
	) AS category_rank	
FROM dim_products p	
JOIN fact_events f	
JOIN dim_campaigns c	
ON c.campaign_id = f.campaign_id	
ON p.product_code = f.product_code	
WHERE c.campaign_name = "Diwali" 	
GROUP BY p.category;	
	
# Problem statement 5: Create a report featuring the Top 5 products	 ranked by Incremental Revenue Percentage (IR%)	
# across all campaigns. The report will provide essential information including product name	 category	 and ir%.   
		
# Solution Code: 		
WITH cte1 as (		
	SELECT p.product_name AS product_name,
		   P.category AS Product_category, 	 
		((SUM(f.base_price * f.`quantity_sold(after_promo)`) 		
        - SUM(f.base_price * f.`quantity_sold(before_promo)`))		
        /SUM(f.base_price * f.`quantity_sold(before_promo)`)* 100  		
        ) AS ir_pct		
	FROM dim_products p		
	JOIN fact_events f		
	ON p.product_code = f.product_code		
	GROUP BY p.product_name, Product_category	
),		
cte2 AS (		
	SELECT 		
		product_name,	 	
        Product_category,	 	
        ir_pct,		
		RANK() OVER (ORDER BY ir_pct DESC) AS irp_rank		
	FROM cte1		
)				
SELECT 		
	product_name,	 	
    Product_category,	 	
    ir_pct		
FROM cte2		
WHERE irp_rank <= 5		
ORDER BY irp_rank; 		