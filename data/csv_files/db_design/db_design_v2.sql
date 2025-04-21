--ChartDB VS Data Restructuring .sql script 

CREATE TABLE "education_course" (
    "id" int NOT NULL,
    "course_name" varchar(50),            -- name displayed in google form
    "display_name" varchar(100),
    PRIMARY KEY ("id")
);


CREATE TABLE "resource" (
    "id" int NOT NULL,
    "category" enum,                 -- category enum - pre-recorded,quiz,assignments,reference material.
    "title" varchar(300),
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
    "cohort_code" varchar(6),
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
    "cohort_code" varchar(6),
    "submission_status" enum,   -- accepted, rejected, under-review
    "marks_pct" decimal,
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
    "student_code" varchar(15) NOT NULL,     -- student_code :  year  + cohort_code + student_id e.g 24INC0010000001,24ACC0010000001
    "student_id" int,
    "cohort_code " varchar(6),
    "is_leader" boolean,
    "cohort_enroll_date" date,
    PRIMARY KEY ("student_code"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "student_details" (
    "id" int NOT NULL,
    "email" varchar(254),
    "first_name" varchar(100),
    "last_name" varchar(100),
    "gender" enum,         -- male, female and other
    "is_female" boolean,
    "is_indian" boolean,
    "phone" varchar(15),       -- To Do- Phone number should be 10 digit in dbt.Once the student selects country from the drop down, the form should populate the country code automatically
    "date_of_birth" date,
    "caste" enum,         -- OBC, ST/SC, Others
    "annual_family_income_inr" text,     -- Needs to be converted to range. (should be in INR)'
    "location_id" int,    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES location("id")
);



CREATE TABLE "education_category" (
    "id" int NOT NULL,
    "category_name" varchar(100),
    PRIMARY KEY ("id")
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
    "country" varchar(50),
    "country_code" varchar(2),            --- like IN for India,AU for Australia,ZW for Zimbabwe
    "state_union_territory" varchar(60),
    "district" varchar(60),
    "location_category" enum,          -- Tier 1 city, Tier 2 city, Towns and Rural villages
    PRIMARY KEY ("id")
);



CREATE TABLE "mentor_details" (
    "id" int,
    "name" varchar(50),
    "email_id" varchar(254),
    "linkedIn_url" varchar(200),
    "current_position" varchar(100),
    "phone_number" varchar(15),  ---can also be other country number hence assigned length 15
    "mentor_role"  enum,         --- SUK role model, Accelerator Mentor, Research Project Developers
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
    "cohort_code" varchar(6),
    "assigned_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "subject" (
    "id" int NOT NULL,
    "subject_name" varchar(100),
    "display_name" varchar(150),     -- name displayed in google form.
    PRIMARY KEY ("id")
);



CREATE TABLE "cohort" (
    "cohort_code" varchar(6) NOT NULL,    ---INC001,INC002,INC003,...
    "program_code" varchar(3),   ---INC,STC,ACC
    "cohort_number" int,
    "cohort_name" varchar(300),
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
    "university" varchar(200),       -- university names
    "college" varchar(200),           -- college names
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES location("id")
);



CREATE TABLE "mentor_cohort" (
    "id" int NOT NULL,
    "mentor_id" int,
    "cohort_code" varchar(6),
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
    "cohort_code" varchar(6),
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
    "full_form" varchar(20),
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
    "cohort_code" varchar(6),
    "marks_weightage" int,
    "created_at" timestamp,
    "updated_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);







CREATE TABLE "referral_college_professor" (
    "id" int NOT NULL,
    "student_id" int,
    "college_id" int,
    "name" varchar(50),
    "phone" varchar(15),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("college_id") REFERENCES college("id")
);



CREATE TABLE "session" (
    "id" int NOT NULL,
    "cohort_code" varchar(6),
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
    "cohort_code" varchar(6),
    "watchtime_in_min" int,
    "watched_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);


CREATE TABLE "accelerator_project_details" (              
    "id" int NOT NULL,
    "cohort_code" varchar(6),
    "project_title" text,
    "description" text,
    "marks" int,
    "start_date" date,
    "end_date" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
);



CREATE TABLE "accelerator_project_details_cost" (              
    "id" int NOT NULL,
    "project_details_id" int,
    "payment_details_id" int,
    "amount_inr" int,
    "paid_on" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("project_details_id") REFERENCES accelerator_project_details("id"),
    FOREIGN KEY ("payment_details_id") REFERENCES payment_details("id")
);




CREATE TABLE "accelerator_mentor_pre_recorded" (              
    "id" int NOT NULL,
    "mentor_id" int,
    "resource_id" int,
    "cohort_code" varchar(6),
    "watchtime_in_min" int,
    "watched_at" timestamp,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("resource_id") REFERENCES resource("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
); 




CREATE TABLE "accelerator_mentor_project" (              
    "id" int NOT NULL,
    "mentor_id" int,
    "project_details_id" int,
    "cohort_code" varchar(6),
    "is_active" boolean,
    "dropout_reason" text,
    "dropped_out_on" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("project_details_id") REFERENCES accelerator_project_details("id"),
    FOREIGN KEY ("cohort_code") REFERENCES cohort("cohort_code")
); 



CREATE TABLE "accelerator_student_project_performance" (              
    "id" int NOT NULL,
    "student_id" int,
    "project_details_id" int,
    "awareness_score" int,
    "attentiveness_score" int,
    "quality_score" int,
    "max_score" int,
    "tasks_assigned" text[],
    "theme" enum,           --- Week 1 :Project Initiation and Goal Setting, Week 2 :Project Planning and Development, Week 3:Review and Experimental Design(Capture attention)....
    "7E learning phase for this week" enum,   -- Elicit-Week 1-2, Engage -Week 3-5, Explore- Week 6-8, Explain -Week 9,....
    "is_active" boolean,
    "updated_at" timestamp,
    "dropout_reason" text,
    "dropped_out_on" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("project_details_id") REFERENCES accelerator_project_details("id")
);



---Need clarity regarding whether to keep the fields like interactions related to whatsapp as JSONB or not. For now have kept it as column fields.
CREATE TABLE "accelerator_student_mentor_interaction" (                
    "id" int NOT NULL,
    "student_id" int,
    "mentor_id" int,
    "project_details_id" int,
    "total_session" int,
    "average_duration" int,
    "attended_sessions" int,     
    "number_of_whatsapp_interaction" int,   
    "quality_of_interaction" enum,           --- Excellent,Good,Fair,Poor
    "weekly_interactions_project_progress" enum,  ----Not at all,Somewhat,Yes, substantially
    "updated_at" date,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("student_id") REFERENCES student_details("id"),
    FOREIGN KEY ("mentor_id") REFERENCES mentor_details("id"),
    FOREIGN KEY ("project_details_id") REFERENCES accelerator_project_details("id")
);
