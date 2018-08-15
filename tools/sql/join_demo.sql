/*
** SQL JOIN DEMO
**
** https://www.sitepoint.com/understanding-sql-joins-mysql-database/
**
** To import this sql:
** mysql -e "create database jeremy"
** mysql jeremy < join_demo.sql
*/

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `course` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `user` VALUES (1,'Alice', 1);
INSERT INTO `user` VALUES (2,'Bob', 1);
INSERT INTO `user` VALUES (3,'Carloine', 2);
INSERT INTO `user` VALUES (4,'David', 5);
INSERT INTO `user` VALUES (5,'Emma', NULL);

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `course` VALUES (1, 'HTML');
INSERT INTO `course` VALUES (2, 'CSS3');
INSERT INTO `course` VALUES (3, 'JavaScript');
INSERT INTO `course` VALUES (4, 'PHP');
INSERT INTO `course` VALUES (5, 'MySQL');

ALTER TABLE `user` ADD CONSTRAINT `FK_course` FOREIGN KEY (`course`) REFERENCES `course` (`id`) ON UPDATE CASCADE;

/* Note: This is a bad design: a student can only be enrolled on zero or one course! */
  
/*
** Table content:
**
** $ mysql jeremy -e "SELECT * from user"
** +----+----------+--------+
** | id | name     | course |
** +----+----------+--------+
** |  1 | Alice    |      1 |
** |  2 | Bob      |      1 |
** |  3 | Carloine |      2 |
** |  4 | David    |      5 |
** |  5 | Emma     |   NULL |
** +----+----------+--------+
**
** $ mysql jeremy -e "SELECT * from course"
** +----+------------+
** | id | name       |
** +----+------------+
** |  1 | HTML       |
** |  2 | CSS3       |
** |  3 | JavaScript |
** |  4 | PHP        |
** |  5 | MySQL      |
** +----+------------+
*/
    
/*
** INNER JOIN
**
** This is the most frequently used join.
** 
** This lists records which match in both the "user" and "course" tables,
** i.e. this lists all users who are enrolled on a course.
**
** $ mysql jeremy -e "SELECT user.name, course.name FROM user INNER JOIN course on user.course = course.id"
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
** i.e. this lists all students and their courses even if the're not enrolled on one.
**
** $ mysql jeremy -e "SELECT user.name, course.name FROM user LEFT JOIN course on user.course = course.id"
** +----------+-------+
** | name     | name  |
** +----------+-------+
** | Alice    | HTML  |
** | Bob      | HTML  |
** | Carloine | CSS3  |
** | David    | MySQL |
** | Emma     | NULL  |
** +----------+-------+ 
**
** Example: Number of students enrolled on each course:
** mysql jeremy -e 'SELECT course.name, COUNT(user.name) FROM course LEFT JOIN user ON user.course = course.id GROUP BY course.id'
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

/* 
** RIGHT JOIN
**
** This produces a set of records which matches every entry in the right table,
** regardless of any matching entry in the left table.
** i.e. this lists all courses and students even if no one has been enrolled on a particular course.
**
** $ mysql jeremy -e "SELECT user.name, course.name FROM user RIGHT JOIN course on user.course = course.id"
** +----------+------------+
** | name     | name       |
** +----------+------------+
** | Alice    | HTML       |
** | Bob      | HTML       |
** | Carloine | CSS3       |
** | David    | MySQL      |
** | NULL     | JavaScript |
** | NULL     | PHP        |
** +----------+------------+
**
** Note: RIGHT JOINS are rarely used, since you can express the same result using a LEFT JOIN, 
**       by simply swapping the table in the "FROM" clause:
** $ mysql jeremy -e "SELECT user.name, course.name FROM course LEFT JOIN course on user.course = course.id"
*/

/*
** OUTSER JOIN
**
** This returns all records in both tables, regardless of any match.
** When no match exists, the missing side will contain a NULL.
**
** Note: OUTER JOIN is less useful than INNER LEFT or RIGHT, and is not even implemented
**       in MySQL. However, you can work around this using the UNION of a LEFT and RIGHT 
**       JOIN.
**
** $ mysql jeremy -e 'SELECT user.name, course.name FROM user LEFT JOIN course on user.course = course.id UNION SELECT user.name, course.name FROM user RIGHT JOIN course on user.course = course.id'   
** +----------+------------+
** | name     | name       |
** +----------+------------+
** | Alice    | HTML       |
** | Bob      | HTML       |
** | Carloine | CSS3       |
** | David    | MySQL      |
** | Emma     | NULL       |
** | NULL     | JavaScript |
** | NULL     | PHP        |
** +----------+------------+
*/
