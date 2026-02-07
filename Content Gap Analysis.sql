-- Content Gap Analysis
WITH all_combinations AS (
    SELECT 
        c.category_id,
        c.name AS category_name,
        s.store_id
    FROM category c
    CROSS JOIN store s
),

rentals_per_category_store AS (
    SELECT
        fc.category_id,
        i.store_id,
        COUNT(r.rental_id) AS rental_count
    FROM film_category fc
    JOIN inventory i ON fc.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY fc.category_id, i.store_id
)

SELECT
    ac.store_id,
    ac.category_id,
    ac.category_name
FROM all_combinations ac
LEFT JOIN rentals_per_category_store rcs
    ON ac.category_id = rcs.category_id
   AND ac.store_id = rcs.store_id
WHERE COALESCE(rcs.rental_count, 0) = 0
ORDER BY ac.store_id, ac.category_name;


/*
-- N.B CHECK
SELECT COUNT(*) FROM category;
SELECT COUNT(*) FROM store;
SELECT COUNT(*) FROM (
    SELECT c.category_id, s.store_id
    FROM category c CROSS JOIN store s
) AS all_pairs;
SELECT COUNT(DISTINCT (fc.category_id, i.store_id))
FROM film_category fc
JOIN inventory i ON fc.film_id = i.film_id;
*/