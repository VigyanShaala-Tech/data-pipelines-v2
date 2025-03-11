


{{ config(
  indexes=[
      {'columns': ['_airbyte_raw_id'], 'type': 'hash'}
    ],
  materialized='table'
) }}


with 
  case_cte as (
    SELECT 
    Email as email,
    First_name as first_name, 
    
    


FROM {{ source('new_db', 'raw_student_details') }} )
