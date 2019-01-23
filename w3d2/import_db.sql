PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);


CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL, 
  body VARCHAR(255) NOT NULL,
  asker_id INTEGER NOT NULL,

  FOREIGN KEY (asker_id) REFERENCES users(id)
);


CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  subject_question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  parent_reply_id INTEGER,

  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);


CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  likes_question_id INTEGER NOT NULL,
  liker_id INTEGER NOT NULL,

  FOREIGN KEY (likes_question_id) REFERENCES questions(id),
  FOREIGN KEY (liker_id) REFERENCES users(id)
);

INSERT INTO 
  users (fname, lname)
VALUES
  ('Dean', 'Lacap'),
  ('Niyati', 'Desai'),
  ('Marianna', 'Mullens'),
  ('Dany', 'Kolhs'),
  ('Rachel', 'Bloomingdales');

INSERT INTO 
  questions (title, body, asker_id)
VALUES 
  ('ruby classes', 'What is the difference between inst ance and class methods?', 1),
  ('sql', 'What are the common sql commands?', 2),
  ('javascript', 'What is asynschronous?', 3),
  ('bootcamp prep', 'Is the programming language in Ruby or Javascript?', 4);

INSERT INTO 
  question_follows (question_id, user_id)
VALUES 
  (1, 1), 
  (2, 2),
  (3, 3),
  (4, 4);

  -- body VARCHAR(255) NOT NULL,
  -- subject_question_id INTEGER NOT NULL,
  -- author_id INTEGER NOT NULL,
  -- parent_reply_id INTEGER,

INSERT INTO 
  replies (body, subject_question_id, author_id, parent_reply_id)
VALUES
  (
  'instance methods are applied on instances of the class',
  1,
  2,
  NULL 
  ),
  (
  'Also class methods applies directly on class name',
  1,
  3,
  1
  ),
  (
  'SELECT, FROM, WHERE, INSERT, GROUP BY',
  2,
  1, 
  NULL
  ),
  (
  'Everything runs at the same time',
  3,
  3,
  NULL
  ),
  (
  'Javascript',
  4,
  2,
  NULL
  );

-- id INTEGER PRIMARY KEY,
--   likes_question_id INTEGER NOT NULL,
--   liker_id INTEGER NOT NULL,

INSERT INTO
  question_likes (likes_question_id, liker_id)
VALUES
  (1,2),
  (3,3),
  (3,4),
  (4,1),
  (4,2),
  (4,3),
  (4,4),
  (4,5);