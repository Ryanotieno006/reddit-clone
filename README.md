# 🚀 Reddit Clone - SQL Database Backend

A fully functional Reddit-style discussion platform with MySQL database architecture. Supports user posts, nested comments, and voting systems.

## 📦 Database Schema
```sql
-- Simplified schema preview
users(user_id, username, email)
posts(post_id, user_id, title, content)
comments(comment_id, user_id, post_id, parent_comment_id, content)
votes(vote_id, user_id, post_id, comment_id, vote_value)
✨ Key Features
User System 👥

Secure accounts with unique usernames/emails

Timestamped activity tracking

Discussion Threads 💬

Post creation with titles and content

Nested comment replies (unlimited depth)

Voting System ⬆️⬇️

Upvote/downvote posts AND comments

Vote constraints prevent duplicates

🛠️ Technical Highlights
Optimized Queries

sql
-- Recursive CTE for comment threads
WITH RECURSIVE comment_thread AS (...)

-- Controversial posts algorithm
HAVING upvotes > 0 AND downvotes > 0
Performance Indexes

sql
CREATE INDEX idx_comments_post_parent ON comments(post_id, parent_comment_id);
CREATE INDEX idx_posts_created ON posts(created_at DESC);
🚀 Setup Instructions
Database Setup:

bash
mysql -u root -p < database.sql
Run Sample Queries:

sql
-- Get trending posts
SELECT p.title, SUM(v.vote_value) AS score 
FROM posts p LEFT JOIN votes v ON p.post_id = v.post_id 
GROUP BY p.post_id ORDER BY score DESC;
📊 Sample Data Included
Pre-loaded with:

3 test users (alice, bob, charlie)

Example posts and comment threads

Vote data for testing rankings

📜 License
MIT - Feel free to use as a learning resource!

Pro Tip: Add a frontend with Node.js/Express or PHP to complete the stack!


### Key Features of This README:
1. **Clean Visual Hierarchy** - Emojis and spacing make it scannable
2. **Code Snippets** - Shows your actual SQL implementation
3. **Technical Depth** - Highlights advanced features (recursive CTEs)
4. **Immediate Usability** - Includes setup commands

Want me to add any of these sections?
- [ ] Deployment instructions
- [ ] API endpoint examples
- [ ] Screenshot of sample query results
- [ ] Roadmap for future features

Just let me know which ones you'd like included!



