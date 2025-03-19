{{ config(
  indexes=[
      {'columns': ['email']}
    ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

with student_cte as (
  SELECT 
    "Email" as email,
    -- if name has . in it, the part before it should be last name, everything else first name
    -- else, split name with space " " and the last part is last name, everything else should be first name
    CASE
        WHEN "Name" LIKE '%.%' THEN
            (split_part(name, '.', 1))
        ELSE
            (split_part(name, ' ', -1))
    END AS last_name,

    CASE
        WHEN "Name" LIKE '%.%' THEN
            trim(split_part("Name", '.', 2))
        ELSE
        trim(regexp_replace(name, '\s+\S+$', ''))
    END AS first_name,

    "Country" as country,

    CASE 
      WHEN "Gender" LIKE 'Female' THEN 'F'
      WHEN "Gender" LIKE 'Male' THEN 'M'
      ELSE 'O'
    END as gender,

    "Phone" as phone,

    cast("Date_Of_Birth" as date) as date_of_birth,
    "Caste_Category" as caste,
    "Annual_Family_Income" as annual_family_income

  FROM {{ source('raw', 'general_information_sheet') }}
)
