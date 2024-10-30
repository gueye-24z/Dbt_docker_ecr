{{ config(
    materialized='incremental',
    unique_key='COMMENT_ID_FROM_SOURCE',
    enabled=true
) }}

with raw_data as (
    select
        ID as COMMENT_ID_FROM_SOURCE,  -- Renommage de ID en COMMENT_ID_FROM_SOURCE
        BODY as review_text,
        CREATED_AT as review_date,
        PRODUCT_TITLE as product_title,
        REVIEWER as author,
        TITLE as review_title
    from {{ source('judge_me', 'reviews') }}
    
    {% if is_incremental() %}
        -- Filtrer pour récupérer uniquement les nouvelles données basées sur `ID`
        where ID > (select max(COMMENT_ID_FROM_SOURCE) from {{ this }})
    {% endif %}
)

select * from raw_data
