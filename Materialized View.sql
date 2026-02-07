/*
View that holds details of platinum customers 
that haven't rented for the past 60 days 
from the as of fate (current date based on the dataset)
*/

CREATE MATERIALIZED VIEW marketing_targets_vw AS
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        SUM(p.amount) AS total_spent
        FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
),
avg_revenue AS ( 
    SELECT AVG(total_spent) AS avg_amount_spent 
    FROM customer_revenue 
),

platinum_customers AS (
    SELECT cr.*
    FROM customer_revenue cr
    CROSS JOIN avg_revenue ar
    WHERE total_spent >= avg_amount_spent   -- Platinum threshold
),
last_rental AS (
    SELECT
        r.customer_id,
        MAX(r.rental_date) AS last_rental_date
    FROM rental r
    GROUP BY r.customer_id
),
as_of AS (
    SELECT MAX(rental_date)::date + INTERVAL '2 days' AS as_of_date
    FROM rental
)
SELECT
    pc.customer_id,
    pc.first_name,
    pc.last_name,
    pc.email,
    lr.last_rental_date
FROM platinum_customers pc
LEFT JOIN last_rental lr
    ON pc.customer_id = lr.customer_id
CROSS JOIN as_of AS a 
WHERE lr.last_rental_date < (a.as_of_date - INTERVAL '60 days')
   OR lr.last_rental_date IS NULL;



-- DROP MATERIALIZED VIEW marketing_targets_vw
SELECT *
FROM marketing_targets_vw -- to check the contents of the materialized view

REFRESH MATERIALIZED VIEW marketing_targets_vw -- refreshes the materialized view
