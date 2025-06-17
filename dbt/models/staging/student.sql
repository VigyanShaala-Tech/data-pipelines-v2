{{ config(
  indexes=[
      {'columns': ['email']}
    ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH student_cte AS (
  SELECT 
    "Student_id" AS id,
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
    "Annual_Family_Income" AS annual_family_income_inr

  FROM {{ source('raw', 'general_information_sheet') }}
),

raw_general_data AS (
    SELECT
        "Student_id" AS student_id,
        "Country" AS country,
        "State_Union_Territory" AS state_union_territory,
        "District" AS district,
        "City_Category" AS city_category
    FROM {{ source('raw', 'general_information_sheet') }}
    
),

location_data AS (
    SELECT    
        "Country" AS country,
        "State/Union Territory" AS state_union_territory,
        "District " AS district,
        "City Category" AS city_category,
        ROW_NUMBER() OVER (
            ORDER BY "Country", "State/Union Territory", "District ", "City Category"
        ) AS location_id
    FROM {{ ref('location_mapping') }}
),

student_details AS (
    SELECT
        s.*,
        l.location_id
    FROM student_cte s
    INNER JOIN raw_general_data g        
        ON s.id = g.student_id                -- The id in student_cte maps to student_id in the raw data, enabling location joins.
    LEFT JOIN location_data l
        ON g.country = l.country
        AND g.state_union_territory = l.state_union_territory
        AND g.district = l.district
        AND g.city_category = l.city_category
)


SELECT * FROM student_details