{{ config(
  indexes=[{'columns': ['cohort_name']}],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH cohort_cte AS (
    SELECT
        -- Construct padded cohort_code (e.g., INC_001)
        program.program_code || RIGHT('000' || mapping."Cohort number"::TEXT, 3) AS cohort_code,
        
        program.program_code AS program_code,
        mapping."Cohort number" AS cohort_number,
        
        mapping."Cohort Name" AS cohort_name,

        -- type: open, curriculum. 
        -- Open-Nationwide, open to all STEM students. Science and/or Engineering
        -- Curricullum - Focused cohorts only for students from colleges under Govt. Partnerships - Telangana/ UK.
        mapping."Type" AS type,
        CAST(mapping."Start Date" AS DATE) AS start_date,
        CAST(mapping."End Date" AS DATE) AS end_date,

        CASE 
            WHEN CAST(mapping."End Date" AS DATE) >= CURRENT_DATE THEN 'Yes'
            ELSE 'No'
        END AS is_active

    FROM {{ source('raw', 'cohort_details') }} mapping
    JOIN {{ ref('programs') }} program
      ON LOWER(mapping."Program Name") = LOWER(program.full_form)
)

SELECT * FROM cohort_cte
