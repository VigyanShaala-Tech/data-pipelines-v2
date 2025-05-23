WITH student_data AS (
    SELECT * FROM {{ ref('student') }}
),

college_data AS (
    SELECT * FROM {{ ref('college') }}
),

location_data AS (
    SELECT * FROM {{ ref('location') }}
),

raw_general_info AS (
    SELECT 
        "Email" AS email,
        "Name_of_College_University" AS college
    FROM {{ source('raw', 'general_information_sheet') }}
)

SELECT 
    s.id AS student_id,
    s.first_name,
    s.last_name,
    s.email,
    s.gender,
    s.phone,
    s.date_of_birth,
    s.caste,
    s.annual_family_income,

    c.college,
    c.university,

    l.country,
    l.state_union_territory,
    l.district,
    l.location_category

FROM student_data s
INNER JOIN raw_general_info rg ON s.email = rg.email  
INNER JOIN college_data c ON rg.college = c.college 
LEFT JOIN location_data l ON s.location_id = l.id   --- Add up locations for all the data present in the student table
