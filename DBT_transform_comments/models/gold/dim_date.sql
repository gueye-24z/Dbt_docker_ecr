{{ config(
    enabled=true
) }}

WITH new_dates AS (
    SELECT DISTINCT
        review_date
    from {{ ref('silver_comments') }}
    WHERE review_date IS NOT NULL
),

dates_to_insert AS (
    SELECT 
        row_number() OVER (ORDER BY review_date) AS date_id, 
        review_date,
        EXTRACT(YEAR FROM review_date) AS year,
        EXTRACT(MONTH FROM review_date) AS month,
        EXTRACT(DAY FROM review_date) AS day,
    FROM new_dates
)

SELECT * FROM dates_to_insert