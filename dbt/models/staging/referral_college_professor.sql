{{ config(
    materialized='incremental',
    unique_key='id'
) }}

-- Empty structure for referral_college_professor
SELECT
    NULL::INT AS id,
    NULL::INT AS student_id,
    NULL::INT AS college_id,
    NULL::VARCHAR(50) AS name,
    NULL::VARCHAR(15) AS phone
WHERE FALSE
