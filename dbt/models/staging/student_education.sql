WITH student_data AS (
    SELECT id, email, annual_family_income
    FROM {{ ref('student') }}
    ORDER BY id ASC
),

subject_data AS (
    SELECT id AS subject_id, subject_name, display_name
    FROM {{ ref('subject') }}
),

college_data AS (
    SELECT id AS college_id, college
    FROM {{ ref('college') }}
),

education_category_data AS (
    SELECT id AS education_category_id,category_name
    FROM {{ ref('education_category') }}
),

education_course_data AS (
    SELECT id AS course_id,course_name,display_name
    FROM {{ ref('education_course') }}
),

raw_mapping AS (
    SELECT 
      "Student_id" AS student_id, 
      "Subject_Area" AS subject_name, 
      "Name_of_College_University" AS college_name,
      "Currently_Pursuing_Degree" AS education_course,
      Null AS education_category
    FROM {{ source('raw', 'general_information_sheet') }} 
)


---To do: Put start_year, end_year logic based on the registration date and currently pursuing year. Also try to add the seed file for degree years.
SELECT 
    ROW_NUMBER() OVER () AS mapping_id, -- Unique ID for the mapping
    student_data.id,
    subject_data.subject_id,
    college_data.college_id,
    education_course_data.course_id,
    education_category_data.education_category_id
FROM raw_mapping
LEFT JOIN student_data ON raw_mapping.student_id = student_data.id
LEFT JOIN subject_data ON raw_mapping.subject_name = subject_data.display_name
LEFT JOIN college_data ON raw_mapping.college_name = college_data.college
LEFT JOIN education_course_data ON raw_mapping.education_course = education_course_data.display_name
LEFT JOIN education_category_data ON raw_mapping.education_category = education_category_data.category_name
