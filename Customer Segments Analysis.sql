/*
SELECT * FROM rental
SELECT * FROM customer
SELECT * FROM payment
SELECT * FROM category
SELECT * FROM language

SELECT
c.customer_id,
c.first_name,
SUM(p.amount)
FROM payment AS p
JOIN customer AS c ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name

*/


-- Customer Segment Analysis
WITH
    max_date AS (
        SELECT
            MAX(rental_date)::date + INTERVAL '2 days' AS as_of_date
        FROM rental
    ),
    customer_totals AS (
        SELECT
            c.customer_id,
            c.first_name || ' ' || c.last_name AS full_name,
            SUM(p.amount) AS total_spent,
            MAX(r.rental_date) AS last_rental_date
        FROM customer AS c
            LEFT JOIN rental AS r ON c.customer_id = r.customer_id
            LEFT JOIN payment AS p ON c.customer_id = p.customer_id
        GROUP BY
            c.customer_id,
            full_name
    ),
    ranked AS (
        SELECT
            ct.*,
            RANK() OVER (ORDER BY total_spent DESC) AS spend_rank,
            COUNT(*) OVER () AS total_customers
        FROM customer_totals ct
    )
SELECT
    r.customer_id,
    r.full_name,
    r.total_spent AS total_spent,
    r.last_rental_date::date,
    --md.as_of_date,
    (md.as_of_date - last_rental_date::date) AS days_since_last_rental,
    CASE
        WHEN EXTRACT(DAY FROM(md.as_of_date - last_rental_date::date)) > 30 THEN 'At Risk'
        WHEN r.spend_rank <= r.total_customers * 0.80 THEN 'Top Tier'
        WHEN r.spend_rank <= r.total_customers * 0.79
        AND r.spend_rank > r.total_customers * 0.30 THEN 'Ocassional'
        ELSE 'Bottom 30%' END AS customer_segment
        FROM ranked r
    CROSS JOIN max_date md
ORDER BY r.full_name






