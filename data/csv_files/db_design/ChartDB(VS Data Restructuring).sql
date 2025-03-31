--ChartDB VS Data Restructuring .sql script 

CREATE TABLE "education_course" (
    "id" int NOT NULL,
    "course_name" varchar,
    -- name displayed in google form
    -- 
    "display_name" varchar,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "education_course"."display_name" IS 'name displayed in google form
';


CREATE TABLE "resource" (
    "id" int NOT NULL,
    -- pre-recorded,quiz,assignments,reference material.
    "category" enum,
    "title" varchar,
    "description" text,
    "location" enum,
    "resource_link" text,
    "duration" int,
    -- put a seed file for marks weightage. (out of what marks)
    -- 
    "marks_weightage" int,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "resource"."category" IS 'pre-recorded,quiz,assignments,reference material.';
COMMENT ON COLUMN "resource"."marks_weightage" IS 'put a seed file for marks weightage. (out of what marks)
';


CREATE TABLE "payment_details" (
    "id" int,
    "role_id" int,
    "role_type" enum,
    "cohort_code" varchar,
    "paid_amount" decimal,
    "fee_received" decimal,
    "mode_of_payment" enum,
    "transaction_date" timestamp,
    PRIMARY KEY ("id")
);



CREATE TABLE "student_registration_details" (
    "id" int,
    "student_id" int,
    "assigned_through" enum,
    -- Needs to be defined.
    "how_did_you_hear_about_us" enum,
    -- To inform us when they register in our system i.e timestamp
    "registration_date" date,
    "is_studying_STEM_fields" boolean,
    "reason for applying " text,
    "problems_faced_in_studies_and_career?" text,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "student_registration_details"."how_did_you_hear_about_us" IS 'Needs to be defined.';
COMMENT ON COLUMN "student_registration_details"."registration_date" IS 'To inform us when they register in our system i.e timestamp';


CREATE TABLE "student_assignment" (
    "id" int NOT NULL,
    "student_id" int,
    "resource_id" int,
    "mentor_id" int,
    "cohort_code" varchar,
    "submission_status" enum,
    "marks" int,
    "feedback/comments" text,
    "submitted_at" timestamp,
    -- should we include the assignment file upload in database
    "assignment_file?????" blob,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "student_assignment"."assignment_file?????" IS 'should we include the assignment file upload in database';


CREATE TABLE "student_cohort" (
    -- student_code : enroll year + student_id + cohort_code 
    "student_code" varchar NOT NULL,
    "student_id" int,
    "cohort_code " varchar,
    "is_leader" boolean,
    "cohort_enroll_date" date,
    PRIMARY KEY ("student_code")
);

COMMENT ON COLUMN "student_cohort"."student_code" IS 'student_code : enroll year + student_id + cohort_code ';


CREATE TABLE "student_details" (
    "id" int NOT NULL,
    "email" varchar,
    "first_name" varchar,
    "last_name" varchar,
    "is_female" boolean,
    "is_indian" boolean,
    -- pls dont enter country code. How should we deal with phone number
    "phone" varchar,
    "date_of_birth" date,
    "caste" enum,
    -- Needs to be converted to range. (should be in INR)
    "annual_family_income" int,
    -- For many to one relation its best to placeit in student details table. if placed in location table it will act as one to many i.e one location can have only one student.
    "location_id" int,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "student_details"."phone" IS 'pls dont enter country code. How should we deal with phone number';
COMMENT ON COLUMN "student_details"."annual_family_income" IS 'Needs to be converted to range. (should be in INR)';
COMMENT ON COLUMN "student_details"."location_id" IS 'For many to one relation its best to placeit in student details table. if placed in location table it will act as one to many i.e one location can have only one student.';


CREATE TABLE "education_category" (
    "id" varchar NOT NULL,
    "category_name" varchar,
    PRIMARY KEY ("id")
);



CREATE TABLE "mentor_Interaction" (
    "id" int NOT NULL,
    "student_id " int,
    "mentor_id" int,
    "cohort_code" varchar,
    "week_number" int,
    "total_session " int,
    "average_duration  " int,
    "attended_sessions " int,
    "hours_spent " int,
    "last_updated " timestamp,
    PRIMARY KEY ("id")
);



CREATE TABLE "mentor_questions" (
    "id" int NOT NULL,
    "mentor_id" int,
    "communication languages" enum,
    "How many years have you worked as a STEM professionalwould you like to join VigyanShaala's #SheforSTEM movement" enum,
    "Would you like to schedule a 10-15 minute call with us for unde" enum,
    "re_details_id(resume,headshot)" blob,
    "If we cover travel costs, are you willing to travel out-of-town" enum,
    "Which of the following workshops would you like to conduct" enum,
    "Based on the choices you made in the previous question, do yo" enum,
    "How many such workshops have you conducted so far?" enum,
    "If possible, please upload a sample of your work" blob,
    "How many years have you workeh as a STEM professionalwould you like to join VigyanShaala's #SheforSTEM movement" enum,
    PRIMARY KEY ("id")
);



CREATE TABLE "location" (
    "id" int NOT NULL,
    "country" varchar,
    "state_union_territory" varchar,
    "district " varchar,
    "location_category" enum,
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
    "is_active" boolean
);



CREATE TABLE "documents" (
    "id" int NOT NULL,
    "student_id" int,
    "document_name" text,
    "document" blob,
    PRIMARY KEY ("id")
);



CREATE TABLE "student_mentor" (
    "id" int NOT NULL,
    "mentor_id " int,
    "student_id" int,
    "cohort_code" varchar,
    "assigned_at" timestamp,
    PRIMARY KEY ("id")
);



CREATE TABLE "subject" (
    "id" int NOT NULL,
    "subject_name" varchar,
    -- name displayed in google form.
    -- 
    "display_name" varchar,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "subject"."display_name" IS 'name displayed in google form.
';


CREATE TABLE "cohort" (
    "cohort_code" varchar NOT NULL,
    "program_code" varchar,
    -- Inc and acc the cohort number will get start form 1 and it will be not an unique column
    "cohort_number" int,
    "cohort_name" varchar,
    "type" enum,
    "start_date" date,
    "end_date" date,
    "is_active" boolean,
    PRIMARY KEY ("cohort_code")
);

COMMENT ON COLUMN "cohort"."cohort_number" IS 'Inc and acc the cohort number will get start form 1 and it will be not an unique column';


-- should be college and university in just one column???? 
CREATE TABLE "college" (
    "id" int NOT NULL,
    "location_id" int,
    "university " enum,
    "college" enum,
    PRIMARY KEY ("id")
);

COMMENT ON TABLE "college" IS 'should be college and university in just one column???? ';



CREATE TABLE "mentor_cohort" (
    "id " int NOT NULL,
    "mentor_id" int,
    "cohort_code" varchar,
    "cohort_enroll_date" date,
    "is_active" boolean,
    "created_at" timestamp,
    PRIMARY KEY ("id ")
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
    PRIMARY KEY ("id")
);


CREATE INDEX "student_education_index_1"
ON "student_education" ("student_id ", "education_category_id");


CREATE TABLE "student_session" (
    "id" int NOT NULL,
    "student_id " int,
    "session_id" int,
    "duration(in minutes)" int,
    "watched on" date,
    PRIMARY KEY ("id")
);



CREATE TABLE "student_quiz" (
    "id" int NOT NULL,
    "student_id " int,
    "resource_id " int,
    "cohort_code" varchar,
    "marks " int,
    "attempted_at" timestamp,
    PRIMARY KEY ("id")
);



CREATE TABLE "program" (
    "program_code" enum NOT NULL,
    "full_form" varchar,
    "start_date" date,
    PRIMARY KEY ("program_code")
);



CREATE TABLE "mentor_session" (
    "id" int NOT NULL,
    "session_id" int,
    "mentor_id" int,
    PRIMARY KEY ("id")
);



CREATE TABLE "cohort_resource" (
    "id" int NOT NULL,
    "resource_id " int,
    "cohort_code" varchar,
    PRIMARY KEY ("id")
);



CREATE TABLE "project_performance" (
    "id" int NOT NULL,
    "student_id " int,
    "mentor_id" int,
    "cohort_code" varchar,
    "resource_id ??" int,
    "week_number" int,
    "project_name" text,
    "project_details " text,
    "awareness_score " int,
    "attentiveness_score " int,
    "quality_score " int,
    "overall_rating " int,
    "last_updated " timestamp,
    PRIMARY KEY ("id")
);



CREATE TABLE "professor" (
    "id" int NOT NULL,
    "student_id" int,
    "college_id" int,
    "name" varchar,
    "phone" varchar,
    PRIMARY KEY ("id")
);



CREATE TABLE "session" (
    "id" int NOT NULL,
    "cohort_code" varchar,
    "duration(in minutes)" int,
    -- masterclass, SUK, workshop
    "type" enum,
    "is_pre_recorded" enum,
    "created_at" date,
    "updated_at" date,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "session"."type" IS 'masterclass, SUK, workshop';


CREATE TABLE "resource_cohort" (
    "id" int NOT NULL,
    "resource_id" int,
    "cohort_code" varchar,
    PRIMARY KEY ("id")
);



CREATE TABLE "session_resource" (
    "id" int NOT NULL,
    "session_id" int,
    "resource_id" int,
    PRIMARY KEY ("id")
);



CREATE TABLE "mentor_resource" (
    "id" int NOT NULL,
    "resource_id" int,
    "mentor_id" int,
    "created_at" date,
    "updated_at" date,
    PRIMARY KEY ("id")
);



ALTER TABLE "student_assignment"
ADD CONSTRAINT "fk_student_assignment_mentor_id_mentor_details_id" FOREIGN KEY("mentor_id") REFERENCES "mentor_details"("id");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_mentor_Interaction_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "mentor_Interaction"("cohort_code");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_project_performance_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "project_performance"("cohort_code");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_student_assignment_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "student_assignment"("cohort_code");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_cohort_resource_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "cohort_resource"("cohort_code");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_student_mentor_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "student_mentor"("cohort_code");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_student_quiz_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "student_quiz"("cohort_code");

ALTER TABLE "cohort"
ADD CONSTRAINT "fk_cohort_cohort_code_student_cohort_cohort_code_" FOREIGN KEY("cohort_code") REFERENCES "student_cohort"("cohort_code ");

ALTER TABLE "college"
ADD CONSTRAINT "fk_college_id_student_education_college_id" FOREIGN KEY("id") REFERENCES "student_education"("college_id");

ALTER TABLE "location"
ADD CONSTRAINT "fk_location_id_college_location_id" FOREIGN KEY("id") REFERENCES "college"("location_id");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_location_id_location_id" FOREIGN KEY("location_id") REFERENCES "location"("id");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_id_mentor_questions_mentor_id" FOREIGN KEY("id") REFERENCES "mentor_questions"("mentor_id");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_id_mentor_cohort_mentor_id" FOREIGN KEY("id") REFERENCES "mentor_cohort"("mentor_id");

ALTER TABLE "mentor_cohort"
ADD CONSTRAINT "fk_mentor_cohort_mentor_id_student_mentor_mentor_id_" FOREIGN KEY("mentor_id") REFERENCES "student_mentor"("mentor_id ");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_id_mentor_Interaction_mentor_id" FOREIGN KEY("id") REFERENCES "mentor_Interaction"("mentor_id");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_id_mentor_session_mentor_id" FOREIGN KEY("id") REFERENCES "mentor_session"("mentor_id");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_id_project_performance_mentor_id" FOREIGN KEY("id") REFERENCES "project_performance"("mentor_id");

ALTER TABLE "mentor_cohort"
ADD CONSTRAINT "fk_mentor_cohort_cohort_code_cohort_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "cohort"("cohort_code");

ALTER TABLE "payment_details"
ADD CONSTRAINT "fk_payment_details_cohort_code_cohort_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "cohort"("cohort_code");

ALTER TABLE "professor"
ADD CONSTRAINT "fk_professor_college_id_college_id" FOREIGN KEY("college_id") REFERENCES "college"("id");

ALTER TABLE "professor"
ADD CONSTRAINT "fk_professor_student_id_student_details_id" FOREIGN KEY("student_id") REFERENCES "student_details"("id");

ALTER TABLE "program"
ADD CONSTRAINT "fk_program_program_code_cohort_program_code" FOREIGN KEY("program_code") REFERENCES "cohort"("program_code");

ALTER TABLE "student_registration_details"
ADD CONSTRAINT "fk_student_registration_details_student_id_student_details_i" FOREIGN KEY("student_id") REFERENCES "student_details"("id");

ALTER TABLE "resource"
ADD CONSTRAINT "fk_resource_id_project_performance_resource_id___" FOREIGN KEY("id") REFERENCES "project_performance"("resource_id ??");

ALTER TABLE "resource"
ADD CONSTRAINT "fk_resource_id_cohort_resource_resource_id_" FOREIGN KEY("id") REFERENCES "cohort_resource"("resource_id ");

ALTER TABLE "resource"
ADD CONSTRAINT "fk_resource_id_student_assignment_resource_id" FOREIGN KEY("id") REFERENCES "student_assignment"("resource_id");

ALTER TABLE "resource"
ADD CONSTRAINT "fk_resource_id_student_quiz_resource_id_" FOREIGN KEY("id") REFERENCES "student_quiz"("resource_id ");

ALTER TABLE "student_session"
ADD CONSTRAINT "fk_student_session_id_mentor_session_session_id" FOREIGN KEY("id") REFERENCES "mentor_session"("session_id");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_student_education_student_id_" FOREIGN KEY("id") REFERENCES "student_education"("student_id ");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_student_cohort_student_id" FOREIGN KEY("id") REFERENCES "student_cohort"("student_id");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_location_id_location_id" FOREIGN KEY("location_id") REFERENCES "location"("id");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_documents_student_id" FOREIGN KEY("id") REFERENCES "documents"("student_id");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_student_quiz_student_id_" FOREIGN KEY("id") REFERENCES "student_quiz"("student_id ");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_student_mentor_student_id" FOREIGN KEY("id") REFERENCES "student_mentor"("student_id");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_student_session_student_id_" FOREIGN KEY("id") REFERENCES "student_session"("student_id ");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_project_performance_student_id_" FOREIGN KEY("id") REFERENCES "project_performance"("student_id ");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_mentor_Interaction_student_id_" FOREIGN KEY("id") REFERENCES "mentor_Interaction"("student_id ");

ALTER TABLE "student_details"
ADD CONSTRAINT "fk_student_details_id_student_assignment_student_id" FOREIGN KEY("id") REFERENCES "student_assignment"("student_id");

ALTER TABLE "student_education"
ADD CONSTRAINT "fk_student_education_education_category_id_education_categor" FOREIGN KEY("education_category_id") REFERENCES "education_category"("id");

ALTER TABLE "student_education"
ADD CONSTRAINT "fk_student_education_education_course_id_education_course_id" FOREIGN KEY("education_course_id") REFERENCES "education_course"("id");

ALTER TABLE "student_education"
ADD CONSTRAINT "fk_student_education_subject_id_subject_id" FOREIGN KEY("subject_id") REFERENCES "subject"("id");

ALTER TABLE "student_session"
ADD CONSTRAINT "fk_student_session_session_id_session_id" FOREIGN KEY("session_id") REFERENCES "session"("id");

ALTER TABLE "payment_details"
ADD CONSTRAINT "fk_payment_details_role_id_mentor_details_id" FOREIGN KEY("role_id") REFERENCES "mentor_details"("id");

ALTER TABLE "payment_details"
ADD CONSTRAINT "fk_payment_details_role_id_student_details_id" FOREIGN KEY("role_id") REFERENCES "student_details"("id");

ALTER TABLE "session"
ADD CONSTRAINT "fk_session_cohort_code_cohort_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "cohort"("cohort_code");

ALTER TABLE "session_resource"
ADD CONSTRAINT "fk_session_resource_session_id_session_id" FOREIGN KEY("session_id") REFERENCES "session"("id");

ALTER TABLE "session_resource"
ADD CONSTRAINT "fk_session_resource_resource_id_resource_id" FOREIGN KEY("resource_id") REFERENCES "resource"("id");

ALTER TABLE "resource"
ADD CONSTRAINT "fk_resource_id_mentor_resource_resource_id" FOREIGN KEY("id") REFERENCES "mentor_resource"("resource_id");

ALTER TABLE "resource"
ADD CONSTRAINT "fk_resource_id_resource_cohort_resource_id" FOREIGN KEY("id") REFERENCES "resource_cohort"("resource_id");

ALTER TABLE "mentor_details"
ADD CONSTRAINT "fk_mentor_details_id_mentor_resource_mentor_id" FOREIGN KEY("id") REFERENCES "mentor_resource"("mentor_id");

ALTER TABLE "resource_cohort"
ADD CONSTRAINT "fk_resource_cohort_cohort_code_cohort_cohort_code" FOREIGN KEY("cohort_code") REFERENCES "cohort"("cohort_code");
