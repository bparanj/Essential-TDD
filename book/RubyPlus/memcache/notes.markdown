# Memcached #

Memcached stands for Memory Cache Daemon. It is a server that caches key-value pairs in memory. It can store any data such as results from database, Html fragments, binary objects. Retrieving the cached value from memory is faster than getting it from disk. So applications using memcached are scalable. It is intened for use in speeding up dynamic web applications.

Database driven dynamic Web applications that does not use memcache has to query the database server for sending response back to the client. The database server retrieves the data from the disk and returns it to the web server to generate dynamic html and send the response back to the client. 

Web applications that uses memcached checks the memcached and if the data is found it returns the data. Otherwise the results of the database query is stored in memcached so that they can be used for subsequent requests. This extra work has some overhead but it makes up for the faster data access for subsequents requests.

The data is not persisted.

# Installation

On MacOS you can install memcached using MacPort.

To install type:

sudo port install memcached

To start the memcached server, type:

memcached -vv

This will run the server in verbose mode. You can also run it as a daemon:

memcached -d

For installation on other OS, refer the wiki at http://memcached.org/


# Redis #

Redis is a key-value store, often called as a NoSQL database. We can store a value for a given key. We can later retrieve the value using the same key. 

# Installation 

http://redis.io/download


# Interacting with Redis 

You can interact with Redis using the built-in client:

$ src/redis-cli

set character 'bunny'

The data is stored permanently.

get character

'bunny'







