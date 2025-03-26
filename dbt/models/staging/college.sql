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
    CASE 
      -- Add all the entries in college university column ending with 'University' under university column.
      WHEN "Name_of_College_University" LIKE '%University' THEN "Name_of_College_University"
      ELSE NULL
    END AS university,
    CASE 
      WHEN "Name_of_College_University" NOT LIKE '%University' THEN "Name_of_College_University"
      ELSE NULL
    END AS college
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