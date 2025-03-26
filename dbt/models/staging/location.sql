{{ config(
  indexes=[ {'columns': ['country']}, {'columns': ['country_code']} ],
  on_schema_change='sync_all_columns',
  materialized='table'
) }}

WITH location_cte AS (
    -- Ensure unique locations before assigning location_id
    SELECT DISTINCT  
        location_details."Country" AS country,
        country_seed.country_code,  -- Fetch country code from seed file
        location_details."State_Union_Territory" AS state_union_territory,
        location_details."District" AS district,
        location_details."City_Category" AS location_category
    FROM {{ source('raw', 'general_information_sheet') }} location_details
    LEFT JOIN {{ ref('country_code') }} country_seed
    ON LOWER(location_details."Country") = LOWER(country_seed.country_name)  -- Case insensitive match
),

unique_location_cte AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY country, state_union_territory, district, location_category) AS location_id,  
        country,
        country_code,
        state_union_territory,
        district,
        location_category
    FROM location_cte
)

SELECT * FROM unique_location_cte
