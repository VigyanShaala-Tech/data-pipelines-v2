{{ config(
    indexes=[ {'columns': ['category_name']} ],
    on_schema_change='sync_all_columns',
    materialized='table'
) }}

WITH education_category_cte AS (
    SELECT
        CAST(ROW_NUMBER() OVER () AS INT) AS id,
        ---- To do 
        ---- Add a seed file for standard education category name and add a reference once the categories are finalized.
        CAST(NULL AS VARCHAR) AS category_name           
)

SELECT * FROM education_category_cte