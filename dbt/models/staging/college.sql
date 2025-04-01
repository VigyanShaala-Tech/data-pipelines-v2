{{ config(
  indexes=[
    {'columns': ['university']},
    {'columns': ['college']}
  ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH college_cte AS (
  SELECT 
    "Name_of_College_University" AS college,     --- Most of the data entries present in this column contains college names and hence placed all raw_data under college.
    NULL AS university
  FROM {{ source('raw', 'general_information_sheet') }}
)
  
unique_college_cte AS (
    SELECT 
        university,
        college,
        ROW_NUMBER() OVER (ORDER BY college) AS id  -- Assigns unique ID per display_name
    FROM (SELECT DISTINCT university,college FROM college_cte WHERE college IS NOT NULL) AS unique_college_names  -- Extract distinct college, university names
)

SELECT * FROM unique_college_cte


----To do include location id from location table as the foreign key.