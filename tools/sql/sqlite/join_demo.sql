/*
** SQL JOIN DEMO using SQLite
**
** Windows sqlite3.exe download:
** https://www.sqlite.org/2019/sqlite-tools-win32-x86-3280000.zip
**
** Linux sqlite3 download:
** https://www.sqlite.org/2019/sqlite-tools-linux-x86-3280000.zip
**
** SQLite command-line reference:
** http://tool.oschina.net/uploads/apidocs/sqlite/sqlite.html
**
** SQLite tutorial:
** http://www.sqlitetutorial.net/sqlite-tutorial/
**
** How to import an SQL file into SQLite:
** https://stackoverflow.com/questions/2049109/how-do-i-import-sql-files-into-sqlite-3
**
** Differences with MySQL:
** https://stackoverflow.com/questions/22554630/sql-lite-near-unsigned-syntax-error
**
** Configuring a foreign key:
** We use a foregin key to enforce the relationship between our "user"
** and "course" tables. For each row in the "user" table, there should be
** one corresponding row in the "course" table. Currently there is no 
** mechanism to enforce this. To enforce this relationship, we will use
** a foreign key constraint. See http://www.sqlitetutorial.net/sqlite-foreign-key/
**
**
** sqlite3.exe usage examples:
**
** To create our database file and import our SQL file:
** sqlite3.exe demo.db ".read join_demo.sql"
**
** Execute SQLite command without entering the SQLite command prompt:
** sqlite3.exe demo.db "select * from user"
**
** To exit from inside SQLite command-line prompt:
** sqlite>.exit 0
**
** List tables in the db:
** sqlite3.exe demo.db ".table"
**
** To exit from inside the SQLite command prompt:
** sqlite>.exit 0
**
**
** JeremyC 22-06-2019
*/

DROP TABLE IF EXISTS user;
CREATE TABLE user (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_name VARCHAR(30) NOT NULL,
  course_id INTEGER DEFAULT NULL,
  FOREIGN KEY(course_id) REFERENCES course(course_id)
);
CREATE INDEX user_idx ON user(user_id);

INSERT INTO user VALUES (1,'Alice', 1);
INSERT INTO user VALUES (2,'Bob', 1);
INSERT INTO user VALUES (3,'Carloine', 2);
INSERT INTO user VALUES (4,'David', 5);
INSERT INTO user VALUES (5,'Emma', NULL);

DROP TABLE IF EXISTS course;
CREATE TABLE course (
	course_id INTEGER PRIMARY KEY AUTOINCREMENT,
	course_name VARCHAR(50) NOT NULL
);
CREATE INDEX course_idx ON course(course_id);

INSERT INTO course VALUES (1, 'HTML');
INSERT INTO course VALUES (2, 'CSS3');
INSERT INTO course VALUES (3, 'JavaScript');
INSERT INTO course VALUES (4, 'PHP');
INSERT INTO course VALUES (5, 'MySQL');

  
/*
** Tables:
**
** "user" table:
** +---------+-----------+-----------+
** | user_id | user_name | course_id |
** +---------+-----------+-----------+
** |       1 | Alice     |         1 |
** |       2 | Bob       |         1 |
** |       3 | Carloine  |         2 |
** |       4 | David     |         5 |
** |       5 | Emma      |      NULL |
** +---------+-----------+-----------+
**
** "course" table:
** +-----------+-------------+
** | course_id | course_name |
** +-----------+-------------+
** |         1 | HTML        |
** |         2 | CSS3        |
** |         3 | JavaScript  |
** |         4 | PHP         |
** |         5 | MySQL       |
** +-----------+-------------+
*/
    
/*
** INNER JOIN
**
** This is the most frequently used join.
** This lists records which match in both the "user" and "course" tables.
**
** $ sqlite3.exe demo.db "SELECT user.user_name, course.course_name FROM user INNER JOIN course on user.course_id = course.course_id"
** +----------+-------+
** | name     | name  |
** +----------+-------+
** | Alice    | HTML  |
** | Bob      | HTML  |
** | Carloine | CSS3  |
** | David    | MySQL |
** +----------+-------+
*/

/*
** LEFT JOIN
**
** This produces a set of records which matches every entry in the left table,
** regardless of any matching entry in the right table.
**
** Example 1: 
** sqlite3.exe demo.db "SELECT user.user_name, course.course_name FROM user LEFT JOIN course on user.course_id = course.course_id"
** +-----------+-------------+
** | user_name | course_name |
** +-----------+-------------+
** | Alice     | HTML        |
** | Bob       | HTML        |
** | Carloine  | CSS3        |
** | David     | MySQL       |
** | Emma      | NULL        |
** +-----------+-------------+ 
**
** Example 2: 
** sqlite3.exe demo.db "SELECT course.course_name, COUNT(user.user_name) FROM course LEFT JOIN user ON user.course_id = course.id GROUP BY course.course_id'
** +------------+------------------+
** | name       | COUNT(user.name) |
** +------------+------------------+
** | HTML       |                2 |
** | CSS3       |                1 |
** | JavaScript |                0 |
** | PHP        |                0 |
** | MySQL      |                1 |
** +------------+------------------+
*/

