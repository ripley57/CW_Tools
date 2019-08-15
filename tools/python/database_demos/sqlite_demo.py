""" Demo showing how to use SQLite with Python

	NOTE: 	Because of a standardised API for Python databases "DB-API" (https://www.python.org/dev/peps/pep-0249/),
		demos like this should LARGELY work with SQLite, PostgreSQL, and MySQL, etc. However, there are
		still some differences with the SQL syntax they support, and with the way paramters are passed in
		SQL queries.

	sqlite3 is part of the standard Python library.

	sqlite3 is perfect for small applications or quick prototypes, but not suitable for higher traffic.
	It uses a local file (or memory), so it doesn't require a special client to connect to it.
"""

import sqlite3
import os

try:
    os.remove("database.db")
except OSError:
    pass

# NOTE: You can also use ":memory:" as the filename, as the data will be held in memory.
conn = sqlite3.connect("database.db")
cursor = conn.cursor()
# We can now make queries against the datbase...

# Create a table and add some records...
cursor.execute("create table people (id integer primary key, name text, count integer)")
cursor.execute("insert into people (name, count) values ('Bob', 1)")
# This is the prefered way to do it:
cursor.execute("insert into people (name, count) values (?, ?)", ("Jill", 15))
# You can also do it like this using an input dict:
cursor.execute("insert into people (name, count) values (:username, :usercount)", {"username":"Joe", "usercount":10})

# NOTE: You need to call this! But this does mean that we have the option of rolling back a transaction :-).
conn.commit()


# Querying out table...
result = cursor.execute("select * from people")
print(result.fetchall())
result = cursor.execute("select * from people where name like :name", {"name":"bob"})
print(result.fetchall())
cursor.execute("update people set count=? where name=?", (20, "Jill"))
result = cursor.execute("select * from people")
print(result.fetchall())

# Iterating of a result...
result = cursor.execute("select * from people")
for row in result:
	print(row)


# To see the tables in your database:
print(engine.table_names())


# NOTE: The close() method does not automatically call the commit() method.
conn.commit()
conn.close()

