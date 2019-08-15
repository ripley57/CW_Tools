""" Using Alembic to track schema changes in our database. 

	From https://pypi.org/project/alembic/:
		"Alembic is a database migrations tool written by the author of SQLAlchemy. 
		A migrations tool offers the following functionality:
    			* Can emit ALTER statements to a database in order to change the structure 
			  of tables and other constructs.
    			* Provides a system whereby “migration scripts” may be constructed; each script 
			  indicates a particular series of steps that can “upgrade” a target database to
			  a new version, and optionally a series of steps that can “downgrade” similarly, 
			  doing the same steps in reverse.
    			* Allows the scripts to execute in some sequential manner.

	Using Alembic, 'migrations' (i.e. schema changes) are written as Python code, and are given 
	revision numbers, with the current revision being stored inside the database itself, in the 
	'alembic_version' table, so that Alembic knows what revision the database is currently at.
	You can then run the Alembic "upgrade" and "downgrade" commands to switch instantly between 
	the different schema configurations, without needing to do this manually.

	NOTE: To go through the steps in this demo, first run the "orm_database_demo.py" demo, to
	create the "database2.db" SQLite database file (in the current directory):
		python3 orm_database_demo.py

	First we need to install Alembic:
		pip install alembic
		or
		python3 -m pip install --user alembic

	Next we create a set of files for using "alembic" using this:
		alembic init alembic

	This creates the file structure needed for data migrations including an "alembic.ini" file:
  		Creating directory /home/jcdc/learning_python3/alembic ... done
		...
		Please edit configuration/connection/logging settings in '/home/jcdc/learning_python3/alembic.ini' before proceeding
	(I ran this command from the directory "/home/jcdc/learning_python3")
	
	Now we change the following in the "alembic.ini" file...
		sqlalchemy.url = driver://user:pass@localhost/dbname
	...to this...
		sqlalchemy.url = sqlite:///database2.db
	(Remember, you don't need a username/password when using SQLite, because it's a local file)

	Now we create an Alembic revision:
		alembic revision -m "create an address table"
  		Generating /home/jcdc/learning_python3/alembic/versions/c0560e47caa8_create_an_address_table.py ... done

	This has created a Python "revision script" file. The "down_revision" value in this script guides the
	rollback of each revision. Therefore, if we were to make a second revision, the "down_revision" 
	value of that script would point to this script's "Revision ID" value. Now we add our 'upgrade' and 
	'downgrade' methods to our revision script "c0560e47caa8_create_an_address_table.py":

	def upgrade():
		op.create_table(
			'address',
			sa.Column('id', sa.Integer, primary_key=True),
			sa.Column('address', sa.String(50), nullable=False),
			sa.Column('city', sa.String(50), nullable=False),
			sa.Column('state', sa.String(20), nullable=False),
		)

	def downgrade():
		op.drop_table('address')

	When we now run the Alembic "upgrade" command, we should see that this new 'address' table
	has been created in our database:
		alembic upgrade head

	We now have the new 'address' table (plus an Alembic version-tracking table named 'alembic_version'):
		python3 
		...
		>>> from sqlalchemy import create_engine
		>>> engine = create_engine('sqlite:///%s' % 'database2.db')
		>>> print(engine.table_names())
		['address', 'alembic_version', 'people']

	To downgrade, by one version, i.e. rollback to the earlier database state, we do this (from the cli):
		alembic downgrade -1
	Because we only have one revision at the moment, "downgrade -1" leaves the 'alembic_version' table 
	in the database but it now contains zero records. Before the downgrade is contained "c0560e47caa8".
"""

