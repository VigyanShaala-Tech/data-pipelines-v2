{{ config(
  indexes=[
      {'columns': ['email']}
    ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH student_cte AS (
  SELECT 
    -- TODO: Replace assined row number ids like 00001,00002,00003.. with actual student_id once a proper ID generation mechanism is implemented
    LPAD(ROW_NUMBER() OVER (ORDER BY "Email")::TEXT, 5, '0') AS student_id,
    "Email" AS email,

    -- If name has "." in it, the part before it is last name, everything else is first name
    -- Else, split name with space " " and the last part is last name, everything else should be first name
    CASE
        WHEN "Name" LIKE '%.%' THEN split_part("Name", '.', 1)
        ELSE split_part("Name", ' ', -1)
    END AS last_name,

    CASE
        WHEN "Name" LIKE '%.%' THEN trim(split_part("Name", '.', 2))
        ELSE trim(regexp_replace("Name", '\s+\S+$', ''))
    END AS first_name,

    "Country" AS country,

    CASE 
      WHEN "Gender" ILIKE 'Female' THEN 'F'
      WHEN "Gender" ILIKE 'Male' THEN 'M'
      ELSE 'O'
    END AS gender,

    "Phone" AS phone,

    CASE 
      WHEN "Date_of_Birth" ILIKE 'Null' OR "Date_of_Birth" IS NULL THEN NULL
      ELSE CAST("Date_of_Birth" AS DATE) 
    END AS date_of_birth,

    "Caste_Category" AS caste,
    "Annual_Family_Income" AS annual_family_income

  FROM {{ source('raw', 'general_information_sheet') }}
)

SELECT * FROM student_cte