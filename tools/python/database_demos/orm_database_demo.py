"""
	Mixing SQL statements with Python code is messy.

	An "Object Relational Mapper (ORM)" converts, or maps, relational database types and
	structures to objects in Python. Two of the most popular ORMs are "Django ORM" and
	"SQLAlchemy".
	Django ORM is tightly integrated with the Django web framework, and usually isn't
	used outside of it. For this reason, this demo will use SQLAlchemy. To install:

	pip install sqlalchemy
	or
	python3 -m pip install --user sqlalchemy

	NOTE:	An ORM still lets you write SQL statements, but the real power is in mapping
		the relational database tables and columns to Python objects. By changing the
		create engine string, this code will work with sqlite3, MySQL and PostgreSQL,
		without making any code changes. Therefore this is one very good reason to
		use ORM.
"""

from sqlalchemy import create_engine, select, MetaData, Table, Column, Integer, String
from sqlalchemy.orm import sessionmaker
import os

try:
    os.remove('database2.db')
except OSError:
    pass

dbPath = 'database2.db'
engine = create_engine('sqlite:///%s' % dbPath)
metadata = MetaData(engine)	;# A container for managing tables and their schemas.
people = Table('people', metadata,
		Column('id', Integer, primary_key=True),
		Column('name', String),
		Column('count', Integer),
		)
Session = sessionmaker(bind=engine)
session = Session()
metadata.create_all(engine)


# Insert some records...
people_ins = people.insert().values(name='Bob', count=1)
print(str(people_ins))	;# This should display the INSERT statement created behind the scenes.
session.execute(people_ins)
# And here's a slightly different way to insert some records...
session.execute(people_ins, [
	{'name': 'Jill', 'count': 15},
	{'name': 'Joe', 'count': 10}
])
session.commit()


#  Querying the database...
result = session.execute(select([people]))
for row in result:
	print(row)

# With a "where" clause...
result = session.execute(select([people]).where(people.c.name == 'Jill'))	;# 'c' indicates column name
for row in result:
	print(row)


# Another update, with a "where" clause...
result = session.execute(people.update().values(count=20).where(people.c.name == 'Jill'))
session.commit()
result = session.execute(select([people]).where(people.c.name == 'Jill'))
for row in result:
	print(row)


#
# Now we'll map a Python class directly to a table!
#
# The table columns will be mapped directly to the attributes in our class.

from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()
class People(Base):
	__tablename__ = "people"
	id = Column(Integer, primary_key=True)
	name = Column(String)
	count = Column(Integer)

results = session.query(People).filter_by(name='Jill')
for person in results:
	print(person.id, person.name, person.count)


# Now for an insert using our class...
new_person = People(name='Jane', count=5)
session.add(new_person)
session.commit()
results = session.query(People).all()
for person in results:
	print(person.id, person.name, person.count)


# Now an update using our class...
jill = session.query(People).filter_by(name='Jill').first()
print(jill.name)
jill.count = 22
session.add(jill)
session.commit()
for person in results:
	print(person.id, person.name, person.count)


# A delete using our class...
jane = session.query(People).filter_by(name='Jane').first()
session.delete(jane)
session.commit()
jane = session.query(People).filter_by(name='Jane').first()
print(jane)

