-- Best Categories Analysis
-- This Window function creates a table where you can have the payment and categories together
WITH category_revenue AS ( 
    SELECT
        c.category_id,
        c.name AS category_name,
        SUM(p.amount) AS total_revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.category_id, c.name
),

-- This window function sorts the revenue by categories
with_avg AS (
    SELECT
        cr.*,
        AVG(total_revenue) OVER () AS avg_revenue
    FROM category_revenue AS cr
) 
SELECT *
FROM with_avg 
WHERE total_revenue > avg_revenue
ORDER BY total_revenue DESC;
