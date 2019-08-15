""" NoSQL database demo with Python - using MongoDB

	NoSQL databases look at the data they store as key-value pairs, as indexed documents, and
	even as graphs. Because the stored data is not "normalized" as in a relational database,
	retrieval can be faster, and is definitely simpler.

	Two common NoSQL databases are "Redis" and "MongoDB".


	MongoDB is designed to scale across many nodes in multiple clusters, while potentially
	handling billions of documents.

	A document is stored in a "BSON" format (Binary JSON), with a document consisting of
	key-value pairs and looks like a JSON object or Python dictionary.

	MongoDB is good for:
	* Situations requiring scale and distribution of data.
	* High insert rate.
	* Complex and unstable schemas.

	MongoDB also has commands to operate over multiple documents, including "find_many()" and "update_many()".
	MongoDB also supports indexing to improve performance.
	MongoDB has several methods to group, count, and aggregate data, and a built-in map-reduce method.

	See also:
	http://zetcode.com/python/pymongo/
	https://api.mongodb.com/python/current/tutorial.html
	https://www.w3schools.com/python/python_mongodb_update.asp


	We start by installing a Python MongoDB client:
		pip install pymongo
		or
		python3 -m pip install --user pymongo


	As with Redis, we need to run a MongoDB server. Again, using a docker container is the
	easiest way to create one. On Linux Mint 19.1:
		sudo apt install docker
		sudo apt install docker.io
		sudo docker run -p 27017:27017 mongo

"""

from pymongo import MongoClient

mongo = MongoClient(host='localhost', port=27017)

# MongoDB contains "collections", each of which can contain documents.
# Make a sample document, i.e. a Python dictionary.
import datetime
a_document = {	'name': 'Jane',
		'age': 34,
		'interests': ['Python', 'databases', 'statistics' ],
		'date_added': datetime.datetime.now()	}

db = mongo.my_data		;# Here we select a database that doesn't exist yet.
collection = db.docs		;# Select a collection in the database, which also doesn't exist yet.
collection.find_one()		;# Searches for first item. Note that this doesn't throw an exception, even though the database doesn't exist yet.
print(db.collection_names())	;# 

# To add a document, we use the collection's "insert()" method, which also returns a unique document "ObjectId" (if successful):
id = collection.insert(a_document)
#print(id)
print(db.collection_names())

# Retrieve the first document.
print("First document:")
print(collection.find_one())
#print(type(collection.find_one()))

# Update document.
print("Before update:")
for x in collection.find():
	print(x)
collection.update_one({"name":"Jane"}, {"$set":{"name":"JANET"}}) 
print("After update:")
for x in collection.find():
	print(x)

# To remove our collection.
#collection.drop()
#print(db.collection_names())

