{{ config(
    indexes=[ {'columns': ['session_id']} ],       
    on_schema_change='sync_all_columns',
    materialized='table'
) }}                                                     -- Have fill in index as session_id for now. Will put a pull request to confirm config script.

WITH cohort_data AS (
    SELECT
        cohort_code,
        cohort_name
    FROM {{ ref('cohort') }} 
),
  
mentor_data AS (
    SELECT
        id AS mentor_id,
        email_id
    FROM {{ ref('mentor_details') }} 
),

raw_mentor_info_data AS (
    SELECT
        "Enter your email address *" AS email_id,
        "Cohort Name" AS cohort_name, 
        "Session Code" AS session_code,
        "Date of Enrollment" AS enrollment_date
    FROM {{ source('raw', 'mentor_recruitment') }} 
),


session_data AS (
    SELECT
        id AS session_id,
        name,
        cohort_code,
        code
    FROM {{ ref('live_session') }} 
),


mentor_session AS (
    SELECT
        ROW_NUMBER() OVER () AS id,  -- Auto-generate a unique ID for mentor_cohort
        m.mentor_id,
        s.session_id             -- Workshop data needs to be included (still yet to come from operations team)
    FROM mentor_data m
    INNER JOIN raw_mentor_info_data r    --Take email ids present in the raw mentor details sheet as the final email id count.
        ON m.email_id = r.email_id       -- Email id is mandatory field in the google form.
    INNER JOIN cohort_data c        
        ON r.cohort_name = c.cohort_name      -- As session exsists in a cohort.
    INNER JOIN session_data s         
        ON r.session_code = s.code
       AND c.cohort_code = s.cohort_code   --- to avoid mixing same name session conducted between the cohorts.

)



SELECT * FROM mentor_session