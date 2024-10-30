{{ config(
    materialized='incremental',
    unique_key='author_id',
    schema='GOLD_SCHEMA',
    enabled=true
) }}

WITH new_authors AS (
    SELECT DISTINCT
        author AS author_name  -- Nom de l'auteur
    FROM {{ ref('silver_comments') }}
),

existing_authors AS (
    SELECT author_name FROM {{ this }}  -- Récupère les auteurs déjà présents dans la dimension
),

authors_to_insert AS (
    SELECT 
        row_number() OVER (ORDER BY author_name) + COALESCE((SELECT MAX(author_id) FROM {{ this }}), 0) AS author_id,
        author_name
    FROM new_authors
    WHERE author_name IS NOT NULL
    AND author_name NOT IN (SELECT author_name FROM existing_authors)
)

SELECT * FROM authors_to_insert
