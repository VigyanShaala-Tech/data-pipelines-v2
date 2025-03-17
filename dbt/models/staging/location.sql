{{ config(
  materialized='table',
  on_schema_change='sync_all_columns',
  indexes=[
    {'columns': ['country']},
    {'columns': ['state_union_territory']},
    {'columns': ['district']}
  ]
) }}

WITH location_cte AS (
    SELECT 
        "Country" AS country,
        "State_Union_Territory" AS state_union_territory,
        "District" AS district,
        "City_Category" AS location_category
    FROM {{ source('raw', '01_general_information_sheet') }}
    GROUP BY 1, 2, 3, 4  -- Ensure unique locations
)


