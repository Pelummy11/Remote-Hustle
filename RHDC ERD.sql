CREATE TABLE "stages" (
  "stage_id" SERIAL PRIMARY KEY,
  "name" "VARCHAR(50)" NOT NULL,
  "start_date" DATE NOT NULL,
  "end_date" DATE NOT NULL,
  "status" "VARCHAR(20)" DEFAULT 'open',
  CHECK (status IN ('open', 'closed', 'in_progress'))
);

CREATE TABLE "categories" (
  "category_id" SERIAL PRIMARY KEY,
  "name" "VARCHAR(50)" UNIQUE NOT NULL,
  "description" TEXT,
  "stage_id" INT
);

CREATE TABLE "participants" (
  "participant_id" SERIAL PRIMARY KEY,
  "first_name" "VARCHAR(50)" NOT NULL,
  "last_name" "VARCHAR(50)" NOT NULL,
  "email" "VARCHAR(100)" UNIQUE NOT NULL,
  "phone_number" "VARCHAR(20)",
  "category_id" INT,
  "stage_id" INT,
  "registration_date" TIMESTAMP DEFAULT (NOW()),
  "status" "VARCHAR(20)" DEFAULT 'active',
  CHECK (status IN ('active', 'inactive', 'disqualified'))
);

CREATE TABLE "judges" (
  "judge_id" SERIAL PRIMARY KEY,
  "first_name" "VARCHAR(50)" NOT NULL,
  "last_name" "VARCHAR(50)" NOT NULL,
  "email" "VARCHAR(100)" UNIQUE NOT NULL,
  "role" "VARCHAR(20)" DEFAULT 'judge',
  "stage_id" INT,
  CHECK (role IN ('judge', 'admin', 'support'))
);

CREATE TABLE "submissions" (
  "submission_id" SERIAL PRIMARY KEY,
  "participant_id" INT NOT NULL,
  "category_id" INT,
  "stage_id" INT NOT NULL,
  "title" "VARCHAR(100)" NOT NULL,
  "description" TEXT,
  "file_link" TEXT,
  "submission_date" TIMESTAMP DEFAULT (NOW()),
  "status" "VARCHAR(20)" DEFAULT 'pending',
  CHECK (status IN ('pending', 'reviewed', 'scored'))
);

CREATE TABLE "evaluations" (
  "evaluation_id" SERIAL PRIMARY KEY,
  "submission_id" INT NOT NULL,
  "judge_id" INT NOT NULL,
  "score" "DECIMAL(5,2)" NOT NULL CHECK (score >= 0),
  "comments" TEXT,
  "evaluation_date" TIMESTAMP DEFAULT (NOW())
);

CREATE TABLE "roles" (
  "role_id" SERIAL PRIMARY KEY,
  "name" "VARCHAR(50)" UNIQUE NOT NULL,
  "description" TEXT,
  "permissions" JSONB
);

CREATE TABLE "audit_logs" (
  "log_id" SERIAL PRIMARY KEY,
  "user_type" "VARCHAR(20)" NOT NULL,
  "user_id" INT,
  "action" "VARCHAR(100)" NOT NULL,
  "details" TEXT,
  "action_time" TIMESTAMP DEFAULT (NOW()),
  CHECK (user_type IN ('participant', 'judge', 'admin'))
);

CREATE INDEX "idx_participant_email" ON "participants" ("email");

CREATE INDEX "idx_submission_status" ON "submissions" ("status");

CREATE UNIQUE INDEX "unique_judge_submission" ON "evaluations" ("submission_id", "judge_id");

CREATE INDEX "idx_evaluation_score" ON "evaluations" ("score");

CREATE INDEX "idx_audit_action_time" ON "audit_logs" ("action_time");

ALTER TABLE "categories" ADD CONSTRAINT "fk_category_stage" FOREIGN KEY ("stage_id") REFERENCES "stages" ("stage_id") ON DELETE SET NULL DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "participants" ADD CONSTRAINT "fk_participant_category" FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id") ON DELETE SET NULL DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "participants" ADD CONSTRAINT "fk_participant_stage" FOREIGN KEY ("stage_id") REFERENCES "stages" ("stage_id") ON DELETE SET NULL DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "judges" ADD CONSTRAINT "fk_judge_stage" FOREIGN KEY ("stage_id") REFERENCES "stages" ("stage_id") ON DELETE SET NULL DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "submissions" ADD CONSTRAINT "fk_submission_participant" FOREIGN KEY ("participant_id") REFERENCES "participants" ("participant_id") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "submissions" ADD CONSTRAINT "fk_submission_category" FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id") ON DELETE SET NULL DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "submissions" ADD CONSTRAINT "fk_submission_stage" FOREIGN KEY ("stage_id") REFERENCES "stages" ("stage_id") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "evaluations" ADD CONSTRAINT "fk_evaluation_submission" FOREIGN KEY ("submission_id") REFERENCES "submissions" ("submission_id") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "evaluations" ADD CONSTRAINT "fk_evaluation_judge" FOREIGN KEY ("judge_id") REFERENCES "judges" ("judge_id") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
