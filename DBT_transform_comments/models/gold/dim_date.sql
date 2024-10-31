{{ config(
    materialized='table',
    schema='GOLD_SCHEMA',
    enabled=true
) }}

WITH new_dates AS (
    SELECT DISTINCT
        review_date
    from {{ source('silver', 'silver_comments') }}
    WHERE review_date IS NOT NULL
),

existing_dates AS (
    SELECT review_date FROM {{ this }}  -- Récupère les dates déjà présentes dans la dimension
),

dates_to_insert AS (
    SELECT 
        row_number() OVER (ORDER BY review_date) + COALESCE((SELECT MAX(date_id) FROM {{ this }}), 0) AS date_id,
        review_date,
        EXTRACT(YEAR FROM review_date) AS year,
        EXTRACT(MONTH FROM review_date) AS month,
        EXTRACT(DAY FROM review_date) AS day,
        CASE 
            WHEN EXTRACT(DAYOFWEEK FROM review_date) IN (1, 7) THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type
    FROM new_dates
    WHERE review_date NOT IN (SELECT review_date FROM existing_dates)
)

SELECT * FROM dates_to_insert
