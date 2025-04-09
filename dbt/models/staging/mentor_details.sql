{{ config(
  indexes=[
      {'columns': ['email_id']}
    ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

---To Do: Add a mentor data source from Mysql database to postgres to fetch data.
---
---Placeholder dbt model for mentor table.

WITH mentor_cte AS (
    SELECT
        ROW_NUMBER() OVER () AS id,  -- Auto-generated unique ID
        "Enter your full name *" AS mentor_name,
        "Enter your email address *" AS email_id,
        "Enter your LinkedIn profile link here" AS linkedIn_url,
        "Current Job title/Designation" AS current_position,
        "Enter your WhatsApp number (with country code, DONOT ADD '+') *" AS phone_number,
        NULL AS joined_on,
        NULL AS is_active
    FROM {{ source('raw', 'mentor_recruitment') }}
)

SELECT * FROM mentor_cte


