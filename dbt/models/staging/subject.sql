{{ config(
    indexes=[ {'columns': ['subject_name']}, {'columns': ['display_name']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH subject_cte AS (
    SELECT 
        subjects."Subject_Area" AS display_name,  -- Ensure column name matches exactly
        mapping."subject_name" AS subject_name  
    FROM {{ source('raw', 'general_information_sheet') }} subjects
    -- To do- populate the subject_mapping seed file with standard subject names.
    LEFT JOIN {{ ref('subject_mapping') }} mapping
    ON LOWER(subjects."Subject_Area") = LOWER(mapping.display_name)
)

unique_subject_cte AS (
    SELECT 
        display_name,
        subject_name,
        ROW_NUMBER() OVER (ORDER BY display_name) AS id  -- Assigns unique ID per display_name
    FROM (SELECT DISTINCT display_name,subject_name FROM subject_cte WHERE display_name IS NOT NULL) AS unique_display_names  -- Extract distinct display names first
)

SELECT * FROM unique_subject_cte

