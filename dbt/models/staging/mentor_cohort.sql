{{ config(
    materialized = 'table'
) }}

WITH cohort_data AS (
    SELECT
        cohort_code,
        cohort_name,
        CAST(start_date AS DATE) AS start_date
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
        "Date of Enrollment" AS enrollment_date
    FROM {{ source('raw', 'mentor_recruitment') }} 
),

mentor_cohort_data AS (
    SELECT
        ROW_NUMBER() OVER () AS id,  -- Auto-generate a unique ID for mentor_cohort
        m.mentor_id,
        c.cohort_code,               -- Cohort names for 
        r.enrollment_date AS cohort_enroll_date,
        NULL AS is_active,            -- Will be captured now onwards
        NULL AS started_on,
        NULL AS ended_on
    FROM raw_mentor_info_data r
    INNER JOIN mentor_data m
        ON r.email_id = m.email_id     --- Email_id is a mandatory field in the google form
    LEFT JOIN cohort_data c           -- Mentors can exsist without a cohort(like Project developers). Left join to include mentors without a cohort
        ON LOWER(r.cohort_name) = LOWER(c.cohort_name)     
    
)

SELECT * FROM mentor_cohort_data