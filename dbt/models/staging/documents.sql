{{ config(
    indexes=[ {'columns': ['document_name']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH document_cte AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        NULL AS document_name,
        "Photo_ID" AS document

  FROM {{ source('raw', 'general_information_sheet') }}
)
    
SELECT * FROM document_cte