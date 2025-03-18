{{ config(
  indexes=[
    {'columns': ['registration_date']},
    {'columns': ['assigned_through']}
  ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH registration_cte AS (
  SELECT 
    "Assigned_Through" as assigned_through,
    "How_did_you_hear_about_us" as how_did_you_hear_about_us,
    CASE 
      -- NOTE: This logic currently uses a hardcoded pattern for subject area matching.The subject areas are placeholders for now.
      -- We should replace it with a more scalable approach, such as:
      -- Using a lookup table for standardized subject areas.
      WHEN "Subject_Area" SIMILAR TO '%(Science|Technology|Engineering|Mathematics|Computer|Physics|Biology|Chemistry|Data|AI|Robotics)%' 
      THEN TRUE 
      ELSE FALSE 
    END AS is_studying_STEM_fields
   
  FROM {{ source('raw', 'general_information_sheet') }}
)
  
SELECT * FROM registration_cte
