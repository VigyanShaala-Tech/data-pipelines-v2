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


resource_data AS (
  SELECT 
    id AS resource_id,
    category,                    
    title                            

  FROM {{ ref('resource') }}
),

raw_cohort_resource_info_data AS (
    SELECT
        "Batch" AS cohort_batch,
        "Cohort Name" AS cohort_name,
        "Resource type" AS type,
        "Resource name" AS resource_name,
        "Marks weightage" as marks_weightage,
        "Created at" AS created_at,
        "Updated at" AS updated_at
    FROM {{ source('raw', 'cohort_resource_details') }}
),


cohort_resource_data AS (
    SELECT
        ROW_NUMBER() OVER () AS id,  -- Auto-generate a unique ID for session
        r.resource_id,
        c.cohort_code,   
        cr.marks_weightage,     
        cr.created_at,    
        cr.updated_at
    FROM raw_cohort_resource_info_data cr
    INNER JOIN cohort_data c      -- Inner join since no session can exsist without a cohort.
        ON cr.cohort_name = c.cohort_name
    INNER JOIN resource_data r
        ON cr.resource_name = r.title
        AND cr.type = r.category
)

SELECT * FROM cohort_resource_data