See https://sqlitebrowser.org/ for "DB Browser for SQLite". This UI tool is handy for creating an SQLite db file from a CSV. 

See also this Jupyter Notebook SQLite demo: https://www.youtube.com/watch?v=l3qfjfyGztY

This Jupyter Notebook looks like it could be a good way to learn SQLite:
https://github.com/royalosyin/Practice-SQL-with-SQLite-and-Jupyter-Notebook
If you are indeed using SQLite from a Jupyter Notebook, the following SQLite
url example can be used to connect to a pre-existing database file (on Windows):
%%sql sqlite:///D:/demo.db
SELECT * FROM user

JeremyC 31-12-2019
