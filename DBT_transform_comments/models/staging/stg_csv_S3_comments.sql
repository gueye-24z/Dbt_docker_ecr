{{ config(
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
    

)

select * from raw_data
