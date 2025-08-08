{{ config(
  materialized='incremental',
  unique_key='id',
  on_schema_change='sync_all_columns',
  post_hook=[
   
    "SELECT setval(pg_get_serial_sequence('intermediate.student_registration_details', 'id'), (SELECT MAX(id) FROM intermediate.student_registration_details));"
  ]
) }}

WITH registration_cte AS (
  SELECT 
    gs."Student_id"::INT AS id,
    gs."Student_id"::INT AS student_id,  -- Set when joined with student_details
    gs."Assigned_Through"::TEXT AS assigned_through,
    NULL::TIMESTAMP AS registration_date,

    -- Construct JSONB for form fields
    jsonb_build_object(
      'how_did_you_hear_about_us', gs."How_did_you_hear_about_us",
      'is_studying_STEM_fields', NULL,
      'reason_for_applying', NULL,
      'problems_faced_in_studies_and_career', gs."Problems",
      'motivation', gs."Motivation",
      'new_college_name', gs."New_College_Name",
      'new_university_name', gs."new_university_name",
      'partner_organization', gs."partner_organization",
      'currently_pursuing_year', gs."Currently_Pursuing_Year"
    )::JSONB AS form_details

  FROM {{ source('raw', 'general_information_sheet') }} AS gs
  where gs."Student_id" is not null
)

SELECT 
  id,
  student_id,
  assigned_through,
  registration_date,
  form_details
FROM registration_cte
