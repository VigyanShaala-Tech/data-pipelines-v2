{{ config(
    indexes=[ {'columns': ['cohort_code']} ],
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

resource_data AS (
    SELECT 
        id AS resource_id,
        title,                --VID01,VID02,Assignment,Quiz...
        total_duration AS watchtime_in_min
    FROM {{ ref('resource') }} 
),



student_session_info AS (
    SELECT
        "Email" AS email,
        "Session_Code" AS session_code,      -- MC01,MC02,SUK0,VID01,VID02,...   
        "Duration_in_secs" AS watchtime_in_secs
    FROM {{ source('raw', 'student_session_information') }}
    WHERE "Session_Code" LIKE 'VID%' 
    
),

student_pre_recorded_data AS (
    SELECT
        ROW_NUMBER() OVER () AS id,                      
        g.student_id,
        r.resource_id,
        c.cohort_code,
        s.watchtime_in_secs,
        NULL AS watched_at    
    FROM student_session_info s
    INNER JOIN raw_general_info_data g    --Take email ids present in the registration detail sheet as the final email id count.
        ON s.email = g.email                 -- Match session attended email ids to the registered email_ids
    INNER JOIN cohort_data c                  
        ON g.cohort_name = c.cohort_name       -- Map exact cohort code related to cohort name
    INNER JOIN resource_data r
        ON s.session_code = r.title          -- Map exact pre-recorded videos shared under each cohort.

)


SELECT * FROM student_pre_recorded_data

