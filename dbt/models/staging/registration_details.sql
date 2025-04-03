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
    ROW_NUMBER() OVER () AS id,
    "Assigned_Through" as assigned_through,
    "How_did_you_hear_about_us" as how_did_you_hear_about_us,
    NULL AS registration_date,
    CASE 
      -- NOTE: This logic currently uses a hardcoded pattern for subject area matching.The subject areas are placeholders for now.
      -- To do- We should replace it with a more scalable approach, such as:
      -- Mapping it to subject_mapping seed file for standardized subject areas.
      WHEN "Subject_Area" SIMILAR TO '%(Science|Technology|Engineering|Mathematics|Computer|Physics|Biology|Chemistry|Data|AI|Robotics)%' 
      THEN TRUE 
      ELSE FALSE 
    END AS is_studying_STEM_fields,
    Null AS reason_for_applying,
    Null AS problems_faced_in_studies_and_career

   
  FROM {{ source('raw', 'general_information_sheet') }}
)
  
SELECT * FROM registration_cte
