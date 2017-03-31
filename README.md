# Collabora CODE
Dockerfile and scripts to generate a Collabora CODE Docker image

Connection variables
--------------------

These environment variables can be used to set the config file:

* `SSL`:  Enable/disable ssl (default: `true`) 
* `SSL_CN`: Set the cert common name when ssl is enabled  (default: `localhost`)
* `SSL_C`:  Set the cert country when ssl is enabled (default: `NL`)
* `SSL_ST`: Set the cert state when ssl is enabled (default: `Noord-Holland`)
* `SSL_L`:  Set the cert location when ssl is enabled (default: `Amsterdam`)
* `MAX_CONCURRENCY`: The maximum number of threads to use while processing a document (default: `4`)
* `NUM_PRESPAWN_CHILDREN`: Number of child processes to keep started in advance and waiting for new clients (default: `1`)
* `LOG_LEVEL`: Set the log level. Can be 0-8, or none, fatal, critical, error, warning, notice, information, debug, trace (default: `warning`)
* `MAX_FILE_SIZE`: Maximum document size in bytes to load. 0 for unlimited (default: `0`)
* `HOSTS_ALLOWED`: External hosts allowed to access Collabora (default: `localhost`)

Github Repo
-----------

https://github.com/jrohde/Docker-CODE (forked from CollaboraOnline/Docker-CODE)
