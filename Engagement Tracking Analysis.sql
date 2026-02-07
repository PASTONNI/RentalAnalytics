-- Engagement tracking Analysis

SELECT
    c.category_id,
    c.name AS category_name,
    ROUND(
        AVG(EXTRACT(day FROM (r.return_date - r.rental_date))), 2
    ) AS avg_rental_duration_days
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE r.return_date IS NOT NULL
GROUP BY c.category_id, c.name
ORDER BY avg_rental_duration_days DESC;
