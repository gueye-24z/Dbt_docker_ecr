{{ config(
    materialized='table',
    enabled=true
) }}

with judgeme_reviews as (
    select 
        cast(COMMENT_ID_FROM_SOURCE as varchar) as COMMENT_ID_FROM_SOURCE,  -- Utilisation de COMMENT_ID_FROM_SOURCE comme clé provenant de Judge.me
        cast(review_title as varchar) as review_title,
        cast(review_text as varchar) as review_text,
        cast(review_date as date) as review_date,
        cast(author as varchar) as author,
        cast(product_title as varchar) as product_title
    from {{ ref('stg_judge_me_comments') }}
),

csv_reviews as (
    select
        cast(COMMENT_ID_FROM_SOURCE as varchar) as COMMENT_ID_FROM_SOURCE,  -- Utilisation de COMMENT_ID_FROM_SOURCE comme clé provenant de CSV
        cast(review_title as varchar) as review_title,
        cast(review_text as varchar) as review_text,
        cast(review_date as date) as review_date,
        cast(author as varchar) as author,
        null as product_title  -- Si `product_title` n'existe pas dans `csv`, on le met à null
    from {{ ref('stg_csv_S3_comments') }}
),

-- Fusion des deux sources avec ajout d'un ID auto-incrémental
combined_reviews as (
    select
        row_number() over() as id,  -- Génération d'un identifiant unique auto-incrémental
        COMMENT_ID_FROM_SOURCE,
        review_title,
        review_text,
        review_date,
        author,
        product_title
    from (
        select * from judgeme_reviews
        union all
        select * from csv_reviews
    )
)

select * from combined_reviews
