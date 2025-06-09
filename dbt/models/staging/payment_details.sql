{{ config(
    materialized='incremental',
    unique_key='id',
    on_schema_change='append_new_columns'
) }}

-- This model initializes an empty incremental table structure.
-- The source data isn't available yet and will be collected now onwards.

SELECT
  NULL::INT AS id,
  NULL::INT AS role_id,
  NULL::TEXT AS role_type,
  NULL::VARCHAR(6) AS cohort_code,
  NULL::DECIMAL(10,2) AS paid_amount_inr,    --- upto 10 digits and 2 digits after decimal point
  NULL::DECIMAL(10,2) AS fee_received_inr,
  NULL::TEXT AS mode_of_payment,
  NULL::TIMESTAMP AS transaction_date

WHERE 1 = 0
