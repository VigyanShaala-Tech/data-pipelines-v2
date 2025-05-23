{{ config(
  indexes=[
      {'columns': ['email']}
    ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH student_cte AS (
  SELECT 
    -- TODO: Add student_id in the raw general_information_sheet.
    ---"Student_id" AS id
    "Student_id"::INT AS id,
    "Email"::VARCHAR(254) AS email,

    -- If name has "." in it, the part before it is last name, everything else is first name
    -- Else, split name with space " " and the last part is last name, everything else should be first name
    CASE
        WHEN "Name" LIKE '%.%' THEN split_part("Name", '.', 1)
        ELSE split_part("Name", ' ', -1)
    END::VARCHAR(100) AS last_name,

    CASE
        WHEN "Name" LIKE '%.%' THEN trim(split_part("Name", '.', 2))
        ELSE trim(regexp_replace("Name", '\s+\S+$', ''))
    END::VARCHAR(100) AS first_name,

    "Country" AS country,

    CASE 
      WHEN "Gender" ILIKE 'Female' THEN 'F'
      WHEN "Gender" ILIKE 'Male' THEN 'M'
      ELSE 'O'
    END::TEXT AS gender,

    "Phone"::VARCHAR(15) AS phone,

    CASE 
      WHEN "Date_of_Birth" ILIKE 'Null' OR "Date_of_Birth" IS NULL THEN NULL
      ELSE CAST("Date_of_Birth" AS DATE) 
    END::DATE AS date_of_birth,

    "Caste_Category"::TEXT AS caste,      
    "Annual_Family_Income"::TEXT AS annual_family_income

  FROM {{ source('raw', 'general_information_sheet') }}
)

SELECT * FROM student_cte