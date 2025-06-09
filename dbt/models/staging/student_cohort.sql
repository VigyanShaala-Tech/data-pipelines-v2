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

student_data AS (
    SELECT
        id AS student_id
    FROM {{ ref('student') }} 
),

raw_general_info_data AS (
    SELECT 
        "Student_id" AS student_id, 
        "Student_Role" AS student_role,
        "Incubator_Course_Name" AS incubator_course_name
    FROM {{ source('raw', 'general_information_sheet') }} 
),

student_cohort_data AS (
    SELECT
        -- student_code: 2-digit year + cohort_code + padded 7-digit student_id
        RIGHT(CAST(EXTRACT(YEAR FROM c.start_date) AS TEXT), 2) || 
        c.cohort_code || 
        LPAD(CAST(g.student_id AS TEXT), 7, '0') AS student_code,

        g.student_id,
        c.cohort_code,
        -- Only "Student Leader" becomes 'Yes', others become 'No'
        CASE 
            WHEN g.student_role ILIKE '%student leader%' THEN 'Yes'
            ELSE 'No'
        END AS is_leader,
        CAST(NULL AS DATE) AS cohort_enroll_date

    FROM raw_general_info_data g
    INNER JOIN student_data s 
        ON g.student_id = s.student_id
    INNER JOIN cohort_data c 
        ON LOWER(g.incubator_course_name) = LOWER(c.cohort_name)
    
)

SELECT * FROM student_cohort_data