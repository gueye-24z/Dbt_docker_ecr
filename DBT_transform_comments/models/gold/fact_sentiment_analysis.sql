{{ config(
    enabled=true
) }}


WITH sentiment_analysis AS (
    SELECT
        id,
        COMMENT_ID_FROM_SOURCE,
        review_title,
        review_text,
        review_date,
        author,
        -- Analyse des sentiments en utilisant la fonction de Snowflake
        CASE 
            WHEN SNOWFLAKE.CORTEX.SENTIMENT(review_text) > 0 THEN 'Positif'
            WHEN SNOWFLAKE.CORTEX.SENTIMENT(review_text) < 0 THEN 'Négatif'
            ELSE 'Neutre'
        END AS sentiment
    FROM {{ ref('silver_comments') }} 
)

SELECT
    id,  -- Identifiant unique auto-incrémental de la couche Silver
    COMMENT_ID_FROM_SOURCE,
    review_title,
    review_text,
    review_date,
    author,    -- Clé étrangère vers dim_author
    sentiment,
    CURRENT_DATE AS load_date
FROM sentiment_analysis
