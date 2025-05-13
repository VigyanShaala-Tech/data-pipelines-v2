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



quiz_data AS (
    SELECT
        "user_id" AS email,
        "data_fields" AS quizes_name,
        "value" AS obtained_marks
    FROM {{ source('raw', 'incubator_quiz_monitoring') }}
),
        
resource_data AS (
    SELECT 
        id AS resource_id,
        title,                --VID01,VID02,Assignment,Quiz...
        total_duration AS watchtime_in_min
    FROM {{ ref('resource') }} 
    WHERE category = 'Quiz'  -- <-- Only select quiz resources
),  

student_quiz_data AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        g.student_id,
        r.resource_id,  -- This table needs to be defined with all resources
        c.cohort_code,
        100 AS max_marks,
        q.obtained_marks AS marks,
        Null AS reattempts,
        Null AS attempted_at

    FROM quiz_data q
    INNER JOIN raw_general_info_data g
        ON q.email = g.email
    INNER JOIN cohort_data c
        ON g.cohort_name = c.cohort_name 
    INNER JOIN resource_data r
        ON q.quizes_name = r.title
)

SELECT * FROM student_quiz_data

    