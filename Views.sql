--1
.View: Participant Average Scores

CREATE VIEW participant_avg_scores AS
SELECT
    p.participant_id,
    p.first_name,
    p.last_name,
    ROUND(AVG(e.score), 2) AS average_score
FROM participants p
JOIN submissions s ON p.participant_id = s.participant_id
JOIN evaluations e ON s.submission_id = e.submission_id
GROUP BY p.participant_id;


--2. View: Leaderboard
CREATE VIEW leaderboard AS
SELECT
    p.first_name || ' ' || p.last_name AS participant,
    c.name AS category,
    ROUND(AVG(e.score), 2) AS avg_score
FROM participants p
JOIN submissions s ON p.participant_id = s.participant_id
JOIN evaluations e ON s.submission_id = e.submission_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY participant, c.name
ORDER BY avg_score DESC;