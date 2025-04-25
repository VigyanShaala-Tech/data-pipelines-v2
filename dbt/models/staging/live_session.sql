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

live_session_detail AS (
    SELECT
        ROW_NUMBER() OVER () AS id,  -- Auto-generates a unique ID for session
        c.cohort_code,
        rs.session_name,
        rs.type,
        rs.duration AS "duration_in_min",
        rs.conducted_on
    FROM {{ source('raw', 'session_details') }} rs
    LEFT JOIN cohort_data c
        ON rs.cohort_name = c.cohort_name
)

SELECT * FROM live_session_detail
