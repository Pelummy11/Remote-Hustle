--seed stages table--
INSERT INTO stages (name, start_date, end_date, status) VALUES
('Registration', '2025-01-01', '2025-01-07', 'closed'),
('Qualifiers', '2025-01-08', '2025-01-20', 'closed'),
('Semi Finals', '2025-01-21', '2025-02-05', 'in_progress'),
('Finals', '2025-02-06', '2025-02-15', 'open');

---seed categories table---
INSERT INTO categories (name, description, stage_id) VALUES
('Data Analytics', 'Analytics & BI challenges', 2),
('Backend Development', 'APIs & databases', 2),
('UI/UX Design', 'Design-focused challenges', 2),
('Technical Writing', 'Documentation & content', 2),
('Digital Marketing', 'Digital Marketing Challenges', 2),
('Social Media Management', 'Social Media Content Management', 2);---stage_id defined as 2 because, particpant is in a category only after they've qualified in the competiton, whis is inn stage 2

--- seed roles table--
INSERT INTO roles (name, description, permissions) VALUES
('admin', 'Full system access',
 '{"manage_users": true, "view_reports": true, "score_submissions": true}'),
('judge', 'Can score submissions',
 '{"score_submissions": true, "view_submissions": true}'),
('support', 'Support & monitoring',
 '{"view_users": true, "view_logs": true}');
 
 ---seed judges table---
 INSERT INTO judges (first_name, last_name, email, role, stage_id) VALUES
('Amina', 'Yusuf', 'amina.judge@remotehustle.io', 'judge', 2),
('Daniel', 'Okoro', 'daniel.judge@remotehustle.io', 'judge', 2),
('Sarah', 'Mensah', 'sarah.judge@remotehustle.io', 'judge', 3),
('Admin', 'User', 'admin@remotehustle.io', 'admin', NULL);

--- seed participant table---
INSERT INTO participants (
    first_name, 
	last_name, 
	email, 
	phone_number,
    category_id, 
	stage_id, 
	status
)
SELECT
    'Participant' || gs,
    'User' || gs,
    'participant' || gs || '@example.com',
    '+234800000' || gs,
    (gs % 4) + 1,
    2,
    'active'
FROM generate_series(1, 100) AS gs;

---seed submissions table---
INSERT INTO submissions (
    participant_id, 
	category_id, 
	stage_id,
    title, 
	description, 
	file_link, 
	status
)
SELECT
    gs,
    (gs % 4) + 1,
    2,
    'Challenge Submission ' || gs,
    'Submission for Remote Hustle Qualifiers',
    'https://github.com/user/submission' || gs,
    CASE
        WHEN gs % 3 = 0 THEN 'scored'
        WHEN gs % 2 = 0 THEN 'reviewed'
        ELSE 'pending'
    END
FROM generate_series(1, 50) AS gs;

---seed evaluations table---
INSERT INTO evaluations (
    submission_id, 
	judge_id, 
	score, 
	comments
)
SELECT
    gs,
    (gs % 3) + 1,
    ROUND((RANDOM() * 40 + 60)::numeric, 2),
    'Well-structured submission with clear logic'
FROM generate_series(1, 20) AS gs;

---seed audit logs--
INSERT INTO audit_logs (
	user_type,
	user_id,
	action, 
	details
)
VALUES
('participant', 1, 'submission_created', 'Participant submitted a challenge'),
('judge', 1, 'evaluation_added', 'Judge scored a submission'),
('admin', NULL, 'stage_updated', 'Stage moved to in_progress'),
('participant', 5, 'profile_updated', 'Participant updated profile details');
