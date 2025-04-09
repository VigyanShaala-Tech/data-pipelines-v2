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
    sd.id AS student_id,  -- Set when joined with student_details
    gs."Assigned_Through" AS assigned_through,
    NULL AS registration_date,

    -- Construct JSONB for form fields
    jsonb_build_object(
      'how_did_you_hear_about_us', gs."How_did_you_hear_about_us",
      'is_studying_STEM_fields', NULL,
      'reason_for_applying', NULL,
      'problems_faced_in_studies_and_career', NULL
    ) AS form_details

  FROM {{ source('raw', 'general_information_sheet') }} AS gs
  LEFT JOIN {{ ref('student') }} AS sd
    ON gs."Email" = sd.email  -- Replace with the correct join key
)

SELECT 
  id,
  student_id,
  assigned_through,
  registration_date,
  form_details
FROM registration_cte
