{{ config(
    indexes=[ {'columns': ['course_name']}, {'columns': ['display_name']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH education_course_cte AS (
    SELECT 
        courses."Currently_Pursuing_Degree" AS display_name,  
        mapping."course_name" AS course_name     
    FROM {{ source('raw', 'general_information_sheet') }} courses
    -- To do- populate the course_mapping seed file with standard course names.
    LEFT JOIN {{ ref('course_mapping') }} mapping
    ON LOWER(COALESCE(CAST(courses."Currently_Pursuing_Degree" AS TEXT), 'default_value')) =LOWER(COALESCE(CAST(mapping.display_name AS TEXT), 'default_value'))
),
unique_courses_cte AS (
    SELECT 
        course_name,
        display_name,
        ROW_NUMBER() OVER (ORDER BY display_name) AS id  -- Assigns unique ID per display_name
    FROM (SELECT DISTINCT display_name,course_name FROM education_course_cte WHERE display_name IS NOT NULL) AS unique_display_names  -- Extract distinct display and course names.
)

SELECT * FROM unique_courses_cte

