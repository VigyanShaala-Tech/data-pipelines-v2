--ChartDB VS Data Restructuring .sql script 

CREATE TABLE "education_course" (
    "id" int NOT NULL,
    "course_name" varchar,            -- name displayed in google form
    "display_name" varchar,
    PRIMARY KEY ("id")
);


CREATE TABLE "resource" (
    "id" int NOT NULL,
    "category" enum,                 -- category enum - pre-recorded,quiz,assignments,reference material.
    "title" varchar,
    "description" text,
    "location" enum,
    "resource_link" text,
    "is_video_resource" boolean,
    "total_duration" int, 
    PRIMARY KEY ("id")
);


CREATE TABLE "payment_details" (
    "id" int,
    "role_id" int,                   -- refers to student_id and mentor_id
    "role_type" enum,                -- role_type - student, mentors.
    "cohort_code" varchar,
    "paid_amount_inr" decimal,
    "fee_received_inr" decimal,
    "mode_of_payment" enum,          -- mode_of_payment - cash, cheque, online, others
    "transaction_date" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "student_registration_details" (
    "id" int,
    "student_id" int,
    "assigned_through" enum,              ---Needs to be defined. 
    "registration_date" date,         
    "form_details" JSONB,                 -- JSONB column for storing dynamic form data (like: How_did_you_hear_about_us, is_studying_STEM_fields,reason_for_applying,problems_faced-in_studies_and_career)
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id")
);


CREATE TABLE "student_assignment" (
    "id" int NOT NULL,
    "student_id" int,
    "resource_id" int,
    "mentor_id" int,
    "cohort_code" varchar,
    "submission_status" enum,   -- accepted, rejected, under-review
    "marks" int,
    "feedback/comments" text,
    "submitted_at" timestamp,
    "assignment_file" bytea,    -- Needs to finalize storage location and file size 
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "student_cohort" (
    "student_code" varchar NOT NULL,     -- student_code :  year  + cohort_code + student_id e.g 24INC0010000001,24ACC0010000001
    "student_id" int,
    "cohort_code " varchar,
    "is_leader" boolean,
    "cohort_enroll_date" date,
    PRIMARY KEY ("student_code"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "student_details" (
    "id" int NOT NULL,
    "email" varchar,
    "first_name" varchar,
    "last_name" varchar,
    "gender" enum,         -- male, female and other
    "is_female" boolean,
    "is_indian" boolean,
    "phone" varchar,       -- To Do- Phone number should be 10 digit.Once the student selects country from the drop down, the form should populate the country code automatically
    "date_of_birth" date,
    "caste" enum,         -- OBC, ST/SC, Others
    "annual_family_income_inr" text,     -- Needs to be converted to range. (should be in INR)'
    "location_id" int,    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES location("id")
);



CREATE TABLE "education_category" (
    "id" varchar NOT NULL,
    "category_name" varchar,
    PRIMARY KEY ("id")
);



CREATE TABLE "accelerator_mentor_interaction" (
    "id" int NOT NULL,
    "student_id" int,
    "mentor_id" int,
    "cohort_code" varchar,
    "week_number" int,
    "total_session" int,
    "average_duration  " int,
    "attended_sessions " int,
    "hours_spent " int,
    "last_updated" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "mentor_registration_details" (
    "id" int NOT NULL,
    "mentor_id" int,
    "registration_date" date,    
    "form_details" JSONB,        ---(like: communication_languages)
    PRIMARY KEY ("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id")
);



CREATE TABLE "location" (
    "id" int NOT NULL,
    "country" varchar,
    "country_code" varchar,            --- like IN for India,AU for Australia,ZW for Zimbabwe
    "state_union_territory" varchar,
    "district" varchar,
    "location_category" enum,          -- Tier 1 city, Tier 2 city, Towns and Rural villages
    PRIMARY KEY ("id")
);



CREATE TABLE "mentor_details" (
    "id" int,
    "name" varchar,
    "email_id" varchar,
    "linkedIn_url" varchar,
    "current_position" varchar,
    "phone_number" varchar,
    "location_id" int,
    "joined_on" date,
    "is_active" boolean,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES location("id")
);



CREATE TABLE "student_documents" (
    "id" int NOT NULL,
    "student_id" int,
    "document_name" text,
    "document" bytea,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id")
);



CREATE TABLE "student_mentor" (
    "id" int NOT NULL,
    "mentor_id " int,
    "student_id" int,
    "cohort_code" varchar,
    "assigned_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "subject" (
    "id" int NOT NULL,
    "subject_name" varchar,
    "display_name" varchar,     -- name displayed in google form.
    PRIMARY KEY ("id")
);



CREATE TABLE "cohort" (
    "cohort_code" varchar NOT NULL,
    "program_code" varchar,
    "cohort_number" int,
    "cohort_name" varchar,
    "type" enum,                 -- type - open (Nationwide, open to all STEM students. Science and/or Engineering) and curriculum (Focused cohorts only for students from colleges under Govt. Partnerships - Telangana/ UK.)
    "start_date" date,
    "end_date" date,
    "is_active" boolean,
    PRIMARY KEY ("cohort_code"),
    FOREIGN KEY ("program_code") REFERENCES program("program_code")
);   



CREATE TABLE "college" (
    "id" int NOT NULL,
    "location_id" int,
    "university" varchar,       -- university names
    "college" varchar,           -- college names
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES location("id")
);



CREATE TABLE "mentor_cohort" (
    "id" int NOT NULL,
    "mentor_id" int,
    "cohort_code" varchar,
    "cohort_enroll_date" date,
    "is_active" boolean,
    "started_on" timestamp,
    "ended_on" timestamp,
    PRIMARY KEY ("id "),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "student_education" (
    "id" int NOT NULL,
    "student_id " int,
    "education_category_id" int,
    "education_course_id" int,
    "subject_id" int,
    "college_id" int,
    "start_year" int,
    "end_year" int,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("education_category_id") REFERENCES education_category("id"),
    FOREIGN KEY ("education_course_id") REFERENCES education_course("id"),
    FOREIGN KEY ("subject_id") REFERENCES subject("id"),
    FOREIGN KEY ("college_id") REFERENCES college("id")
);


CREATE INDEX "student_education_index_1"
ON "student_education" ("student_id ", "education_category_id");


CREATE TABLE "student_session" (
    "id" int NOT NULL,
    "student_id" int,
    "session_id" int,
    "duration(in minutes)" int,
    "watched on" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("session_id") REFERENCES session("id")
);



CREATE TABLE "student_quiz" (
    "id" int NOT NULL,
    "student_id" int,
    "resource_id" int,
    "cohort_code" varchar,
    "max_marks" int,
    "reattempts" int,
    "attempted_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "program" (
    "program_code" enum NOT NULL,          --- program_code- INC, ACC, STC
    "full_form" varchar,
    "start_date" date,
    PRIMARY KEY ("program_code")
);



CREATE TABLE "mentor_session" (
    "id" int NOT NULL,
    "session_id" int,
    "mentor_id" int,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("session_id") REFERENCES session("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id")
);



CREATE TABLE "cohort_resource" (
    "id" int NOT NULL,
    "resource_id" int,
    "cohort_code" varchar,
    "marks_weightage" int,
    "created_at" timestamp,
    "updated_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "accelerator_project_performance" (              
    "id" int NOT NULL,
    "student_id" int,
    "mentor_id" int,
    "cohort_code" varchar,
    "resource_id ??" int,
    "week_number" int,
    "project_name" text,
    "project_details" text,
    "awareness_score" int,
    "attentiveness_score" int,
    "quality_score" int,
    "overall_rating" int,
    "last_updated" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id")
);



CREATE TABLE "referral_college_professor" (
    "id" int NOT NULL,
    "student_id" int,
    "college_id" int,
    "name" varchar,
    "phone" varchar,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("college_id") REFERENCES college("id")
);



CREATE TABLE "session" (
    "id" int NOT NULL,
    "cohort_code" varchar,
    "session_name" text,
    "type" enum,                    -- type-  masterclass, SUK, workshop
    "duration(in minutes)" int,
    "is_pre_recorded" boolean,      
    "created_at" date,
    "updated_at" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "session_resource" (
    "id" int NOT NULL,
    "session_id" int,
    "resource_id" int,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("session_id") REFERENCES session("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id")
);



CREATE TABLE "mentor_resource" (
    "id" int NOT NULL,
    "resource_id" int,
    "mentor_id" int,
    "created_at" date,
    "updated_at" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id")
);



CREATE TABLE "student_pre_recorded" (
    "id" int NOT NULL,
    "student_id" int,
    "resource_id" int,
    "cohort_code" varchar,
    "watchtime" int,
    "watched_on" bigint,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);
