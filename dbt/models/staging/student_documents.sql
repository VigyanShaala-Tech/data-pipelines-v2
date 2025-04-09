{{ config(
    indexes=[ {'columns': ['document_name']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH student_documents_cte AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        NULL AS document_name,
        "Photo_ID" AS document

  FROM {{ source('raw', 'general_information_sheet') }}
)
    
SELECT * FROM student_documents_cte