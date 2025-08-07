{{ config(
  materialized='incremental',
  on_schema_change='sync_all_columns',
  post_hook=[
    "SELECT setval(pg_get_serial_sequence('intermediate.student_education', 'id'), (SELECT MAX(id) FROM intermediate.student_education));"
  ]
) }}

WITH student_data AS (
    SELECT id, email
    FROM {{ ref('student_details') }}
),

subject_data AS (
    SELECT 
        id, 
        subject_area,
        sub_field
    FROM {{ ref('subject_mapping') }}
),

college_data AS (
    SELECT
        college_id,   
        standard_college_names::VARCHAR(200) AS college_name
    FROM {{ ref('college_mapping') }}
),

education_course_data AS (
    SELECT 
        course_id, 
        display_name,
        course_name
    FROM {{ ref('course_mapping') }}
),

location_data AS (
    SELECT 
        location_id,
        country,
        state_union_territory,
        district,
        city_category
    FROM {{ ref('location_mapping') }}
),

raw_mapping AS (
    SELECT 
      "Student_id" AS student_id, 
      "Subject_Area" AS subject_names,
      "Name_of_College_University" AS college_name,
      "Currently_Pursuing_Degree" AS education_course,
      "Country" AS country,
      "State_Union_Territory" AS state_union_territory,
      "District" AS district,
      "City_Category" AS city_category
    FROM {{ source('raw', 'general_information_sheet') }}
),

split_subjects AS (
    SELECT 
        r.student_id,
        r.college_name,
        r.education_course,
        r.country,
        r.state_union_territory,
        r.district,
        r.city_category,
        TRIM(LOWER(subject)) AS subject_cleaned
    FROM raw_mapping r,
         UNNEST(string_to_array(r.subject_names, ',')) AS subject
)


SELECT 
    s.id::INT AS id,
    s.id::INT AS student_id,
    e.course_id::INT AS education_course_id,
    ARRAY_AGG(DISTINCT sub.id) FILTER (WHERE sub.id IS NOT NULL)::INT[] AS subject_id,
    NULL::INT AS interest_subject_id,
    NULL::INT AS university_id,
    c.college_id::INT AS college_id,
    l.location_id::INT AS college_location_id,
    NULL::INT AS start_year,
    NULL::INT AS end_year

FROM split_subjects r
INNER JOIN student_data s ON r.student_id = s.id
LEFT JOIN college_data c ON TRIM(LOWER(r.college_name)) = TRIM(LOWER(c.college_name))
LEFT JOIN location_data l 
      ON r.country = l.country
      AND r.state_union_territory = l.state_union_territory
      AND r.district = l.district
      AND r.city_category = l.city_category
LEFT JOIN education_course_data e ON TRIM(LOWER(r.education_course)) = TRIM(LOWER(e.display_name))
LEFT JOIN subject_data sub 
  ON TRIM(LOWER(r.subject_cleaned)) = TRIM(LOWER(sub.sub_field))
GROUP BY s.id, c.college_id, e.course_id, l.location_id