{{ config(
  materialized='incremental',
  on_schema_change='sync_all_columns',
  post_hook=[
    """
    DO $$ BEGIN
      -- Create the sequence if it doesn't exist
      IF NOT EXISTS (
        SELECT 1 FROM pg_class WHERE relname = 'student_education_id_seq' AND relkind = 'S'
      ) THEN
        CREATE SEQUENCE student_education_id_seq;
      END IF;

      -- Set sequence to max(id) + 1
      PERFORM setval(
        'student_education_id_seq',
        COALESCE((SELECT MAX(id) FROM {{ this }}), 0) + 1,
        false
      );

      -- Set default to use the sequence for 'id' column
      EXECUTE format(
        'ALTER TABLE %I.%I ALTER COLUMN id SET DEFAULT nextval(''student_education_id_seq'')',
        '{{ this.schema }}',
        '{{ this.identifier }}'
      );
    END $$;
    """
  ]
) }}


WITH student_data AS (
    SELECT id, email
    FROM {{ ref('student') }}
),

subject_data AS (
    SELECT 
        (ROW_NUMBER() OVER (
            ORDER BY education_category, subject_area, sub_field
        ))::INT AS subject_id, 
        education_category,
        subject_area,
        sub_field
    FROM {{ ref('subject_mapping') }}
),

college_data AS (
    SELECT
        (ROW_NUMBER() OVER (
            ORDER BY standard_college_names, standard_university_names
        ))::INT AS college_id,   
        standard_college_names::VARCHAR(200) AS college_name,
        standard_university_names::VARCHAR(200)
    FROM {{ ref('college_mapping') }}
),

education_course_data AS (
    SELECT 
        (ROW_NUMBER() OVER (
            ORDER BY display_name
        ))::INT AS course_id, 
        display_name,
        course_name
    FROM {{ ref('course_mapping') }}
),

-- Raw data
raw_mapping AS (
    SELECT 
      "Student_id" AS student_id, 
      "Subject_Area" AS subject_names,
      "Name_of_College_University" AS college_name,
      "Currently_Pursuing_Degree" AS education_course
    FROM {{ source('raw', 'general_information_sheet') }}
    
),

-- Split subjects and normalize
split_subjects AS (
    SELECT 
        r.student_id,
        TRIM(LOWER(subject)) AS subject_cleaned,
        r.college_name,
        r.education_course
    FROM raw_mapping r,
         UNNEST(string_to_array(r.subject_names, ',')) AS subject
)


SELECT 
    ROW_NUMBER() OVER ()::INT AS id,
    s.id AS student_id,
    e.course_id AS education_course_id,

    ARRAY_AGG(DISTINCT sub.subject_id) FILTER (WHERE sub.subject_id IS NOT NULL) AS subject_id,
    NULL::INT AS interest_subject_id,
    c.college_id,
    NULL::INT AS start_year,
    NULL::INT AS ended_year

FROM split_subjects r
INNER JOIN student_data s ON r.student_id = s.id
LEFT JOIN college_data c ON TRIM(LOWER(r.college_name)) = TRIM(LOWER(c.college_name))
LEFT JOIN education_course_data e ON TRIM(LOWER(r.education_course)) = TRIM(LOWER(e.display_name))
-- Match with sub_field instead of subject_area
LEFT JOIN subject_data sub 
  ON TRIM(LOWER(r.subject_cleaned)) = TRIM(LOWER(sub.sub_field))
GROUP BY s.id, c.college_id, e.course_id