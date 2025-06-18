{{ config(
  materialized='incremental',
  on_schema_change='sync_all_columns',
  post_hook=[
    """
    DO $$ BEGIN
      -- Create the sequence if it doesn't exist
      IF NOT EXISTS (
        SELECT 1 FROM pg_class WHERE relname = 'student_id_seq' AND relkind = 'S'  
      ) THEN
        CREATE SEQUENCE student_id_seq;
      END IF;

      -- Move sequence to max(id)+1
      PERFORM setval(
        'student_id_seq',
        COALESCE((SELECT MAX(id) FROM {{ this }}), 0) + 1,
        false
      );

      -- Attach sequence to id column
      EXECUTE format(
        'ALTER TABLE %I.%I ALTER COLUMN id SET DEFAULT nextval(''student_id_seq'')',
        '{{ this.schema }}',
        '{{ this.identifier }}'
      );
    END $$;
    """
  ]
) }}


WITH student_cte AS (
  SELECT 
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
    "Annual_Family_Income"::TEXT AS annual_family_income_inr

  FROM {{ source('raw', 'general_information_sheet') }}
),

raw_general_data AS (
    SELECT
        "Student_id" AS raw_student_id,
        "Country" AS country,
        "State_Union_Territory" AS state_union_territory,
        "District" AS district,
        "City_Category" AS city_category
    FROM {{ source('raw', 'general_information_sheet') }}
    
),

location_data AS (
    SELECT    
        country::VARCHAR(50),
        state_union_territory::VARCHAR(60),
        district::VARCHAR(60),
        city_category::TEXT,
        (ROW_NUMBER() OVER (
            ORDER BY country, state_union_territory, district, city_category
        ))::INT AS location_id
    FROM {{ ref('location_mapping') }}
),

student_details AS (
    SELECT
        s.*,
        l.location_id
    FROM student_cte s
    INNER JOIN raw_general_data g        
        ON s.id = g.raw_student_id                -- The id in student_cte maps to student_id in the raw data, enabling location joins.
    LEFT JOIN location_data l
        ON g.country = l.country
        AND g.state_union_territory = l.state_union_territory
        AND g.district = l.district
        AND g.city_category = l.city_category
)


SELECT * FROM student_details