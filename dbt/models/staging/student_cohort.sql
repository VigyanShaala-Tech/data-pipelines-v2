{{ config(
    materialized = 'table'
) }}

WITH cohort_ref AS (
    SELECT
        cohort_code,
        cohort_name,
        CAST(start_date AS DATE) AS start_date
    FROM {{ ref('cohort') }} 
),

student_data AS (
    SELECT
        id AS student_id
    FROM {{ ref('student') }} 
),

raw_mapping AS (
    SELECT 
        "Student_id" AS student_id, 
        "Student_Role" AS student_role,
        "Incubator_Course_Name" AS incubator_course_name
    FROM {{ source('raw', 'general_information_sheet') }} 
),


final_data AS (
    SELECT
        -- student_code: 2-digit year + cohort_code + padded 7-digit student_id
        RIGHT(CAST(EXTRACT(YEAR FROM c.start_date) AS TEXT), 2) || 
        c.cohort_code || 
        LPAD(CAST(rm.student_id AS TEXT), 7, '0') AS student_code,

        rm.student_id,
        c.cohort_code,
        -- Only "Student Leader" becomes 'Yes', others become 'No'
        CASE 
            WHEN student_role ILIKE '%student leader%' THEN 'Yes'
            ELSE 'No'
        END AS is_leader,
        CAST(NULL AS DATE) AS cohort_enroll_date

    FROM raw_mapping rm
    LEFT JOIN student_data s 
        ON rm.student_id = s.student_id
    LEFT JOIN cohort_ref c 
        ON LOWER(rm.incubator_course_name) = LOWER(c.cohort_name)
    
)

SELECT * FROM final_data