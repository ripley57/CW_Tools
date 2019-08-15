""" NoSQL database demo with Python - using Redis

	NoSQL databases look at the data they store as key-value pairs, as indexed documents, and
	even as graphs. Because the stored data is not "normalized" as in a relational database,
	retrieval can be faster, and is definitely simpler.

	Two common NoSQL databases are "Redis" and "MongoDB".

	Redis is an in-memory networked key:value store. Lookups can be fast. It is usually used
	for caching, as a message broker, and for quick lookups of information. 

	"Redis" is short for "Remote Dictionary Server". It behaves much like a remote Python 
	dictionary, but as a network service.	

	See also:
		https://redis.io
		https://redislabs.com
		https://redis-py.readthedocs.io


	We start by installing the recommended Python Redis client:
		pip install redis
		or
		python3 -m pip install --user redis


	NOTE: This demo requires a Redis server. 

	To install the "Redis Docker" instance on Linux Mint 19.1:
		sudo apt install docker
		sudo apt install docker.io

		$ sudo docker run -p 6379:6379 redis
		Unable to find image 'redis:latest' locally
		latest: Pulling from library/redis
		1ab2bdfe9778: Pull complete 
		...
		1:M 15 Aug 2019 17:19:13.092 * Ready to accept connections

	You should now see port 6379 being used:
		$ sudo netstat -tnlp | grep 6379
		tcp6       0      0 :::6379                 :::*                    LISTEN      14777/docker-proxy

"""

import redis

r = redis.Redis(host='localhost', port=6379)

# Get a list of the keys currently in the database.
print(r.keys())

# Add something.
r.set('a_key', 'my value')
print(r.keys())
v = r.get('a_key')
print(v)


# Create an array named "words".
r.rpush("words", "one")			;# Append value to array.
r.rpush("words", "two")
r.rpush("words", "three")
r.lpush("words", "front")		;# Prepend value to array.
print(r.llen("words"))
print(r.lrange("words", 0, -1))		;# From first item to end of the array.
print(r.lrange("words", 2, 2))
print(r.lindex("words", 1))
print(r.lindex("words", 2))


# Key-value pair expiration.
#
# This is a feature that makes Redis really useful as a cache.
# Set a value with a 10 secs timeout:
r.set("timed", "10 seconds", ex=10)
# We can use "pttl" to see the time remaining before expiration:
print(r.pttl("timed"))
print(r.pttl("timed"))
print(r.pttl("timed"))
print(r.pttl("timed"))


# NOTE: Redis stores its data in memory. However, there are options to manage persistence.
#
#	* Every change can be written too disk as it occurs.
#	* You can make period snapshots, in Python using "save()" (blocking) or "bgsave()"
#	  (non-blocking).
#
