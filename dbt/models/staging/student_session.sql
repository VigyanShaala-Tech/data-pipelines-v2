{{ config(
    indexes=[ {'columns': ['session']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH cohort_data AS (
    SELECT
        cohort_code,
        cohort_name
    FROM {{ ref('cohort') }} 
),
  

raw_general_info_data AS (
    SELECT
        "Incubator_Course_Name" AS cohort_name,
        "Student_id" AS student_id,
        "Email" as email
    FROM {{ source('raw', 'general_information_sheet') }}
),


session_data AS (
    SELECT
        id AS session_id,
        name,
        cohort_code,
        code
    FROM {{ ref('live_session') }} 
),

raw_student_session_info AS (
    SELECT
        "Email" AS email,
        "Session_Code" AS session_code,
        "Duration_in_mins" as duration_in_mins
    FROM {{ source('raw', 'student_session_information') }}
    WHERE "Session_Code" LIKE 'SUK%' 
       OR "Session_Code" LIKE 'WS%'      
       OR "Session_Code" LIKE 'MC%'
),

student_live_session_cte AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        g.student_id,
        s.session_id,               -- Workshop data needs to be included (still yet to come from operations team)
        ssi.duration_in_mins
    FROM raw_student_session_info ssi
    INNER JOIN raw_general_info_data g    --Take email ids present in the registration detail sheet as the final email id count.
        ON ssi.email = g.email
    INNER JOIN cohort_data c        
        ON g.cohort_name = c.cohort_name      -- To map cohort name from registration general info data to cohort code
    INNER JOIN session_data s         
        ON ssi.session_code = s.code
       AND c.cohort_code = s.cohort_code   --- to avoid mixing same name session conducted between the cohorts.

)



SELECT * FROM student_live_session_cte