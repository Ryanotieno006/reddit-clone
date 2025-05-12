USE reddit_clone;

CREATE TABLE users(
user_id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(50) UNIQUE NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts(
post_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
title VARCHAR(200) NOT NULL,
content TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE comments(
comment_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
post_id INT NOT NULL,
parent_comment_id INT NULL,
content TEXT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY(post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
FOREIGN KEY(parent_comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE
);

CREATE TABLE votes(
vote_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
post_id INT NULL,
comment_id INT NULL,
vote_value TINYINT NOT NULL,
FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY(post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
FOREIGN KEY(comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
CONSTRAINT one_vote_per_entity CHECK(
    (post_id IS NOT NULL AND comment_id IS NULL) OR
    (post_id IS NULL AND comment_id IS NOT NULL)
)
);

INSERT INTO users(username, email, created_at)VALUES
('alice', 'alice@gmail.com', '2023-01-15 10:00:00'),
('bob', 'bob@gmail.com', '2023-01-16 11:30:00'),
('charlie', 'charlie@gmail.com', '2023-01-17 09:15:00');

INSERT INTO posts(user_id, title, content, created_at)VALUES
(1, 'How to learn SQL', 'Looking for beginner resources.', '2023-01-18 14:00:00'),
(2, 'Best programming language?', 'Debate time!', '2023-01-19 16:30:00'),
(3, 'MySQL vs PostgreSQL', 'Which do you prefer?', '2023-01-20 10:45:00');

INSERT INTO comments(user_id, post_id, parent_comment_id, content, created_at)VALUES
(2, 1, NULL, 'Start with SQLZoo tutorials!', '2023-01-18 15:30:00'),
(3, 1, NULL, 'The book "Learning SQL" is great.', '2023-01-18 16:45:00'),
(1, 2, NULL, 'Python is the best!', '2023-01-19 17:15:00');

INSERT INTO comments(user_id, post_id, parent_comment_id, content, created_at)VALUES
(1, 1, 1, 'SQLZoo helped me too!', '2023-01-18 18:00:00'),
(2, 1, 2, 'I prefer video courses.', '2023-01-18 19:30:00'),
(3, 2, 3, 'No way, JavaScript rules!', '2023-01-19 18:45:00');

INSERT INTO votes(user_id, post_id, comment_id, vote_value)VALUES
(1, 2, NULL, 1),
(2, 1, NULL, -1),
(3, 1, NULL, 1);

INSERT INTO votes(user_id, post_id, comment_id, vote_value)VALUES
(1, NULL, 1, 1),
(2, NULL, 1, -1),
(3, NULL, 3, 1);

SELECT * FROM users;
SELECT * FROM posts;
SELECT * FROM comments;
SELECT * FROM votes;

SELECT username, email FROM users;

SELECT p.title, p.content, p.created_at
FROM posts p
ORDER BY created_at DESC LIMIT 5;

SELECT * FROM posts WHERE user_id = (SELECT user_id FROM users WHERE username='alice');
SELECT * FROM comments WHERE content LIKE '%SQL%';

SELECT p.post_id, p.title, COUNT(v.vote_id) AS vote_count
FROM posts p
LEFT JOIN votes v ON p.post_id=v.post_id
GROUP BY p.post_id
ORDER BY vote_count DESC
LIMIT 5;

SELECT p.title, u.username
FROM posts p
JOIN users u ON p.user_id=u.user_id;

SELECT c.content, p.title, u.username
FROM comments c
JOIN posts p ON c.post_id=p.post_id
JOIN users u ON c.user_id=u.user_id;

SELECT p.title, COUNT(c.comment_id) AS comment_count
FROM posts p
LEFT JOIN comments c ON p.post_id=c.post_id
GROUP BY p.post_id;

SELECT p.title,
SUM(CASE WHEN v.vote_value=1 THEN 1 ELSE 0 END) AS upvotes,
SUM(CASE WHEN v.vote_value=-1 THEN 1 ELSE 0 END) AS downvotes,
SUM(v.vote_value) AS net_score
FROM posts p
LEFT JOIN votes v ON p.post_id=v.post_id
GROUP BY p.post_id;

SELECT u.username, COUNT(c.comment_id) AS comment_count
FROM users u
LEFT JOIN comments c ON u.user_id=c.user_id
GROUP BY u.username;

SELECT * FROM posts
WHERE created_at >= CURRENT_DATE - INTERVAL 1 DAY
AND created_at < CURRENT_DATE;

WITH RECURSIVE comment_thread AS (
SELECT comment_id, content, parent_comment_id, 0 AS depth
FROM comments
WHERE post_id=1 AND parent_comment_id IS NULL
UNION ALL
SELECT c.comment_id, c.content, c.parent_comment_id, ct.depth + 1
FROM comments c
JOIN comment_thread ct ON c.parent_comment_id=ct.comment_id
)
SELECT * FROM comment_thread ORDER BY depth;

SELECT p.post_id, p.title, 
COUNT(CASE WHEN v.vote_value=1 THEN 1 END) AS upvotes,
COUNT(CASE WHEN v.vote_value=-1 THEN 1 END) AS downvotes,
ABS(COUNT(CASE WHEN v.vote_value=1 THEN 1 END) -
    COUNT(CASE WHEN v.vote_value=-1 THEN 1 END)) AS vote_difference
FROM posts p
LEFT JOIN votes v ON p.post_id=v.post_id
GROUP BY p.post_id
HAVING upvotes>0 AND downvotes>0
ORDER BY vote_difference ASC, (upvotes+downvotes)DESC
LIMIT 5;

CREATE INDEX idx_posts_user ON posts(user_id);
CREATE INDEX idx_posts_created ON posts(created_at DESC);
CREATE INDEX idx_posts_title ON posts(title);

CREATE INDEX idx_comments_user ON comments(user_id);
CREATE INDEX idx_comments_post_parent ON comments(post_id, parent_comment_id);







