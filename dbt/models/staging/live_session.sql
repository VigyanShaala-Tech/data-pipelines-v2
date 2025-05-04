{{ config(
    indexes=[ {'columns': ['cohort_code']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}


WITH cohort_cte AS (
    SELECT
        cohort_code,
        cohort_name
    FROM {{ ref('cohort') }}
),

session_cte AS (
  SELECT 
    "Session_Name" AS name,
    "Type" AS type,
    "Session Code" AS code,            ---SUK0,MC01,MC02,SUK1
    "Cohort_Name" AS cohort_name,
    "Batch" AS incubator_batch,
    "Speaker_Name" AS speaker_name,
    "Duration" AS duration_in_sec,      --Duration is present in second convert it to hours
    "Conducted_On" AS conducted_on

  FROM {{ source('raw', 'session_details') }}
),

--Renamed table name to live_session.
live_session_cte AS (
    SELECT
        ROW_NUMBER() OVER () AS id,  -- Auto-generate a unique ID for session
        c.cohort_code,
        s.name,
        s.type,     ---Speak Up Kalpana, Masterclass, Workshop. Workshop data isn't included(yet to come fom operations team)
        s.code,     --Maps student wise attended sessions in respective cohort
        ROUND(CAST(s.duration_in_sec AS numeric) / 60.0, 2) AS duration_in_min,  -- Convert seconds to hours
        s.conducted_on
    FROM session_cte s
    INNER JOIN cohort_cte c      -- Inner join since no session can exsist without a cohort.
        ON s.cohort_name = c.cohort_name
)

SELECT * FROM live_session_cte