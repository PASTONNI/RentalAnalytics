-- Performance Metrics
-- get the customer,
-- get the average days between rentals
--SELECT * FROM rental 

WITH rental_gaps AS (
  SELECT *,
   LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date ) AS previous_rental_date
    FROM rental
)
SELECT
    rg.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    AVG(rental_date::DATE - previous_rental_date::DATE) AS avg_days_between_rentals,
    CONCAT(ROUND(AVG(rental_date::DATE - previous_rental_date::DATE))::TEXT,' days') AS avg_days_btw_rentals_in_days
FROM rental_gaps AS rg
    LEFT JOIN customer AS c ON rg.customer_id = c.customer_id
GROUP BY
    rg.customer_id,
    full_name
ORDER BY avg_days_between_rentals DESC