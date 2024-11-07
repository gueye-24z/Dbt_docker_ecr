{{ config(
    enabled=true
) }}

WITH authors_to_insert AS (
    SELECT 
        DISTINCT author
    FROM {{ ref('silver_comments') }}
    WHERE author IS NOT NULL
),

author_ids AS (
    SELECT
        row_number() OVER (ORDER BY author) AS author_id,
        author
    FROM authors_to_insert
)

SELECT * FROM author_ids