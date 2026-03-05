--1.Participant's Registration & Profile View
---used by admin to view participant details

SELECT 
	p.participant_id,
	p.first_name,
	p.last_name,
	p.status,
	p.registration_date,
	c.name AS	category,
	s.name AS stage
FROM participants p
	LEFT JOIN categories c ON p.category_id = c.category_id
	LEFT JOIN stages s ON c.stage_id = s.stage_id


--2. Submission Tracking by Status
--- used to check submission status

SELECT 
	p.first_name || ' ' || p.last_name AS name,
	c.name AS category,
	ss.title,
	ss.description,
	ss.status,
	ss.submission_date
FROM participants p
	 JOIN submissions ss  ON p.participant_id = ss.participant_id
	JOIN categories c ON ss.category_id = c.category_id
ORDER BY ss.submission_date

--3.Judge Scoring Dashboard
---overview of judges evaluation

SELECT
	j.first_name || ' ' || j.last_name AS name,
	COUNT(e.evaluation_id) AS submisions_scored,
	ROUND(AVG (e.score),2) AS avg_score
FROM judges j
	JOIN evaluations e ON j.judge_id = e.judge_id
GROUP BY j.first_name || ' ' || j.last_name

---4.Stage Overview--
---view of participants by stages

SELECT
	COUNT(p.participant_id) AS participants,
	s.name AS stage,
FROM participants p
	LEFT JOIN stages s ON p.stage_id = s.stage_id
GROUP BY s.name

---5.Submission Scores (Per Submission)
---Used to review scores for a specific submission
SELECT
    s.submission_id,
    s.title,
    j.first_name || ' ' || j.last_name AS judge,
    e.score,
    e.comments
FROM evaluations e
JOIN submissions s ON e.submission_id = s.submission_id
JOIN judges j ON e.judge_id = j.judge_id
WHERE s.submission_id = 1;

--6.Category Performance Report
--Average scores by category

SELECT
    c.name AS category,
    ROUND(AVG(e.score), 2) AS avg_score,
    COUNT(DISTINCT sub.submission_id) AS total_submissions
FROM categories c
JOIN submissions sub ON c.category_id = sub.category_id
LEFT JOIN evaluations e ON sub.submission_id = e.submission_id
GROUP BY c.category_id;

--7.Audit Log Monitoring
--admins/support for accountability

SELECT
    user_type,
    action,
    details,
    action_time
FROM audit_logs
ORDER BY action_time DESC;


--8. Participants With No Submissions
--Critical operational query

SELECT
    p.participant_id,
    p.first_name,
    p.last_name,
    p.email
FROM participants p
LEFT JOIN submissions s ON p.participant_id = s.participant_id
WHERE s.submission_id IS NULL;