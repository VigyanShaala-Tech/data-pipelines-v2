{{ config(
    indexes=[ {'columns': ['category']}],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH resource_cte AS (
    SELECT 
        ROW_NUMBER() OVER () AS id,  -- Auto-generate a unique ID for session
        "Category" AS category,  --- Pre-recorded, Quiz, assignment, video  
        "Title" AS title,
        "Content Name" AS description,
        NULL AS location,
        NULL AS resource_link,
        "Is_Video" AS is_video_resource,
        "Time" AS total_duration

      FROM {{ source('raw', 'resource_details') }}
)


SELECT * FROM resource_cte


