{{ config(
    materialized='table'
) }}

WITH programs_cte AS (
    SELECT 
        ---To do update the start date of the program (set as NULL for now)
        'INC' AS program_code,
        'Incubator' AS full_form,
         CAST(NULL AS DATE) AS start_date
    UNION ALL
    SELECT 
        'ACC' AS program_code,
        'Accelerator' AS full_form, 
        CAST(NULL AS DATE) AS start_date
    UNION ALL
    SELECT 
        'STC' AS program_code, 
        'Stem Champion' AS full_form, 
        CAST(NULL AS DATE) AS start_date
)

SELECT * FROM programs_cte
