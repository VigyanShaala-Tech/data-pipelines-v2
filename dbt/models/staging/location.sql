{{ config(
  indexes=[ {'columns': ['country']}, {'columns': ['country_code']} ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH location_cte AS (
    SELECT 
        location_details."Country" AS country,
        country_seed.country_code,  -- Fetch country code from seed file
        location_details."State_Union_Territory" AS state_union_territory,
        location_details."District" AS district,
        location_details."City_Category" AS location_category
    FROM {{ source('raw', 'general_information_sheet') }} location_details
    LEFT JOIN {{ ref('country_code') }} country_seed
    ON LOWER(location_details."Country") = LOWER(country_seed.country_name)  -- Case insensitive match (e.g., "India" and "india" are treated the same)
    GROUP BY 1, 2, 3, 4, 5  -- Ensure unique locations
)

SELECT * FROM location_cte
