{{ config(
    materialized='incremental',
    unique_key='id',
    enabled=true
) }}

WITH sentiment_analysis AS (
    SELECT
        id,
        COMMENT_ID_FROM_SOURCE,
        review_title,
        review_text,
        review_date,
        (SELECT author_id FROM {{ ref('dim_author') }} WHERE author_name = author) AS author_id,
        (SELECT date_id FROM {{ ref('dim_date') }} WHERE review_date = review_date) AS date_id,
        -- Analyse des sentiments en utilisant la fonction de Snowflake
        CASE 
            WHEN SYSTEM$SENTIMENT(review_text) > 0 THEN 'Positif'
            WHEN SYSTEM$SENTIMENT(review_text) < 0 THEN 'Négatif'
            ELSE 'Neutre'
        END AS sentiment
    FROM {{ ref('silver_comments') }}
)

SELECT
    id,  -- Identifiant unique auto-incrémental de la couche Silver
    COMMENT_ID_FROM_SOURCE,
    review_title,
    review_text,
    date_id,       -- Clé étrangère vers dim_date
    author_id,     -- Clé étrangère vers dim_author
    sentiment,
    CURRENT_DATE AS load_date
FROM sentiment_analysis
