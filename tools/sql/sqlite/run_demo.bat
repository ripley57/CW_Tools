@echo off

rem Create database file and import our SQL file:
IF EXIST demo.db DEL /F demo.db
sqlite3.exe demo.db ".read join_demo.sql"

rem List contents of the user table:
echo.
echo "user" table:
sqlite3.exe demo.db "select * from user"

rem List contents of the course table:
echo.
echo "course" table:
sqlite3.exe demo.db "select * from course"

rem Perform a join to display the course name associated with each user:
echo.
echo inner join:
sqlite3.exe demo.db "SELECT user.user_name, course.course_name FROM user INNER JOIN course on user.course_id = course.course_id"

rem Use a left join
echo.
echo left join:
sqlite3.exe demo.db "SELECT course.course_name, COUNT(user.user_name) FROM course LEFT JOIN user ON user.course_id = course.course_id GROUP BY course.course_id"

rem Use a right join - RIGHT AND OUTER JOINS NOT SUPPORTED BY SQLITE !
echo.
echo right join:
sqlite3.exe demo.db "SELECT user.user_name, course.course_name FROM user RIGHT JOIN course ON course.course_id = course.id"
