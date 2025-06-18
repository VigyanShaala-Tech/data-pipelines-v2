{{ config(
    materialized='incremental',
    unique_key='id',
    post_hook=[
      """
      DO $$ BEGIN
        -- Create the sequence if it doesn't exist
        IF NOT EXISTS (
          SELECT 1 FROM pg_class WHERE relname = 'referral_college_professor_id_seq' AND relkind = 'S'
        ) THEN
          CREATE SEQUENCE referral_college_professor_id_seq;
        END IF;

        -- Move sequence to max(id)+1
        PERFORM setval(
          'referral_college_professor_id_seq',
          COALESCE((SELECT MAX(id) FROM {{ this }}), 0) + 1,
          false
        );

        -- Attach sequence to id column
        EXECUTE format(
          'ALTER TABLE %I.%I ALTER COLUMN id SET DEFAULT nextval(''referral_college_professor_id_seq'')',
          '{{ this.schema }}',
          '{{ this.identifier }}'
        );
      END $$;
      """
    ]
) }}

-- Empty structure for referral_college_professor
SELECT
    NULL::INT AS id,
    NULL::INT AS student_id,
    NULL::INT AS college_id,
    NULL::VARCHAR(50) AS name,
    NULL::VARCHAR(15) AS phone
WHERE FALSE
