{{ config(
    materialized='table'
) }}

WITH programs_cte AS (
    SELECT 
        ---To do update the start date of the program (set as NULL for now)
        'INC'::TEXT AS program_code,
        'Incubator'::VARCHAR(20) AS full_form,
        '2022-07-09'::DATE AS start_date
    UNION ALL
    SELECT 
        'ACC'::TEXT AS program_code,
        'Accelerator'::VARCHAR(20) AS full_form, 
        '2020-10-18'::DATE AS start_date
    UNION ALL
    SELECT 
        'STC'::TEXT AS program_code, 
        'Stem Champion'::VARCHAR(20) AS full_form, 
        '2022-07-23'::DATE AS start_date
)

SELECT * FROM programs_cte
