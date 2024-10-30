{{ config(
    materialized='incremental',
    unique_key='COMMENT_ID_FROM_SOURCE',
    enabled=true
) }}

with raw_data as (
    select
        REVIEW_ID as COMMENT_ID_FROM_SOURCE,  -- Renommage de REVIEW_ID en COMMENT_ID_FROM_SOURCE
        REVIEW_TITLE as review_title,
        REVIEW_TEXT as review_text,
        REVIEW_DATE as review_date,
        AUTHOR_TITLE as author
    from {{ source('csv_S3', 'csv_ingestion_from_S3') }}
    
    {% if is_incremental() %}
        -- Filtrer pour récupérer uniquement les nouvelles données basées sur `REVIEW_ID`
        where REVIEW_ID > (select max(COMMENT_ID_FROM_SOURCE) from {{ this }})
    {% endif %}
)

select * from raw_data
