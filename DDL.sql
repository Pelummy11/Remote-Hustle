--Stages--
---keeps track of the stages in the competition  
CREATE TABLE stages (
    stage_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'open',
    CHECK (status IN ('open', 'closed', 'in_progress'))
);
---Categories---
---defines competiton categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    stage_id INT,
    CONSTRAINT fk_category_stage
        FOREIGN KEY (stage_id)
        REFERENCES stages(stage_id)
        ON DELETE SET NULL
);
---Participants---
---stores information about participants in the competition--

CREATE TABLE participants (
    participant_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    category_id INT,
    stage_id INT,
    registration_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'active',
    CHECK (status IN ('active', 'inactive', 'disqualified')),
    CONSTRAINT fk_participant_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_participant_stage
        FOREIGN KEY (stage_id)
        REFERENCES stages(stage_id)
        ON DELETE SET NULL
);

---Judges---
---Stores information about judges evaluating the submissions
CREATE TABLE judges (
    judge_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) DEFAULT 'judge',
    stage_id INT,
    CHECK (role IN ('judge', 'admin', 'support')),
    CONSTRAINT fk_judge_stage
        FOREIGN KEY (stage_id)
        REFERENCES stages(stage_id)
        ON DELETE SET NULL
);
---Submissions---
---keeps track of submissions made in the competition

CREATE TABLE submissions (
    submission_id SERIAL PRIMARY KEY,
    participant_id INT NOT NULL,
    category_id INT,
    stage_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    file_link TEXT,
    submission_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'pending',
    CHECK (status IN ('pending', 'reviewed', 'scored')),
    CONSTRAINT fk_submission_participant
        FOREIGN KEY (participant_id)
        REFERENCES participants(participant_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_submission_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_submission_stage
        FOREIGN KEY (stage_id)
        REFERENCES stages(stage_id)
        ON DELETE CASCADE
);
---Evaluation---
---tracks judges evaluation on submissions made---
CREATE TABLE evaluations (
    evaluation_id SERIAL PRIMARY KEY,
    submission_id INT NOT NULL,
    judge_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL CHECK (score >= 0),
    comments TEXT,
    evaluation_date TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_evaluation_submission
        FOREIGN KEY (submission_id)
        REFERENCES submissions(submission_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_evaluation_judge
        FOREIGN KEY (judge_id)
        REFERENCES judges(judge_id)
        ON DELETE CASCADE,
    CONSTRAINT unique_judge_submission ---prevents a judge from scoring the same submission twice
        UNIQUE (submission_id, judge_id)
);
---Roles--
---defines roles and what they can do
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    permissions JSONB
);
---Audit logs---
---logs important action in the system

CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_type VARCHAR(20) NOT NULL,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    action_time TIMESTAMP DEFAULT NOW(),
    CHECK (user_type IN ('participant', 'judge', 'admin'))
);


CREATE INDEX idx_participant_email ON participants(email);
CREATE INDEX idx_submission_status ON submissions(status);
CREATE INDEX idx_evaluation_score ON evaluations(score);
CREATE INDEX idx_audit_action_time ON audit_logs(action_time);
