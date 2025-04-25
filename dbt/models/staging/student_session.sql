WITH cohort_data AS (
    SELECT
        cohort_code,
        cohort_name
    FROM {{ ref('cohort') }} 
),

session_details_data AS (
    SELECT
        session_name,
        cohort_name,
        speaker_name,
        conducted_on
    FROM {{ source('raw', 'session_details') }}
),

raw_general_info_data AS (
    SELECT
        "Incubator_Course_Name" AS cohort_name,
        "Student_id" AS student_id,
        "Email" as email
    FROM {{ source('raw', 'general_information_sheet') }}
),

live_session_data AS (
    SELECT
        id AS session_id,
        session_name,
        cohort_code
    FROM {{ ref('live_session') }} 
),


student_session_monitoring_data AS (
    SELECT
        "Email" AS email,
        "SUK0" AS suk0,
        "MC01" AS mc01,
        "MC02" AS mc02,
        "MC03" AS mc03,
        "MC04" AS mc04,
        "MC05" AS mc05,
        "SUK1" AS suk1,
        "MC06" AS mc06,
        "SUK2" AS suk2,
        "SUK3" AS suk3,
        "MC07" AS mc07,
        "MC08" AS mc08,
        "MC09" AS mc09,
        "MC10" AS mc10,
        "MC11" AS mc11,
        "SUK4" AS suk4,
        "SUK5" AS suk5,
        "SUK6" AS suk6,
        "WS01" AS ws01,
        "WS10" AS ws10,
        "WS03" AS ws03,
        "WS11" AS ws11,
        "WS02" AS ws02,
        "WS05" AS ws05,
        "MC16" AS mc16,
        "WS06" AS ws06,
        "WS07" AS ws07,
        "WS08" AS ws08,
        "WS09" AS ws09,
        "WS04" AS ws04,
        "WS12" AS ws12,
        "SUK7" AS suk7,
        "WS13" AS ws13,
        "WS16" AS ws16,
        "WS21" AS ws21,
        "WS18" AS ws18,
        "WS14" AS ws14,
        "WS15" AS ws15,
        "WS17" AS ws17,
        "WS19" AS ws19,
        "WS20" AS ws20,
        "WS22" AS ws22,
        "Pre_Recorded_Total_Hours" AS pre_recorded_total_hours,
        "Pre_Recorded_Percentage" AS pre_recorded_percentage,
        "SUK_Total_Hours" AS suk_total_hours,
        "SUK_Percentage" AS suk_percentage,
        "Masterclass_Total_Hours" AS masterclass_total_hours,
        "Masterclass_Percentage" AS masterclass_percentage,
        "Workshop_Total_Hours" AS workshop_total_hours,
        "Workshop_Percentage" AS workshop_percentage,
        "Program_Total_Hours" AS program_total_hours,
        "Program_Percentage" AS program_percentage

    FROM {{ source('raw', 'student_session_info') }}
),
        
   

final_data AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        g.student_id,
        sl.session_id,
        q.suk0,
        q.mc01,
        q.mc02,
        q.mc03,
        q.mc04,
        q.mc05,
        q.suk1,
        q.mc06,
        q.suk2,
        q.suk3,
        q.mc07,
        q.mc08,
        q.mc09,
        q.mc10,
        q.mc11,
        q.suk4,
        q.suk5,
        q.suk6,
        q.ws01,
        q.ws10,
        q.ws03,
        q.ws11,
        q.ws02,
        q.ws05,
        q.mc16,
        q.ws06,
        q.ws07,
        q.ws08,
        q.ws09,
        q.ws04,
        q.ws12,
        q.suk7,
        q.ws13,
        q.ws16,
        q.ws21,
        q.ws18,
        q.ws14,
        q.ws15,
        q.ws17,
        q.ws19,
        q.ws20,
        q.ws22,
        Null as watched_on
    FROM student_session_monitoring_data q
    LEFT JOIN raw_general_info_data g
        ON q.email = g.email
    LEFT JOIN cohort_data cl
        ON cl.cohort_name = g.cohort_name
    LEFT JOIN live_session_data sl
        ON sl.cohort_code = cl.cohort_code
),

--- "Unnest transforms all the session duration"
student_session_data AS (
    SELECT
        id,
        student_id,
        session_id,
        UNNEST(ARRAY[
            'suk0', 'mc01', 'mc02', 'mc03', 'mc04', 'mc05', 'suk1', 'mc06', 'suk2', 'suk3',
            'mc07', 'mc08', 'mc09', 'mc10', 'mc11', 'suk4', 'suk5', 'suk6', 'ws01', 'ws10',
            'ws03', 'ws11', 'ws02', 'ws05', 'mc16', 'ws06', 'ws07', 'ws08', 'ws09', 'ws04',
            'ws12', 'suk7', 'ws13', 'ws16', 'ws21', 'ws18', 'ws14', 'ws15', 'ws17', 'ws19',
            'ws20', 'ws22'
        ]) AS session,
        UNNEST(ARRAY[
            f.suk0, f.mc01, f.mc02, f.mc03, f.mc04, f.mc05, f.suk1, f.mc06, f.suk2, f.suk3,
            f.mc07, f.mc08, f.mc09, f.mc10, f.mc11, f.suk4, f.suk5, f.suk6, f.ws01, f.ws10,
            f.ws03, f.ws11, f.ws02, f.ws05, f.mc16, f.ws06, f.ws07, f.ws08, f.ws09, f.ws04,
            f.ws12, f.suk7, f.ws13, f.ws16, f.ws21, f.ws18, f.ws14, f.ws15, f.ws17, f.ws19,
            f.ws20, f.ws22
        ])::numeric AS duration_in_mins,
        NULL AS watched_on
    FROM final_data f
)

SELECT * FROM student_session_data
